//
//  ViewController.m
//  sampleObjectC
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//
#import <Photos/Photos.h>
#import "ChatNewViewController.h"
#import "EmakeServers-Swift.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "MessageEventModel.h"
#import "MessageModel.h"
#import "MessageEventCollectionViewCell.h"
#import "YHShoppingCartModel.h"
#import "YHShoppingCartConfirmViewController.h"
#import "YYHContractDisplayViewController.h"
#import "YHUserAuditedViewController.h"
#import "SKFPreViewNavController.h"
#import "SuPhotoPicker.h"
#import "SuPhotoHeader.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "YHConvenientReplyViewController.h"
#import "YHProductClassifyViewController.h"
#import "YHGoodsModel.h"
#import "YHFileModel.h"
#import "YHFileOptionViewController.h"
#import "YHClassifyBottomView.h"
#import "YHMessageClassifyMainViewController.h"
#import "YHArchiveModel.h"
#import "MQTTCommandModel.h"
#import "YHChatContractModel.h"
#import "ChatVoiceModel.h"
#import "YHMessageClassifyOrderViewController.h"
#import "YHCustomServersListViewController.h"
#import "YHMessageListViewController.h"
#import "YHGroupModel.h"
#import "YHMissonCreatSuccessView.h"
@interface ChatNewViewController ()<IMUINewInputViewDelegate, IMUIMessageMessageCollectionViewDelegate,YHMQTTClientDelegate,MessageEventCollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YBPopupMenuDelegate>{
    NSString *lastTimeSendMessage;
}
@property (weak, nonatomic) IBOutlet IMUIMessageCollectionView *messageList;
@property (weak, nonatomic) IBOutlet IMUINewInputView *imuiInputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distance;
@property (nonatomic,copy)NSString *pasteText;
@property (nonatomic,assign)float KeyFrameIndex;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) UIDocumentInteractionController *docVC;
@property (assign, nonatomic) NSMutableArray *chatListArray;
@property (strong, nonatomic) YHClassifyBottomView *bottomView;
@property (strong, nonatomic) NSMutableArray *chatListSelectArray;
@property (nonatomic,assign)NSInteger messageMaxCount;
@end

@implementation ChatNewViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clearBadge];
    self.topHeight.constant = TOP_BAR_HEIGHT;
    self.chatListSelectArray = [NSMutableArray arrayWithCapacity:0];
    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    self.messageMaxCount = [[FMDBManager sharedManager] getTheMaxMessageIdWithUserId:self.listID];
    if (!self.isLookUpArchive) {
        [self sendCommandMessageWithLastMessageId:0];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearBadge];
    //语音停止播放
    [[FMDBManager sharedManager] updateUserMessageCount:0 withUserId:self.listID];
    [[IMUIAudioPlayerHelper sharedInstance] stopAudio];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.titleName == nil) {
        self.title = self.userName;
    }else{
       self.title = self.titleName;
    }
    self.page = 0;
    [self addRightNavBtn:@"结束咨询"];
    self.chatListSelectArray = [NSMutableArray arrayWithCapacity:0];
    [self.messageList.messageCollectionView registerClass:[MessageEventCollectionViewCell class] forCellWithReuseIdentifier:[[MessageEventCollectionViewCell class] description]];
    self.messageList.delegate = self;
    self.imuiInputView.inputViewDelegate = self;
    [YHMQTTClient sharedClient].delegate = self;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSomething)];
    [self.messageList.messageCollectionView addGestureRecognizer:gesture];
    self.messageList.messageCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.messageList.messageCollectionView.mj_header beginRefreshingWithCompletionBlock:^{
        if (self.isUploadFile){
            self.isUploadFile = false;
            [self sendFileMessageWithFilePath:self.filePath];
        }
        [self doSomething];
    }];
}

- (void)rightBtnClick:(UIButton *)sender{
    YHMissonCreatSuccessView *view = [[YHMissonCreatSuccessView alloc] initDisbandView];
    view.block = ^(NSString *msg) {
        NSString *topic;
        if ([self.listID containsString:@"_"]) {
            NSArray *array = [self.listID componentsSeparatedByString:@"_"];
            topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
        }else{
            topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
        }
        //退订
        [[YHMQTTClient sharedClient] unSubcriceMessageTopic:topic];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [view showAnimated];

}
//加载聊天数据
- (void)loadMoreData{
    self.page++;
    if (![[FMDBManager sharedManager] isNotMessageExistWithLastMessageId:self.messageMaxCount andPage:self.page andWithUserId:self.listID]) {
        if (self.messageMaxCount <= (self.page-1)*10) {
            [self.messageList.messageCollectionView.mj_header endRefreshing];
            return;
        }
        NSInteger lastMessageID = self.messageMaxCount - (self.page-1)*10;
        [self sendCommandMessageWithLastMessageId:lastMessageID];
        [self.messageList.messageCollectionView.mj_header endRefreshing];
    }else{
        [[FMDBManager sharedManager] getAllMessageWithPage:self.page andLastMessageID:self.messageMaxCount andWithUserId:self.listID success:^(NSArray *responseObject){
            [self.messageList.messageCollectionView.mj_header endRefreshing];
            [self displayHistoryList:responseObject];
        } failure:^(NSString *errorObject) {
            [self.messageList.messageCollectionView.mj_header endRefreshing];
            [self.view makeToast:errorObject duration:1.0 position:CSToastPositionCenter];
        }];
    }
}
- (void)doSomething{
    
    [self.imuiInputView hideFeatureView];
}
- (void)clearBadge{
    
    [[FMDBManager sharedManager] updateUserMessageCount:0 withUserId:self.listID];
}
//展示历史消息
- (void)displayHistoryList:(NSArray *)insertLiatData{

    for (SDChatMessage *msg in insertLiatData){
        NSString *timeString = msg.sendTime;
        BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:msg.sendTime ValidTime:nil andValidTimeInterval:3];
        lastTimeSendMessage = msg.sendTime;
        if (!isNeedShow) {
            timeString = @"";
        }
        UserModel *user = [UserModel new];
        user.serversAvata = msg.staffAvata;
        user.displayUserName = msg.staffName;
        user.phoneNumber = msg.phoneNumber;
        user.isOutgoing = [msg.sender integerValue];
        if ([msg.msgType isEqualToString:@"Text"] ) {
            MessageModel *message = [[MessageModel alloc] initWithText:msg.msg messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [self.messageList insertMessageWith:message];
        }else if ([msg.msgType isEqualToString:@"Image"] ){
            MessageModel *message = [[MessageModel alloc] initWithImagePath:msg.msg messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [self.messageList insertMessageWith: message];
        }else if ([msg.msgType isEqualToString:@"Order"] ){
            MessageEventModel *eventModel = [[MessageEventModel alloc]initWithMsgId:msg.msgID eventText:msg.msg sendTime:timeString];
            [self.messageList insertMessageWith:eventModel];
        }else if ([msg.msgType isEqualToString:@"MutilePart"]){
            YHChatContractModel *contractmodel = [YHChatContractModel mj_objectWithKeyValues:msg.msg];
            MessageModel *message = [[MessageModel alloc] initWithText:msg.msg ContractNo:contractmodel.Contract ContractImagePath:contractmodel.Image ContractURL:contractmodel.Url messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [self.messageList insertMessageWith: message];
        }else if ([msg.msgType isEqualToString:@"Goods"]){
            MessageModel *message = [[MessageModel alloc] initWithProductJsonText:msg.msg messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:(id<IMUIUserProtocol>)user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [self.messageList insertMessageWith:message];
        }else if([msg.msgType isEqualToString:@"Voice"]){
            ChatVoiceModel *Voicemodel = [ChatVoiceModel mj_objectWithKeyValues:msg.msg];
            NSString *fileName = [Voicemodel.voicePath lastPathComponent];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getVoicePath:fileName]]) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:Voicemodel.voicePath]];
                if (data.bytes>0&&data) {
                    [data writeToFile:[Tools getVoicePath:fileName] atomically:YES];
                }
            }
            MessageModel *message = [[MessageModel alloc] initWithVoicePath:[Tools getPath:fileName] duration:[Voicemodel.duration integerValue] messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [_messageList insertMessageWith: message];
        }else if([msg.msgType isEqualToString:@"File"]){
            YHFileModel *fileModel = [YHFileModel mj_objectWithKeyValues:msg.msg];
            NSString *fileName = [NSString stringWithFormat:@"%@_%@",msg.msgID,fileModel.FileName];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getPath:fileName]]) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileModel.FilePath]];
                if (data.bytes>0&&data) {
                    [data writeToFile:[Tools getPath:fileName] atomically:YES];
                }
            }
            MessageModel *message = [[MessageModel alloc] initWithFileText:msg.msg messageId:msg.msgID messageUUID:msg.messgaeUUID fromUser:user timeString:timeString isOutgoing:[msg.sender integerValue] status:IMUIMessageStatusSuccess];
            [_messageList insertMessageWith: message];
        }
    }
    if (self.page == 1) {
        if (self.messageList.chatDataManager.count>=2) {
            [self.messageList.messageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.messageList.chatDataManager.count-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }

    }
}
//图片
- (NSString *)getPath:(NSString *)UUID {
    
    return [NSString stringWithFormat:@"https://img-emake-cn.oss-cn-shanghai.aliyuncs.com/images/%@.png", UUID];
}
//语音
- (NSString *)getVoicePath:(NSString *)MessageId {
    
    return [NSString stringWithFormat:@"https://voi-emake-cn.oss-cn-shanghai.aliyuncs.com/mqtt/%@.m4a",MessageId];
}
//文件
- (NSString *)getFilePath:(NSString *)MessageId andFileName:(NSString *)fileName{
    
    return [NSString stringWithFormat:@"https://voi-emake-cn.oss-cn-shanghai.aliyuncs.com/files/%@_%@",MessageId,fileName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// - MARK: IMUIInputViewDelegate
- (void)messageCollectionView:(UICollectionView * _Nonnull)willBeginDragging {
    [_imuiInputView hideFeatureView];
}
- (void)keyBoardWillShowWithHeight:(CGFloat)height durationTime:(double)durationTime{
    self.distance.constant = height;
    self.KeyFrameIndex = HeightRate(height);
    if (ScreenWidth == 320){
        self.KeyFrameIndex = self.KeyFrameIndex + HeightRate(40);
        height = height + 10;
    }
    [self.messageList scrollToBottomWith:YES];
    if(self.messageList.messageCollectionView.contentSize.height<HeightRate(300)) {
        return;
    }
    [self.messageList.messageCollectionView setContentOffset:CGPointMake(0, self.messageList.messageCollectionView.contentSize.height+ height + HeightRate(100) - ScreenHeight) animated:YES];
}
//发送请求消息指令
- (void)sendCommandMessageWithLastMessageId:(NSInteger)lastMessageId{
    if (self.listID.length <=0|| !self.listID) {
        [self.view makeToast:@"数据库存储错误" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *serverID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ServiceID];
    NSString *user_id;
    NSString *storeID;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        user_id = array[1];
        storeID = array[0];
    }else{
        user_id = self.listID;
    }
    NSString *topic = [NSString stringWithFormat:@"customer/%@",serverID];
    MQTTCommandModel *model = [[MQTTCommandModel alloc] creatMessageListCMD:user_id andStoreId:storeID lastMessageId:lastMessageId];
    [[YHMQTTClient sharedClient] sendCommmand:[model mj_keyValues] withSelfTopic:topic complete:^(NSError *error) {
    }];
}
#pragma mark ==== IMUINewInputViewDelegate
/// Tells the delegate that user tap send button and text input string is not empty
- (void)showOptionView{
    if (self.messageList.messageCollectionView.contentSize.height < (ScreenHeight-130)) {
        return;
    }
    [self.messageList.messageCollectionView setContentOffset:CGPointMake(0, self.messageList.messageCollectionView.contentSize.height-ScreenHeight+130+130) animated:YES];
}
//发送文字
- (void)sendTextMessage:(NSString * _Nonnull)messageText {
    
    NSString *messageIdString = [[NSUUID UUID] UUIDString];
    chatNewModel *model = [self creatMessageModelData:messageText andType:@"Text" messageIdString:messageIdString];
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    //发送消息
    NSString *timeString = [NSDate getCurrentTime];
    NSString *lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    UserModel *user = [UserModel new];
    user.isOutgoing = true;
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
        [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
            if (!error) {
                MessageModel *message = [[MessageModel alloc] initWithText:messageText messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
                [self.messageList addMessageOrderWith:message];
                [self.messageList scrollToBottomWith:YES];
            }else{
                MessageModel *message = [[MessageModel alloc] initWithText:messageText messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
                [self.messageList appendMessageWith:message];
                [self.messageList scrollToBottomWith:YES];
            }
            
        }];
    }else{
        MessageModel *message = [[MessageModel alloc] initWithText:messageText messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
        [self.messageList appendMessageWith:message];
        [self.messageList scrollToBottomWith:YES];
    }
    
}

//拍照
- (void)didSelectShootPicture{
    
    [[SuPhotoCenter shareCenter] cameraAuthoriationValidWithHandle:^{
        [self launchCamera];
    }];
}
//相册
- (void)didSeletedGallery{
    
    [self albumBrowser];
}
//快捷回复
- (void)didSelectConnvientReply{
    YHConvenientReplyViewController *vc = [[YHConvenientReplyViewController alloc]init];
    vc.replyBlock = ^(NSString *text) {
        [self sendTextMessage:text];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//产品
- (void)didSelectProduct{
    YHProductClassifyViewController *vc = [[YHProductClassifyViewController alloc]init];
    vc.productBlock = ^(YHGoodsModel *GoodsModel) {
        NSString *messageIdString = [[NSUUID UUID] UUIDString];
        UserModel *user = [UserModel new];
        user.isOutgoing = true;
        NSString *timeString = [NSDate getCurrentTime];
        self.messageMaxCount = self.messageMaxCount + 1;
        NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
        lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
        BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
        lastTimeSendMessage = timeString;
        if (!isNeedShow) {
            timeString = @"";
        }
        NSString *msg = [GoodsModel mj_JSONString];
        chatNewModel *model = [self creatMessageModelData:msg andType:@"Goods" messageIdString:messageIdString];
        NSString *topic;
        if ([self.listID containsString:@"_"]) {
            NSArray *array = [self.listID componentsSeparatedByString:@"_"];
            topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
        }else{
            topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
        }
        if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
            [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                if (!error) {
                    MessageModel *message = [[MessageModel alloc] initWithProductJsonText:msg messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
                    [self.messageList addMessageOrderWith: message];
                    [self.messageList scrollToBottomWith:YES];
                }else{
                    MessageModel *message = [[MessageModel alloc] initWithProductJsonText:msg messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
                    [self.messageList appendMessageWith: message];
                    [self.messageList scrollToBottomWith:YES];
                }
            }];
        }else{
            MessageModel *message = [[MessageModel alloc] initWithProductJsonText:msg messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
            [self.messageList appendMessageWith: message];
            [self.messageList scrollToBottomWith:YES];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/// Tells the delegate that IMUIInputView will switch to recording voice mode
- (void)switchToMicrophoneModeWithRecordVoiceBtn:(UIButton * _Nonnull)recordVoiceBtn {
    
}
/// Tells the delegate that start record voice
- (void)startRecordVoice{
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:60];
}

- (void)stopRecord{
    IMUIRecordVoiceCell *cell = (IMUIRecordVoiceCell *)[self.imuiInputView.functionView.featureCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell finishRecordVoice];
}
/// Tells the delegate when finish record voice
- (void)finishRecordVoice:(NSString * _Nonnull)voicePath durationTime:(double)durationTime{
    if (((int)durationTime)<1) {
        [self.view makeToast:@"录音时间太短" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *messageIdString = [[NSUUID UUID] UUIDString];
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    UserModel *user = [UserModel new];
    user.isOutgoing = true;
    NSString *timeString = [NSDate getCurrentTime];
    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    [[OSSClientLike sharedClient] uploadVoiceObjectAsync:voicePath withFileName:messageIdString andType:voice succcessBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            chatNewModel *model = [self creatMessageModelData:[NSString stringWithFormat:@"%d",(int)durationTime] andType:@"Voice" messageIdString:messageIdString];
            if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
                [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                    if (!error) {
                        MessageModel *  message = [[MessageModel alloc] initWithVoicePath:voicePath duration:durationTime messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusSuccess];
                        [_messageList addMessageOrderWith: message];
                        [self.messageList scrollToBottomWith:YES];
                    }else{
                        MessageModel * message = [[MessageModel alloc] initWithVoicePath:voicePath duration:durationTime messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
                        [_messageList appendMessageWith:message];
                        [self.messageList scrollToBottomWith:YES];
                    }
                }];
            }else{
                MessageModel *  message = [[MessageModel alloc] initWithVoicePath:voicePath duration:durationTime messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
                [_messageList appendMessageWith: message];
                [self.messageList scrollToBottomWith:YES];
            }
        });
        
    } failBLock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MessageModel *message = [[MessageModel alloc] initWithVoicePath:voicePath duration:durationTime messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
            [_messageList appendMessageWith: message];
            [self.messageList scrollToBottomWith:YES];
        });
        
    }];
}

- (void)cancelRecordVoice{
    
}
/// Tells the delegate that IMUIInputView will switch to gallery
- (void)switchToGalleryModeWithPhotoBtn:(UIButton * _Nonnull)photoBtn {
    
}
/// Tells the delegate that user did selected Photo in gallery
- (void)didSeletedGalleryWithAssetArr:(NSArray<PHAsset *> * _Nonnull)AssetArr {
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    for (PHAsset *asset in AssetArr) {
        switch (asset.mediaType) {
            case PHAssetMediaTypeImage: {
                
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                options.synchronous  = YES;
                options.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize: CGSizeMake(ScreenWidth, ScreenHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    
                    NSString *messageIdString = [[NSUUID UUID] UUIDString];
                    NSString *timeString = [NSDate getCurrentTime];
                    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
                    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
                    lastTimeSendMessage = timeString;
                    if (!isNeedShow) {
                        timeString = @"";
                    }
                    NSString *filePath = [self getPath:messageIdString];
                    UserModel *user = [UserModel new];
                    user.isOutgoing = true;
                    NSString *topic;
                    if ([self.listID containsString:@"_"]) {
                        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
                        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
                    }else{
                        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
                    }
                    NSString *fileName = [NSString stringWithFormat:@"%@.png",messageIdString];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getPath:fileName]]) {
                        NSData *data = UIImageJPEGRepresentation(result, 1.0);
                        if (data.bytes>0&&data) {
                            [data writeToFile:[Tools getPath:fileName] atomically:YES];
                        }
                    }
                    [[OSSClientLike sharedClient] uploadObjectAsync:result withFileName:messageIdString andType:image succcessBlock:^{
                        chatNewModel *model = [self creatMessageModelData:filePath andType:@"Image" messageIdString:messageIdString];
                        //发送消息
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
                                [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                                    if (!error) {
                                        MessageModel *message = [[MessageModel alloc] initWithImagePath:filePath messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusSuccess];
                                        [self.messageList addMessageOrderWith:message];
                                        [self.messageList scrollToBottomWith:YES];
                                    }else{
                                        MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                                        [_messageList appendMessageWith: message];
                                        [self.messageList scrollToBottomWith:YES];
                                    }
                                }];
                            }else{
                                MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                                [_messageList appendMessageWith: message];
                                [self.messageList scrollToBottomWith:YES];
                            }
                        });
                        
                    }failBLock:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                            [_messageList appendMessageWith: message];
                            [self.messageList scrollToBottomWith:YES];
                        });
                    }];
                }];
                break;
            }
            default:
                break;
        }
    }
}
/// Tells the delegate that IMUIInputView will switch to camera mode
- (void)switchToCameraModeWithCameraBtn:(UIButton * _Nonnull)cameraBtn {
    
}
/// Tells the delegate that user did shoot picture in camera mode
- (void)didShootPictureWithPicture:(NSData * _Nonnull)picture {
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    NSString *messageIdString = [[NSUUID UUID] UUIDString];
    NSString *filePath = [self getPath:messageIdString];
    UserModel *user = [UserModel new];
    user.isOutgoing = true;
    NSString *timeString = [NSDate getCurrentTime];
    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    UIImage *imgae =[UIImage imageWithData:picture];
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.png",messageIdString];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getPath:fileName]]) {
        if (picture.bytes>0&&picture) {
            [picture writeToFile:[Tools getPath:fileName] atomically:YES];
        }
    }
    [[OSSClientLike sharedClient] uploadObjectAsync:imgae withFileName:messageIdString andType:image succcessBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            chatNewModel *model = [self creatMessageModelData:[self getPath:messageIdString] andType:@"Image" messageIdString:messageIdString];
            //发送消息
            if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
                [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                    if (!error) {
                        MessageModel *message = [[MessageModel alloc] initWithImagePath:filePath messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusSuccess];
                        [self.messageList addMessageOrderWith:message];
                        [self.messageList scrollToBottomWith:YES];
                    }else{
                        MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                        [_messageList appendMessageWith:message];
                        [self.messageList scrollToBottomWith:YES];
                    }
                }];
            }else{
                MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                [_messageList appendMessageWith:message];
                [self.messageList scrollToBottomWith:YES];
            }
            
        });
    } failBLock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                MessageModel *message = [[MessageModel alloc] initWithImagePath:[Tools getPath:fileName] messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:true status:IMUIMessageStatusFailed];
                [_messageList appendMessageWith:message];
                [self.messageList scrollToBottomWith:YES];
            });
        });
    }];
}
/// Tells the delegate when starting record video
- (void)startRecordVideo {
    
}
/// Tells the delegate when user did shoot video in camera mode
- (void)finishRecordVideoWithVideoPath:(NSString * _Nonnull)videoPath durationTime:(double)durationTime {

}
//发送文件
- (void)sendFileMessageWithFilePath:(NSString *)filePath{
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    NSString *messageIdString = filePath;
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    UserModel *user = [UserModel new];
    user.isOutgoing = true;
    NSString *timeString = [NSDate getCurrentTime];
    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    [self.fileData writeToFile:[self getPath:@""] atomically:YES];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    YHFileModel *fileModel = [[YHFileModel alloc]init];
    fileModel.FileName = self.fileName;
    fileModel.FileSize = [Tools fileSizeWithInterge:self.fileData.length];
    fileModel.FilePath = [self getFilePath:messageIdString andFileName:self.fileName];
    NSString *jsonStr = [fileModel mj_JSONString];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@",messageIdString,fileModel.FileName];
    [[OSSClientLike sharedClient] uploadFileObjectAsync:self.fileData withFileName:fileName andType:file succcessBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            chatNewModel *model = [self creatMessageModelData:jsonStr andType:@"File" messageIdString:messageIdString];
            if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
                [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                    if (!error) {
                        MessageModel *message = [[MessageModel alloc] initWithFileText:jsonStr messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusSuccess];
                        [self.messageList addMessageOrderWith:message];
                        [self.messageList scrollToBottomWith:YES];
                    }else{
                        MessageModel *message = [[MessageModel alloc] initWithFileText:jsonStr messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
                        [_messageList appendMessageWith: message];
                        [self.messageList scrollToBottomWith:YES];
                    }
                }];
            }else{
                MessageModel *message = [[MessageModel alloc] initWithFileText:jsonStr messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
                [_messageList appendMessageWith: message];
                [self.messageList scrollToBottomWith:YES];
            }
            
        });
    } failBLock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MessageModel *message = [[MessageModel alloc] initWithFileText:jsonStr messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:YES status:IMUIMessageStatusFailed];
            [_messageList appendMessageWith: message];
            [self.messageList scrollToBottomWith:YES];
        });
        
    }];
    
}
//构建消息体
- (chatNewModel *)creatMessageModelData:(NSString *)messageText andType:(NSString *)type messageIdString:(NSString *)MessageId{
    
    NSString *ServiceID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ServiceID]];
    NSString *userID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID]];
    NSString *nickname = [NSString stringWithFormat:@"客服%@",ServiceID];;
    NSString *clientId = [NSString stringWithFormat:@"customer/%@",ServiceID];
    chatUserModel *userModel = [[chatUserModel alloc]initWith:[Tools getHeadImageURL] formId:userID displayName:nickname clientID:clientId];
    NSDictionary *userDic = [userModel mj_keyValues];
    chatBodyModel *bodyModel = nil;
    if ([type isEqualToString:@"Image"]) {
        bodyModel = [[chatBodyModel alloc]initWithImage:messageText Type:type];
    }else if ([type isEqualToString:@"Text"]){
        bodyModel = [[chatBodyModel alloc]initWithText:messageText Type:type];
    }else if ([type isEqualToString:@"MutilePart"]){
        YHChatContractModel *Contractmodel = [YHChatContractModel mj_objectWithKeyValues:messageText];
        bodyModel = [[chatBodyModel alloc]initWithImage:Contractmodel.Image Text:Contractmodel.Text ImageUrl:Contractmodel.ImageUrl Url:Contractmodel.Url Type:type contract:Contractmodel.Contract contractType:Contractmodel.ContractType contractState:Contractmodel.ContractState isIncludeTax:Contractmodel.IsIncludeTax];
    }else if ([type isEqualToString:@"Goods"]){
        bodyModel = [[chatBodyModel alloc]initWithText:messageText Type:type];
    }else if ([type isEqualToString:@"Voice"]){
        NSString *fileNamePath = [NSString stringWithFormat:@"https://voi-emake-cn.oss-cn-shanghai.aliyuncs.com/mqtt/%@.m4a",MessageId];
        bodyModel = [[chatBodyModel alloc]initWithVoicePath:fileNamePath voiceDuration:messageText Type:@"Voice"];
    }else if ([type isEqualToString:@"File"]){
        YHFileModel *fileModel = [YHFileModel mj_objectWithKeyValues:messageText];
        NSString *filePath = [NSString stringWithFormat:@"https://voi-emake-cn.oss-cn-shanghai.aliyuncs.com/files/%@_%@",MessageId,fileModel.FileName];
        bodyModel = [[chatBodyModel alloc]initWithText:messageText FilePath:filePath Type:@"File"];
    }
    NSDictionary *bodyDic = [bodyModel mj_keyValues];
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    chatNewModel *model = [[chatNewModel alloc]initWithId:topic messageType:@"Message" messageId:MessageId user:userDic andMessageBody:bodyDic];
    return model;
}
//添加到数据库
- (void)addMessageToFMDB:(NSDictionary *)message topic:(NSString *)topic{
    
    chatNewModel *model = [chatNewModel mj_objectWithKeyValues:message];
    chatBodyModel *body = [chatBodyModel mj_objectWithKeyValues:model.MessageBody];
    chatUserModel *form = [chatUserModel mj_objectWithKeyValues:model.From];
    NSDictionary *dic = nil;
    NSString *timeString = [Tools stringFromTimestamp:model.Timestamp];
    NSString *sender = @"0";
    NSString *myUserID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
    NSArray *arr = [topic componentsSeparatedByString:@"/"];
    if (arr.count < 2) {
        return;
    }
    NSString *user_id;
    if (arr.count == 2) {
        user_id = arr[1];
    }else if (arr.count == 3){
        user_id = [NSString stringWithFormat:@"%@_%@",arr[1],arr[2]];
    }
    if ([form.UserId isEqualToString:myUserID]) {
        sender = @"1";
    }else{
        sender = @"0";
    }
    if (form.UserType.length <=0||form.UserType == nil) {
        form.UserType = @"";
    }
    if (form.Avatar.length <=0||form.Avatar == nil) {
        form.Avatar = @"";
    }
    if (form.PhoneNumber.length <=0||form.PhoneNumber == nil) {
        form.PhoneNumber = @"";
    }
    if (form.DisplayName.length <=0||form.DisplayName == nil) {
        form.DisplayName = @"";
    }
    if (form.Group.length <=0||form.Group == nil) {
        form.Group = @"";
    }
    if ([body.Type isEqualToString:@"Text"]) {
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type?body.Type:@"",@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType.length>0?form.UserType:@"",@"phoneNumber":form.PhoneNumber.length>0?form.PhoneNumber:@"",@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Image"]){
        dic = @{@"msg":body.Image,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Order"]) {
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"MutilePart"]){
        YHChatContractModel *ContractModel = [[YHChatContractModel alloc] init];
        ContractModel.Text = body.Text;
        ContractModel.Image = body.Image;
        ContractModel.Url = body.Url;
        ContractModel.Contract = body.Contract;
        ContractModel.ContractType = body.ContractType;
        ContractModel.ContractState = body.ContractState;
        dic = @{@"msg":[ContractModel mj_JSONString],@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Goods"]){
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Voice"]){
        ChatVoiceModel *voicemodel = [[ChatVoiceModel alloc] init];
        voicemodel.duration = [NSString stringWithFormat:@"%ld",(long)body.VoiceDuration];
        voicemodel.voicePath = body.Voice;
        dic = @{@"msg":[voicemodel mj_JSONString],@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"File"]){
        YHFileModel *fileModel = [YHFileModel mj_objectWithKeyValues:body.Text];
        fileModel.FilePath = body.Url;
        NSString *jsonText = [fileModel mj_JSONString];
        dic = @{@"msg":jsonText,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }
    SDChatMessage *msg = [SDChatMessage chatMessageWithDic:dic];
    //处理聊天列表
    //这个人的消息列表
    if ([[FMDBManager sharedManager] userIsExist:user_id]) {
        if ([self.listID containsString:@"_"]) {
            NSString *jsonStr = [[FMDBManager sharedManager] getStoreInfoFromUserList:user_id];
            if (jsonStr.length > 0) {
                msg.group = jsonStr;
                NSInteger count = [[FMDBManager sharedManager] getUserMessageCount:user_id];
                count = count + 1;
                NSArray *partArr = [form.ClientID componentsSeparatedByString:@"/"];
                if (partArr.count == 3) {
                    [[FMDBManager sharedManager] deleteUserList:user_id];
                    [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
                }
            }
        }else{
            NSString *jsonStr = [[FMDBManager sharedManager] getUserInfoFromUserList:user_id];
            if (jsonStr.length > 0) {
                SDChatMessage *ChatMessage = [SDChatMessage mj_objectWithKeyValues:jsonStr];
                NSInteger count = [[FMDBManager sharedManager] getUserMessageCount:user_id];
                count = count + 1;
                ChatMessage.msg = msg.msg;
                ChatMessage.msgID = msg.msgID;
                ChatMessage.sender = msg.sender;
                ChatMessage.sendTime = msg.sendTime;
                ChatMessage.msgType = msg.msgType;
                ChatMessage.messageCount = [NSString stringWithFormat:@"%ld",(long)count];
                [[FMDBManager sharedManager] deleteUserList:user_id];
                [[FMDBManager sharedManager] addUserList:ChatMessage andUserID:user_id andMessageCount:count];
            }
        }
    }else{
        NSInteger count = 0;
        count = count + 1;
        NSArray *array = [form.ClientID componentsSeparatedByString:@"/"];
        if ([user_id containsString:@"_"]) {
            if (array.count == 3) {
               [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
            }else{
                msg.staffName = self.userName;
                msg.staffType = self.userType;
                msg.staffAvata = self.userAvatar;
                msg.phoneNumber = self.phoneNumber;
                [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
            }
        }else{
            if ([form.ClientID containsString:@"user/"]) {
                [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
            }else{
                msg.staffName = self.userName;
                msg.staffType = self.userType;
                msg.staffAvata = self.userAvatar;
                msg.phoneNumber = self.phoneNumber;
                [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
            }
        }
    }
    //处理聊天数据
    if ([[FMDBManager sharedManager] userChatDataIsExist:user_id]){
        if (![[FMDBManager sharedManager] messageIsAlreadyExist:user_id withMessageId:model.MessageID]) {
            [[FMDBManager sharedManager] addMessage:msg andUserID:user_id];
        }
        
    }else{
        [[FMDBManager sharedManager] initMessageChatDataWithUserID:user_id];
        if (![[FMDBManager sharedManager] messageIsAlreadyExist:user_id withMessageId:model.MessageID]) {
            [[FMDBManager sharedManager] addMessage:msg andUserID:user_id];
        }
    }
}
#pragma mark========YHMQTTClientDelegate
-(void)onMessgae:(NSData *)messgae topic:(NSString *)topic{
    if (messgae) {
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:messgae options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dealWithMessage:payload topic:topic];
        });
        [self addMessageToFMDB:payload topic:topic];
    }
}
- (void)dealWithMessage:(NSDictionary *)payload topic:(NSString *)topic{
    
    NSString *myUserId = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
    chatNewModel *model = [chatNewModel mj_objectWithKeyValues:payload];
    chatBodyModel *body = [chatBodyModel mj_objectWithKeyValues:model.MessageBody];
    chatUserModel *form = [chatUserModel mj_objectWithKeyValues:model.From];
    NSString *timeString = [Tools stringFromTimestamp:model.Timestamp];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    //保证消息最大值
    if (self.messageMaxCount <= [model.MessageID integerValue]) {
        self.messageMaxCount = [model.MessageID integerValue];
    }
    //已存在的消息不展示
    if ([self.messageList.chatDataManager.allMsgidArr containsObject:model.MessageID]) {
        return;
    }
    NSArray *arr = [topic componentsSeparatedByString:@"/"];
    if (arr.count < 2) {
        return;
    }
    NSString *user_id;
    if (arr.count == 2) {
        user_id = arr[1];
    }else if (arr.count == 3){
        user_id = [NSString stringWithFormat:@"%@_%@",arr[1],arr[2]];
    }
    //不是这个人消息不展示
    if ([user_id isEqualToString:self.listID]) {
        UserModel *user = [UserModel new];
        if ([form.UserId isEqualToString:myUserId]) {
            user.serversAvata = @"";
            user.isOutgoing = true;
            user.displayUserName = [NSString stringWithFormat:@"客服%@",form.DisplayName];
            user.phoneNumber = form.PhoneNumber;
            user.clientId = form.ClientID;
        }else{
            user.serversAvata = form.Avatar;
            user.displayUserName = form.DisplayName;
            user.phoneNumber = form.PhoneNumber;
            user.isOutgoing = false;
            user.clientId = form.ClientID;
        }
        if ([body.Type isEqualToString:@"Text"]){
            MessageModel *message = [[MessageModel alloc] initWithText:body.Text messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [self.messageList addMessageOrderWith:message];
        }else if ([body.Type isEqualToString:@"Image"]){
            MessageModel *message = [[MessageModel alloc] initWithImagePath:body.Image messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [self.messageList addMessageOrderWith: message];
        }else if ([body.Type isEqualToString:@"Order"]){
            MessageEventModel *eventModel = [[MessageEventModel alloc]initWithMsgId:model.MessageID eventText:body.Text sendTime:timeString];
            [self.messageList addMessageOrderWith:eventModel];
        }else if ([body.Type isEqualToString:@"MutilePart"]){
            YHChatContractModel *contractModel = [[YHChatContractModel alloc]init];
            contractModel.Text = body.Text;
            contractModel.Image = body.Image;
            contractModel.Url = body.Url;
            contractModel.Contract = body.Contract;
            contractModel.ContractType = body.ContractType;
            contractModel.ContractState = body.ContractState;
            MessageModel *message = [[MessageModel alloc] initWithText:[contractModel mj_JSONString] ContractNo:body.Contract ContractImagePath:body.Image ContractURL:body.Url messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [self.messageList addMessageOrderWith: message];
        }else if ([body.Type isEqualToString:@"Goods"]){
            MessageModel *message = [[MessageModel alloc] initWithProductJsonText:body.Text messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [self.messageList addMessageOrderWith: message];
        }else if ([body.Type isEqualToString:@"Voice"]){
            ChatVoiceModel *voicemodel = [[ChatVoiceModel alloc] init];
            voicemodel.duration = [NSString stringWithFormat:@"%ld",(long)body.VoiceDuration];
            voicemodel.voicePath = body.Voice;
            NSString *fileName = [voicemodel.voicePath lastPathComponent];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getVoicePath:fileName]]) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:body.Voice]];
                if (data.bytes>0&&data) {
                    [data writeToFile:[Tools getVoicePath:fileName] atomically:YES];
                }
            }
            MessageModel *message = [[MessageModel alloc] initWithVoicePath:[Tools getVoicePath:fileName] duration:body.VoiceDuration messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [_messageList addMessageOrderWith: message];
        }else if ([body.Type isEqualToString:@"File"]){
            YHFileModel *modelFile = [[YHFileModel alloc] init];
            if (self.isLookUpArchive) {
                NSArray *commponts = [body.Text componentsSeparatedByString:@"+"];
                NSString *partOne = commponts[0];
                NSString *partTwo = commponts[1];
                NSArray  *partOneArray = [partOne componentsSeparatedByString:@":"];
                NSArray  *partTwoArray = [partTwo componentsSeparatedByString:@":"];
                modelFile.FileName = partOneArray[1];
                modelFile.FileSize = partTwoArray[1];
            }else{
                modelFile = [YHFileModel mj_objectWithKeyValues:body.Text];
            }
            modelFile.FilePath = body.Url;
            NSString *fileName = [body.Url lastPathComponent];
            if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getPath:fileName]]) {
                [[OSSClientLike sharedClient] downloadFileObjectAsyncWithFileName:fileName andDownloadTargetFile:[Tools getPath:fileName] succcessBlock:^{
                    
                } failBLock:^{
                    
                }];
            }
            MessageModel *message = [[MessageModel alloc] initWithFileText:[modelFile mj_JSONString] messageId:model.MessageID messageUUID:model.MessageId fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
            [_messageList addMessageOrderWith: message];
        }
        if (([model.MessageID integerValue] < self.messageMaxCount) && (self.page!=1)) {
            return;
        }
        [self.messageList scrollToBottomWith:YES];
    }
    
}
- (void)onCommand:(NSData *)messgae topic:(NSString *)topic{
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:messgae options:NSJSONReadingMutableLeaves error:nil];
    MQTTCommandModel *commandModel = [MQTTCommandModel mj_objectWithKeyValues:payload];
    if ([commandModel.cmd isEqualToString:@"UserMessageList"]) {
        if (self.page <= 1) {
            self.messageMaxCount = commandModel.message_id_last;
            self.page = 0;
            [self.messageList.messageCollectionView.mj_header beginRefreshing];
        }
    }else if ([commandModel.cmd isEqualToString:@"UserRequestService"]||([commandModel.cmd isEqualToString:@"StoreRequestService"])) {
        UINavigationController  *nav = self.tabBarController.viewControllers[0];
        YHMessageListViewController *vc = nav.viewControllers[0];
        chatNewModel *model = [chatNewModel mj_objectWithKeyValues:commandModel.message_last];
        chatBodyModel *body = [chatBodyModel mj_objectWithKeyValues:model.MessageBody];
        chatUserModel *form  = nil;
        SDChatMessage *Message = [[SDChatMessage alloc] init];
        Message.sendTime = [Tools stringFromTimestamp:model.Timestamp];
        if ([commandModel.cmd isEqualToString:@"UserRequestService"]) {
            NSArray *userArray = [commandModel.user_info mj_JSONObject];
            if (userArray.count<=0) {
                return;
            }else{
                form = [chatUserModel mj_objectWithKeyValues:userArray[0]];
                Message.isStoreMessage = false;
                Message.staffType = form.UserType;
                Message.staffAvata = form.Avatar;
                Message.staffName = form.DisplayName;
                Message.phoneNumber = form.PhoneNumber;
            }
        }else{
            NSArray *userArray = [commandModel.user_info mj_JSONObject];
            if (userArray.count<=0) {
                return;
            }else{
                form = [chatUserModel mj_objectWithKeyValues:userArray[0]];
                Message.isStoreMessage = true;
                Message.staffType = form.UserType;
                Message.staffAvata = form.Avatar;
                Message.staffName = form.DisplayName;
                Message.phoneNumber = form.PhoneNumber;
                Message.group = form.Group;
                Message.sendTime = [NSDate getCurrentTime];
            }
        }
        NSArray *array = [commandModel.chatroom_id componentsSeparatedByString:@"/"];
        if (array.count == 1) {
            Message.userId = array[0];
        }else{
            Message.userId = [NSString stringWithFormat:@"%@_%@",array[0],array[1]];
        }
        Message.msg = body.Text;
        Message.msgType = body.Type;
        NSMutableArray *response = [NSMutableArray arrayWithArray:vc.responseArray];
        BOOL isContain = false;
        if (vc.responseArray.count <=0) {
            [response addObject:Message];
            vc.responseArray = response;
            [vc.tableView reloadData];
        }else{
            for (SDChatMessage *msg in response) {
                if ([msg.userId isEqualToString:Message.userId]) {
                    isContain = YES;
                    [response removeObject:msg];
                }
            }
            [response insertObject:Message atIndex:0];
            vc.responseArray = response;
            [vc.tableView reloadData];
        }
    }
}
#pragma mark ====IMUIMessageMessageCollectionViewDelegate
- (UICollectionViewCell *)messageCollectionViewWithMessageCollectionView:(UICollectionView *)messageCollectionView forItemAt:(NSIndexPath *)forItemAt messageModel:(id<IMUIMessageProtocol>)messageModel{
    if ([messageModel isKindOfClass: [MessageEventModel class]]) {
        MessageEventCollectionViewCell *cell = [messageCollectionView dequeueReusableCellWithReuseIdentifier:[[MessageEventCollectionViewCell class] description] forIndexPath:forItemAt];
        cell.delegate = self;
        MessageEventModel *model = (MessageEventModel *)messageModel;
        cell.timeView.text = model.sendTime;
        cell.eventText = model.evenText;
        [cell setData:model.evenText];
        return cell;
    } else {
        return nil;
    }
}
//点击
- (void)messageCollectionViewWithDidTapMessageBubbleInCell:(UICollectionViewCell * _Nonnull)didTapMessageBubbleInCell model:(id <IMUIMessageProtocol> _Nonnull)model{
    if (![model isKindOfClass: [MessageEventModel class]]) {
        MessageModel *modelPaste = (MessageModel *)model;
        if ([modelPaste.type isEqualToString:@"Image"]) {
            NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
            [browseItemArray addObject:modelPaste.mediaFilePath];
            SKFPreViewNavController *imagePickerVc =[[SKFPreViewNavController alloc]initWithSelectedPhotoURLs:browseItemArray index:0];
            imagePickerVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }else if ([modelPaste.type isEqualToString:@"Contract"]){
            YHChatContractModel *contract = [YHChatContractModel mj_objectWithKeyValues:modelPaste.text];
            YYHContractDisplayViewController *vc = [[YYHContractDisplayViewController alloc]init];
            vc.ContractURL = contract.Url;
            vc.sendDataStr = modelPaste.text;
            vc.contractNo = contract.Contract;
            vc.contractType = contract.ContractType;
            vc.block = ^(NSString *tips){
                if (tips) {
                    NSString *messageIdString = [[NSUUID UUID] UUIDString];
                    chatNewModel *model = [self creatMessageModelData:tips andType:@"MutilePart" messageIdString:messageIdString];
                    
                    UserModel *user = [UserModel new];
                    user.isOutgoing = true;
                    NSString *timeString = [NSDate getCurrentTime];
                    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
                    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
                    lastTimeSendMessage = timeString;
                    if (!isNeedShow) {
                        timeString = @"";
                    }
                    self.messageMaxCount = self.messageMaxCount + 1;
                    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
                    YHChatContractModel *contractModel = [YHChatContractModel mj_objectWithKeyValues:tips];
                    NSString *topic;
                    if ([self.listID containsString:@"_"]) {
                        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
                        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
                    }else{
                        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
                    }
                    if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
                        [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
                            if (!error) {
                                MessageModel *message = [[MessageModel alloc] initWithText:[contractModel mj_JSONString] ContractNo:contractModel.Contract ContractImagePath:contractModel.Image ContractURL:contractModel.Url messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
                                [self.messageList addMessageOrderWith: message];
                                [self.messageList scrollToBottomWith:YES];
                            }else{
                                MessageModel *message = [[MessageModel alloc] initWithText:[contractModel mj_JSONString] ContractNo:contractModel.Contract ContractImagePath:contractModel.Image ContractURL:contractModel.Url messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
                                [self.messageList appendMessageWith: message];
                                [self.messageList scrollToBottomWith:YES];
                            }
                        }];
                    }else{
                        MessageModel *message = [[MessageModel alloc] initWithText:[contractModel mj_JSONString] ContractNo:contractModel.Contract ContractImagePath:contractModel.Image ContractURL:contractModel.Url messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
                        [self.messageList appendMessageWith: message];
                        [self.messageList scrollToBottomWith:YES];
                    }
                   
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([modelPaste.type isEqualToString:@"File"]){
            YHFileOptionViewController *vc = [[YHFileOptionViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.fileModel = [YHFileModel mj_objectWithKeyValues:modelPaste.text];
            vc.filePath = modelPaste.msgId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//点击
- (void)messageCollectionViewWithDidTapHeaderImageInCell:(UICollectionViewCell *)didTapHeaderImageInCell model:(id<IMUIMessageProtocol>)model{
    [self.messageList endEditing:YES];
    MessageModel *modelAnother = (MessageModel *)model;
    if (!modelAnother.isOutGoing) {
        if (![self.listID containsString:@"_"]) {
            YHUserAuditedViewController *vc = [[YHUserAuditedViewController alloc]init];
            vc.userId = self.listID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//长按
- (void)messageCollectionViewWithBeganLongTapMessageBubbleInCell:(UICollectionViewCell * _Nonnull)beganLongTapMessageBubbleInCell model:(id <IMUIMessageProtocol> _Nonnull)model{
    [self becomeFirstResponder];
    IMUIBaseMessageCell *cellPaste = (IMUIBaseMessageCell *)beganLongTapMessageBubbleInCell;
    MessageModel *modelPaste = (MessageModel *)model;
    if ([modelPaste.type isEqualToString:@"Text"]) {
        self.pasteText = modelPaste.text;
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyBtnPressed:)];
        menuController.menuItems = @[copyItem];
        [menuController setTargetRect:cellPaste.bubbleView.frame inView:cellPaste.bubbleView.superview];
        [menuController setMenuVisible:YES animated:YES];
        [UIMenuController sharedMenuController].menuItems=nil;
    }
}
- (NSNumber * _Nullable)messageCollectionViewWithMessageCollectionView:(UICollectionView * _Nonnull)messageCollectionView heightForItemAtIndexPath:(NSIndexPath * _Nonnull)forItemAt messageModel:(id <IMUIMessageProtocol> _Nonnull)messageModel SWIFT_WARN_UNUSED_RESULT {
    if ([messageModel isKindOfClass: [MessageEventModel class]]) {
        NSNumber *number = [NSNumber numberWithFloat:HeightRate(240)];
        return number;
    } else {
        return nil;
    }
}
//Event点击调用
- (void)didTapMessageBubbleWithModel:(NSString *)eventText {
    YHShoppingCartConfirmViewController *vc = [[YHShoppingCartConfirmViewController alloc]init];
    vc.sendProtocolBlock = ^(chatBodyModel *model) {
        [self sendProtocol:model];
    };  
    vc.eventText = eventText;
    [self.navigationController pushViewController:vc animated:YES];
}
//发送协议
- (void)sendProtocol:(chatBodyModel *)chatBodyModel{
    NSString *messageIdString = [[NSUUID UUID] UUIDString];
    self.messageMaxCount = self.messageMaxCount + 1;
    NSString *MessageID = [NSString stringWithFormat:@"%ld",(long)self.messageMaxCount];
    YHChatContractModel *Contractmodel = [[YHChatContractModel alloc]init];
    Contractmodel.Text = chatBodyModel.Text;
    Contractmodel.Image = chatBodyModel.ImageUrl;
    Contractmodel.Url = chatBodyModel.Url;
    Contractmodel.Contract = chatBodyModel.Contract;
    Contractmodel.ContractType = chatBodyModel.ContractType;
    Contractmodel.ContractState = chatBodyModel.ContractState;
    Contractmodel.IsIncludeTax = chatBodyModel.IsIncludeTax;
    chatNewModel *model = [self creatMessageModelData:[Contractmodel mj_JSONString] andType:@"MutilePart" messageIdString:messageIdString];
    NSString *topic;
    if ([self.listID containsString:@"_"]) {
        NSArray *array = [self.listID componentsSeparatedByString:@"_"];
        topic = [NSString stringWithFormat:@"chatroom/%@/%@",array[0],array[1]];
    }else{
        topic = [NSString stringWithFormat:@"chatroom/%@",self.listID];
    }
    UserModel *user = [UserModel new];
    user.isOutgoing = true;
    NSString *timeString = [NSDate getCurrentTime];
    lastTimeSendMessage = [[FMDBManager sharedManager] getUserLastSendTime:self.listID];
    BOOL isNeedShow = [NSDate isValideTimeDifferenceWithTime:lastTimeSendMessage currentTime:timeString ValidTime:nil andValidTimeInterval:3];
    lastTimeSendMessage = timeString;
    if (!isNeedShow) {
        timeString = @"";
    }
    if ([[YHMQTTClient sharedClient] isMQTTConnect]) {
        [[YHMQTTClient sharedClient] sendMessage:[model mj_keyValues] withTopic:topic complete:^(NSError *error) {
            if (!error) {
                MessageModel *message = [[MessageModel alloc] initWithText:[Contractmodel mj_JSONString] ContractNo:Contractmodel.Contract ContractImagePath:Contractmodel.Image ContractURL:Contractmodel.Url messageId:MessageID messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusSuccess];
                [self.messageList addMessageOrderWith: message];
                [self.messageList scrollToBottomWith:YES];
            }else{
                MessageModel *message = [[MessageModel alloc] initWithText:[Contractmodel mj_JSONString] ContractNo:Contractmodel.Contract ContractImagePath:Contractmodel.Image ContractURL:Contractmodel.Url messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
                [self.messageList appendMessageWith: message];
                [self.messageList scrollToBottomWith:YES];
            }
        }];
    }else{
        MessageModel *message = [[MessageModel alloc] initWithText:[Contractmodel mj_JSONString] ContractNo:Contractmodel.Contract ContractImagePath:Contractmodel.Image ContractURL:Contractmodel.Url messageId:messageIdString messageUUID:messageIdString fromUser:user timeString:timeString isOutgoing:user.isOutgoing status:IMUIMessageStatusFailed];
        [self.messageList appendMessageWith: message];
        [self.messageList scrollToBottomWith:YES];
    }
}
#pragma mark---- Metthod
//相机
- (void)launchCamera {
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"相机启动失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //将该图像保存到媒体库中
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    //压缩图片 －> 以最长边为屏幕分辨率压缩
    CGSize size;
    CGFloat scale = image.size.width / image.size.height;
    if (scale > 1.0) {
        if (image.size.width < SCREEN_W) {
            //最长边小于屏幕宽度时，采用原图
            size = CGSizeMake(image.size.width, image.size.height);
        }else {
            size = CGSizeMake(SCREEN_W, SCREEN_W / scale);
        }
    }else {
        if (image.size.height < SCREEN_H) {
            //最长边小于屏幕高度时，采用原图
            size = CGSizeMake(image.size.width, image.size.height);
        }else {
            size = CGSizeMake(SCREEN_H * scale, SCREEN_H);
        }
    }
    image = [UIImage imageWithImage:image scaledToSize:size];
    [self didShootPictureWithPicture:UIImagePNGRepresentation(image)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//相册
- (void)albumBrowser {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    [[SuPhotoCenter shareCenter] fetchAllAsset];
    SuPhotoAblumList * ablumsList = [[SuPhotoAblumList alloc]init];
    ablumsList.assetCollections = [[SuPhotoManager manager] getAllAblums];
    UINavigationController * NVC = [[UINavigationController alloc]initWithRootViewController:ablumsList];
    //默认跳转到照片图册
    SuPhotoBrowser * browser = [[SuPhotoBrowser alloc]init];
    browser.blockSomething = ^(NSArray *imageArray) {
        [self didSeletedGalleryWithAssetArr:imageArray];
    };
    [ablumsList.navigationController pushViewController:browser animated:NO];
    [self.navigationController presentViewController:NVC animated:YES completion:nil];
}
-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem{
    [UIPasteboard generalPasteboard].string = self.pasteText;
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(menuCopyBtnPressed:)) {
        return YES;
    }
    return NO;
}
@end
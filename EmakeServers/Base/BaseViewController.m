//
//  BaseViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"
#import "Header.h"
#import "YHMessageListViewController.h"
#import "YHUserMainViewController.h"
#import "YHMineViewController.h"
#import "ChatNewViewController.h"
#import "YHFileModel.h"
#import "MQTTCommandModel.h"
#import "YHChatContractModel.h"
#import "ChatVoiceModel.h"
@interface BaseViewController ()<YHMQTTClientDelegate,YBPopupMenuDelegate>
@property (nonatomic, strong) UIButton * rightNavBtn;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, retain) NSArray * Titles;
@property (nonatomic, retain) NSArray * ICONS;
@property (nonatomic, strong) UIButton * informationCardBtn;
@property (nonatomic, assign) CGFloat widthDrop;
@end

@implementation BaseViewController
- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"direction_leftNew"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(-0, 0, 40, 40);
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10 );
        [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:NO];
    [YHMQTTClient sharedClient].delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)){
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self layoutCustomNavigationBar];
}
- (void)layoutCustomNavigationBar{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:StatusAndTopBarBackgroundColor]];
    //navbar背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundColor:[UIColor colorWithHexString:StatusAndTopBarBackgroundColor]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
    //去除边框
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}
- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIToolbar *)addToolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}
- (void)textFieldDone{
    
    [self.view endEditing:YES];
}
- (void)addRightNavBtn:(NSString *)title{
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNavBtn.frame = CGRectMake(20, 0, 30, 30);
    [self.rightNavBtn setTitle:title forState:UIControlStateNormal];
    self.rightNavBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
    [self.rightNavBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0 );
    [self.rightNavBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
}
- (void)setRightBtnImage:(NSString *)imageName{
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNavBtn.frame = CGRectMake(10, 0, 30, 30);
    [self.rightNavBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.rightNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0 );
    [self.rightNavBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
}
- (void)setRightBtnTitle:(NSString *)title{
    
    [self.rightNavBtn setTitle:title forState:UIControlStateNormal];
}
- (void)rightBtnClick:(UIButton *)sender{
    
}
- (void)leftDropBtnStyleClick:(UIButton *)sender{
    
}
- (void)changeLeftDropBtnStyleTitle:(NSString *)title{
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        if (item.tag == 102) {
            if ([item.customView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)item.customView;
                [button setTitle:title forState:UIControlStateNormal];
            }
            break;
        }
    }
}
- (void)addRigthDropBtn{
    self.widthDrop = WidthRate(120);
    self.Titles =  @[@"消息", @"平台", @"我"];
    self.ICONS =  @[@"xiaoxi-xiala",@"pingtai-xiala",@"wo-xiala"];
    self.informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.informationCardBtn setImage:[UIImage imageNamed:@"xiaoxi-r"] forState:UIControlStateNormal];
    [self.informationCardBtn addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    [self.informationCardBtn sizeToFit];
    
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:self.informationCardBtn];
    informationCardItem.tag = 100;
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = WidthRate(5);
    fixedSpaceBarButtonItem.tag = 101;
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.hidden = false;
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    settingBtnItem.tag = 102;
    self.navigationItem.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
}
- (void)showMenuView{
    
    [YBPopupMenu showRelyOnView:self.informationCardBtn titles:self.Titles icons:self.ICONS menuWidth:self.widthDrop messgaeCount:0  delegate:self];
}
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    switch (index) {
            //回到消息
        case 0:
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[YHMessageListViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            break;
            //回到平台
        case 1:{
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[YHUserMainViewController class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
            }
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
    
            break;
        }
            break;
        case 2:{
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark========YHMQTTClientDelegate
-(void)onMessgae:(NSData *)messgae topic:(NSString *)topic{
    if (messgae) {
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:messgae options:0 error:nil];
        BOOL isContain = false;
        chatNewModel *model = [chatNewModel mj_objectWithKeyValues:payload];
        chatBodyModel *body = [chatBodyModel mj_objectWithKeyValues:model.MessageBody];
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
        if ([[FMDBManager sharedManager] userChatDataIsExist:user_id]){
            if ([[FMDBManager sharedManager] messageIsAlreadyExist:user_id withMessageId:model.MessageID]) {
                return;
            }
        }
        if ([body.Type isEqualToString:@"Text"]) {
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:body.Text];
        }else if ([body.Type isEqualToString:@"Image"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[图片]"];
        }else if ([body.Type isEqualToString:@"Order"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[订单]"];
        }else if ([body.Type isEqualToString:@"MutilePart"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[合同]"];
        }else if ([body.Type isEqualToString:@"Goods"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[商品]"];
        }else if ([body.Type isEqualToString:@"Voice"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[语音]"];
        }else if ([body.Type isEqualToString:@"File"]){
            [[JZUserNotification sharedNotification] addNotificationWithCategroy1:@"[文件]"];
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ChatNewViewController class]]) {
                ChatNewViewController *chatVC = (ChatNewViewController *)vc;
                if (!chatVC.isLookUpArchive) {
                    [chatVC onMessgae:messgae topic:topic];
                    isContain = true;
                    break;
                }
            }
        }
        if (!isContain) {
            [self addMessageToFMDB:payload topic:topic];
        }
    }
}
- (void)onEvent:(MQTTMessage *)messgae topic:(NSString *)topic{
    
}
- (void)onCommand:(NSData *)messgae topic:(NSString *)topic{
    
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:messgae options:NSJSONReadingMutableLeaves error:nil];
    MQTTCommandModel *commandModel = [MQTTCommandModel mj_objectWithKeyValues:payload];
    if ([commandModel.cmd isEqualToString:@"UserRequestService"]||([commandModel.cmd isEqualToString:@"StoreRequestService"])) {
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
        if (vc.responseArray.count <=0) {
            [response addObject:Message];
            vc.responseArray = response;
            [vc.tableView reloadData];
        }else{
            for (int i=0; i<response.count; i++) {
                SDChatMessage *msg = [response objectAtIndex:i];
                if ([msg.userId isEqualToString:Message.userId]) {
                    [response removeObject:msg];
                }
            }
            [response insertObject:Message atIndex:0];
            vc.responseArray = response;
            [vc.tableView reloadData];
        }
    }
}
- (void)addMessageToFMDB:(NSDictionary *)message topic:(NSString *)topic{
    
    NSString *ServiceID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ServiceID]];
    NSString *clientId = [NSString stringWithFormat:@"customer/%@",ServiceID];
    chatNewModel *model = [chatNewModel mj_objectWithKeyValues:message];
    chatBodyModel *body = [chatBodyModel mj_objectWithKeyValues:model.MessageBody];
    chatUserModel *form = [chatUserModel mj_objectWithKeyValues:model.From];
    NSDictionary *dic = nil;
    NSString *timeString = [Tools stringFromTimestamp:model.Timestamp];
    NSString *sender;
    if ([form.ClientID isEqualToString:clientId]) {
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
    if (form.Group.length <=0||form.Group == nil) {
        form.Group = @"";
    }
    if ([body.Type isEqualToString:@"Text"]) {
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Image"]) {
        dic = @{@"msg":body.Image,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Order"]) {
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"MutilePart"]) {
        YHChatContractModel *contractModel = [[YHChatContractModel alloc]init];
        contractModel.Text = body.Text;
        contractModel.Image = body.Image;
        contractModel.Url = body.Url;
        contractModel.Contract = body.Contract;
        contractModel.ContractType = body.ContractType;
        contractModel.ContractState = body.ContractState;
        dic = @{@"msg":[contractModel mj_JSONString],@"msgID":model,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Goods"]) {
        dic = @{@"msg":body.Text,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"Voice"]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[Tools getVoicePath:model.MessageID]]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:body.Voice]];
            if (data.bytes>0&&data) {
                [data writeToFile:[Tools getVoicePath:model.MessageID] atomically:YES];
            }
        }
        ChatVoiceModel *voicemodel = [[ChatVoiceModel alloc] init];
        voicemodel.duration = [NSString stringWithFormat:@"%ld",(long)body.VoiceDuration];
        voicemodel.voicePath = body.Voice;
        dic = @{@"msg":[voicemodel mj_JSONString],@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }else if ([body.Type isEqualToString:@"File"]) {
        YHFileModel *fileModel = [YHFileModel mj_objectWithKeyValues:body.Text];
        fileModel.FilePath = body.Url;
        NSString *jsonStr = [fileModel mj_JSONString];
        dic = @{@"msg":jsonStr,@"msgID":model.MessageID,@"messgaeUUID":model.MessageId,@"sender":sender,@"sendTime":timeString,@"msgType":body.Type,@"staffName":form.DisplayName,@"staffAvata":form.Avatar,@"staffType":form.UserType,@"phoneNumber":form.PhoneNumber,@"group":form.Group};
    }
    SDChatMessage *msg = [SDChatMessage chatMessageWithDic:dic];
    //消息个数处理
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
    
    NSInteger count = [[FMDBManager sharedManager] getUserMessageCount:user_id];
    if ([[FMDBManager sharedManager] userChatDataIsExist:form.UserId]){
        if (![[FMDBManager sharedManager] messageIsAlreadyExist:form.UserId withMessageId:model.MessageID]) {
            count ++;
        }
    }
    
    //聊天列表处理
    if ([[FMDBManager sharedManager] userIsExist:user_id]) {
        if ([user_id containsString:@"_"]) {
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
                if ([form.ClientID containsString:@"user/"]) {
                    [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
                }
            }
        }else{
            [[FMDBManager sharedManager] addUserList:msg andUserID:user_id andMessageCount:count];
        }
    }
    //刷新列表
    if ([[Tools currentViewController] isKindOfClass:[YHMessageListViewController class]]) {
        YHMessageListViewController *vc = (YHMessageListViewController *)[Tools currentViewController];
        vc.chatListArray = [[FMDBManager sharedManager] getAllUserChatList];
        [vc.tableView reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

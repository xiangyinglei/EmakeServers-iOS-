//
//  YHFileSearchListViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/5/23.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHFileSearchListViewController.h"
#import "Header.h"
#import "ChatNewViewController.h"
#import "YHFileSendMessageListTableViewCell.h"
#import "YHSendFileTipsView.h"
@interface YHFileSearchListViewController ()<UITableViewDataSource,UITableViewDelegate,YHSendFileTipsViewDelegete>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)SDChatMessage *msg;
@end

@implementation YHFileSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择一个人聊天";
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubviews];
}
- (void)configSubviews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHFileSendMessageListTableViewCell *cell = nil;
    if (!cell) {
        cell =[[YHFileSendMessageListTableViewCell alloc]init];
    }
    [cell setData:self.modelList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.msg = self.modelList[indexPath.row];
    NSString *userName = @"";
    if (!self.msg.staffName||self.msg.staffName.length<=0) {
        userName = [NSString stringWithFormat:@"用户%@",[self.msg.phoneNumber substringFromIndex:self.msg.phoneNumber.length-4]];
    }else{
        userName = self.msg.staffName;
    }
    YHSendFileTipsView *FileTipsView = [[YHSendFileTipsView alloc] initWithDelegete:self andUserType:self.msg.staffType andUserName:userName andUserAvata:self.msg.staffAvata andFileName:self.fileName];
    [FileTipsView showAnimated];
}
#pragma mark ---- YHSendFileTipsViewDelegete
- (void)alertViewLeftBtnClick:(id)alertView{
    
}
- (void)alertViewRightBtnClick:(id)alertView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    NSString *userName = @"";
    if (!self.msg.staffName||self.msg.staffName.length<=0) {
        userName = [NSString stringWithFormat:@"用户%@",[self.msg.phoneNumber substringFromIndex:self.msg.phoneNumber.length-4]];
    }else{
        userName = self.msg.staffName;
    }
    vc.userName = userName;
    vc.listID = self.msg.userId;
    vc.userAvatar = self.msg.staffAvata;
    vc.userType = self.msg.staffType;
    vc.phoneNumber = self.msg.phoneNumber;
    vc.isUploadFile = YES;
    vc.filePath = self.filePath;
    vc.fileName = self.fileName;
    vc.fileData = self.fileData;
    [self.navigationController pushViewController:vc animated:YES];
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

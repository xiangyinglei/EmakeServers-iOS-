//
//  YHSearchViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/5.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHSearchViewController.h"
#import "Header.h"
#import "YHUserAuditTableViewCell.h"
#import "YHUserAuditedViewController.h"
#import "ChatNewViewController.h"
@interface YHSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;

@end

@implementation YHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索用户";
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
- (void)goChatVC:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    YHUserModel *model = self.modelList[sender.tag];
    vc.listID = model.UserId;
    vc.userAvatar = model.HeadImageUrl;
    vc.userType = model.UserIdentity;
    vc.userName = model.RealName;
    vc.phoneNumber = model.MobileNumber;
    NSString *topic = [NSString stringWithFormat:@"chatroom/%@",model.UserId];
    [[YHMQTTClient sharedClient] subcriceMessageTopic:topic];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHUserAuditTableViewCell *cell = nil;
    if (!cell) {
        cell =[[YHUserAuditTableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sendMessageBtn.tag = indexPath.row;
    [cell.sendMessageBtn addTarget:self action:@selector(goChatVC:) forControlEvents:UIControlEventTouchUpInside];
    [cell setData:self.modelList[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YHUserAuditedViewController *vc = [[YHUserAuditedViewController alloc]init];
    vc.model = self.modelList[indexPath.row];
    vc.userId = vc.model.UserId;
    
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

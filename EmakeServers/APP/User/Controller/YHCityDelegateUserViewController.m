//
//  YHCityDelegateUserViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/9/13.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHCityDelegateUserViewController.h"
#import "Header.h"
#import "YHUserAuditTableViewCell.h"
#import "YHUserAuditedViewController.h"
#import "YHUserAuditingViewController.h"
#import "YHSearchViewController.h"
#import "ChatNewViewController.h"
@interface YHCityDelegateUserViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataList;
@property (nonatomic,retain)NSMutableArray *searchList;
@property(nonatomic,assign)NSInteger indexPage;
@property (nonatomic,assign)BOOL isMaxPage;
@property (nonatomic,strong)UISearchBar *search;
@end

@implementation YHCityDelegateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isCityAudit) {
        self.title = @"待审核城市代理商";
    }else{
        self.title = @"城市代理商";
    }
    self.view.backgroundColor = TextColor_F7F7F7;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllUser) name:NotificationAuditUserRefresh object:nil];
    [self configSubViews];
    [self addRigthDropBtn];
}
- (void)configSubViews{
    
    self.search = [[UISearchBar alloc]init];
    self.search.placeholder = @"按手机号/姓名搜索";
    self.search.delegate = self;
    self.search.barTintColor = [UIColor whiteColor];
    self.search.searchBarStyle = UISearchBarStyleMinimal;
    self.search.backgroundColor = [UIColor clearColor];
    UITextField * searchField = [self.search valueForKey:@"_searchField"];
    [searchField setValue:TextColor_999999 forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.search];
    CGFloat topHeight = ScreenHeight == 812 ? 88 : 64;
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(15));
        make.right.mas_equalTo(WidthRate(-15));
        make.top.mas_equalTo(HeightRate(10)+topHeight);
        make.height.mas_equalTo(HeightRate(35));
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.search.mas_bottom).offset(HeightRate(15));
        make.bottom.mas_equalTo(0);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllUser)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    footer.automaticallyChangeAlpha = YES;
    [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.stateLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
    footer.automaticallyHidden = YES;
}
- (void)getAllUser{
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    self.indexPage = 1;
    [self.tableView.mj_footer resetNoMoreData];
    NSString *agentState;
    if (self.isCityAudit) {
        agentState = @"0";
    }else{
        agentState = @"1";
    }
    [[YHJsonRequest shared] getAppCityDelegateUserWithAgentState:agentState PageIndex:self.indexPage andPageSize:10 SuccessBlock:^(NSDictionary *dict) {
        NSArray *userDict = [dict objectForKey:@"Users"];
        if (userDict.count<=0) {
            [self.tableView.mj_header endRefreshing];
            [self.view hideWait:CurrentView];
            return;
        }
        if (userDict.count <= 10) {
            self.isMaxPage = YES;
        }
        for (NSDictionary *dict in userDict) {
            YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
            [self.dataList addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fialureBlock:^(NSString *errorMessages) {
        [self.tableView.mj_header endRefreshing];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)loadMoreData{
    NSInteger indexpath = 0;
    if (self.isMaxPage) {
       [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    indexpath = self.indexPage;
    NSString *agentState;
    if (self.isCityAudit) {
        agentState = @"0";
    }else{
        agentState = @"1";
    }
    [[YHJsonRequest shared] getAppCityDelegateUserWithAgentState:agentState PageIndex:indexpath andPageSize:10 SuccessBlock:^(NSDictionary *dict) {
        NSArray *userDict = [dict objectForKey:@"Users"];
        for (NSDictionary *dict in userDict) {
            YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
            [self.dataList addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (userDict.count <= 10) {
            self.isMaxPage = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fialureBlock:^(NSString *errorMessages) {
        self.indexPage = self.indexPage - 1;
        [self.tableView.mj_header endRefreshing];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)goChatVC:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    YHUserModel *model = nil;
    model = self.dataList[sender.tag];
    vc.listID = model.UserId;
    vc.userAvatar = model.HeadImageUrl;
    vc.userType = model.UserIdentity;
    vc.userName = model.RealName;
    vc.phoneNumber = model.MobileNumber;
    NSString *topic = [NSString stringWithFormat:@"chatroom/%@",model.UserId];
    [[YHMQTTClient sharedClient] subcriceMessageTopic:topic];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    self.searchList = [NSMutableArray arrayWithCapacity:0];
    if (!searchBar.text||searchBar.text.length<=0) {
        return;
    }
    NSDictionary *params = nil;
    if (self.isCityAudit) {
        params = @{@"SearchContent":self.search.text,@"pageIndex":@(1),@"pageSize":@(1000000),@"AgentState":@"0"};
    }else{
        params = @{@"SearchContent":self.search.text,@"pageIndex":@(1),@"pageSize":@(1000000),@"UserIdentity":@"1",@"AgentState":@"1"};
    }
    [[YHJsonRequest shared] searchUserWithMoblieNumberWithParameter:params SucceededBlock:^(YHUserMainModel *model) {
        if (model.UserRows.count>0) {
            for (NSDictionary *dict in model.UserRows) {
                YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
                [self.searchList addObject:model];
            }
        }
        YHSearchViewController *vc = [[YHSearchViewController alloc]init];
        vc.modelList = self.searchList;
        vc.isFromAduit = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSString *errorMessage) {
        [self.view makeToast:errorMessage duration:1.0 position:CSToastPositionCenter];
    }];
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
    YHUserModel *model = self.dataList[indexPath.row];
    [cell setData:model];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    YHUserModel *model = self.dataList[indexPath.row];
    if (self.isCityAudit) {
        YHUserAuditingViewController *vc = [[YHUserAuditingViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        YHUserAuditedViewController *vc = [[YHUserAuditedViewController alloc]init];
        vc.userId = model.UserId;
        [self.navigationController pushViewController:vc animated:YES];
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
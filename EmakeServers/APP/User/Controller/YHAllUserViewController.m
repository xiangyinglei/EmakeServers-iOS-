//
//  YHAllUserViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHAllUserViewController.h"
#import "Header.h"
#import "YHTitleView.h"
#import "YHUserAuditTableViewCell.h"
#import "YHUserAuditedViewController.h"
#import "YHSearchViewController.h"
#import "ChatNewViewController.h"
@interface YHAllUserViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,YHTitleViewViewDelegete,UIScrollViewDelegate>
@property (nonatomic,retain)NSMutableArray *dataListOne;
@property (nonatomic,retain)NSMutableArray *dataListTwo;
@property (nonatomic,retain)NSMutableArray *searchList;
@property (nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger indexPageOne;
@property(nonatomic,assign)NSInteger indexPageTwo;
@property(nonatomic,assign)BOOL isMaxPageOne;
@property(nonatomic,assign)BOOL isMaxPageTwo;
@property(nonatomic,retain)YHTitleView *titleView;
@property(nonatomic,copy)NSString *UserIdentity;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)UISearchBar *search;
@end

@implementation YHAllUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所有用户";
    self.indexPageOne = 0;
    self.indexPageTwo = 0;
    self.selectIndex = 0;
    self.view.backgroundColor = TextColor_F7F7F7;
    self.dataListOne = [NSMutableArray arrayWithCapacity:0];
    self.dataListTwo = [NSMutableArray arrayWithCapacity:0];
    self.UserIdentity = @"23";
    [self configSubViews];
    [self addRigthDropBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth*self.selectIndex, 0)];
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
    
    self.titleView = [[YHTitleView alloc]initWithCommonFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(50)) titleFont:16 delegate:self andTitleArray:@[@"会员",@"普通用户"]];
    [self.view addSubview:self.titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(HeightRate(50));
        make.top.mas_equalTo(self.search.mas_bottom).offset(HeightRate(10));
    }];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HeightRate(106)+topHeight, ScreenWidth, ScreenHeight-topHeight-HeightRate(106))];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = false;
    self.scrollView.delegate = self;
     [self.view addSubview:self.scrollView];
    
    for (int i = 0; i<2; i++) {
        
        UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight-HeightRate(106)-topHeight) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.tag = 500 + i;
        table.showsVerticalScrollIndicator = false;
        table.showsHorizontalScrollIndicator = false;
        table.separatorColor = [UIColor clearColor];
        table.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:table];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllUser:)];
        header.tag = 600 + i;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        table.mj_header = header;
        [table.mj_header beginRefreshing];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
        footer.tag = 700 + i;
        table.mj_footer = footer;
        footer.automaticallyChangeAlpha = YES;
        [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
        footer.automaticallyHidden = YES;
    }
}
- (void)getAllUser:(MJRefreshHeader *)header{
    NSInteger index = header.tag - 600;
    switch (index) {
        case 0:
            self.UserIdentity = @"23";
            break;
        case 1:
            self.UserIdentity = @"0";
            break;
        default:
            break;
    }
    [self getAllUserData:index];
}
- (void)getAllUserData:(NSInteger)index{
    UITableView *table = [self.scrollView viewWithTag:500+index];
    switch (index) {
        case 0:
            self.indexPageOne = 1;
            [self.dataListOne removeAllObjects];
            break;
        case 1:
            self.indexPageTwo = 1;
            [self.dataListTwo removeAllObjects];
            break;
        default:
            break;
    }
    [[YHJsonRequest shared] getAppCustomerAllUserWithUserIdentity:self.UserIdentity PageIndex:1 andPageSize:10 SuccessBlock:^(NSDictionary *dict) {
        NSArray *userDict = [dict objectForKey:@"Users"];
        if (userDict.count<=0) {
            [table.mj_header endRefreshing];
            [self.view hideWait:CurrentView];
            return;
        }
        if (userDict.count < 10) {
            if (index == 0) {
                self.isMaxPageOne = YES;
            }else{
                self.isMaxPageTwo = YES;
            }
        }
        for (NSDictionary *dict in userDict) {
            YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
            if (index == 0) {
                [self.dataListOne addObject:model];
            }else{
                [self.dataListTwo addObject:model];
            }
        }
        [self relodDataWithIndex:index];
        [self.view hideWait:CurrentView];
        [table.mj_header endRefreshing];
    } fialureBlock:^(NSString *errorMessages) {
        [self relodDataWithIndex:index];
        [self.view hideWait:CurrentView];
        [table.mj_header endRefreshing];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)relodDataWithIndex:(NSInteger)index{
    UITableView *table = [self.scrollView viewWithTag:500+index];
    [table.mj_footer resetNoMoreData];
    [table reloadData];
    [table.mj_header endRefreshing];
}
- (void)reloadDataWithIndex:(NSInteger)index{
    UITableView *table = [self.scrollView viewWithTag:500+index];
    [table reloadData];
    [table.mj_footer endRefreshing];
}
- (void)NoMoreDataWithIndex:(NSInteger)index{
    UITableView *table = [self.scrollView viewWithTag:500+index];
    [table.mj_footer endRefreshingWithNoMoreData];
}
- (void)loadMoreData:(MJRefreshAutoFooter *)footer{
    
    NSInteger tag  = footer.tag - 700;
    UITableView *table = [self.scrollView viewWithTag:500+tag];
    NSInteger indexpath = 0;
    switch (tag) {
        case 0:
            if (self.isMaxPageOne) {
                [self NoMoreDataWithIndex:tag];
                return;
            }
            indexpath = self.indexPageOne;
            self.UserIdentity = @"23";
            break;
        case 1:
            if (self.isMaxPageTwo) {
                [self NoMoreDataWithIndex:tag];
                return;
            }
            self.UserIdentity = @"0";
            indexpath = self.indexPageTwo;
            break;
        default:
            break;
    }
    [[YHJsonRequest shared] getAppCustomerAllUserWithUserIdentity:self.UserIdentity PageIndex:indexpath andPageSize:10 SuccessBlock:^(NSDictionary *dict) {
        NSArray *userDict = [dict objectForKey:@"Users"];
        for (NSDictionary *dict in userDict) {
            YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
            if (tag == 0) {
                [self.dataListOne addObject:model];
            }else{
                [self.dataListTwo addObject:model];
            }
        }
        [self reloadDataWithIndex:tag];
        if (userDict.count < 10) {
            if (tag == 0) {
               self.isMaxPageOne = YES;
            }else{
               self.isMaxPageTwo = YES;
            }
            [self NoMoreDataWithIndex:tag];
        }
    } fialureBlock:^(NSString *errorMessages) {
        if (tag == 0) {
            self.indexPageOne = self.indexPageOne - 1;
        }else{
            self.indexPageOne = self.indexPageOne - 1;
        }
        [table.mj_footer endRefreshing];
    }];
}
#pragma mark ---UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    self.searchList = [NSMutableArray arrayWithCapacity:0];
    if (!searchBar.text||searchBar.text.length<=0) {
        return;
    }
    NSDictionary *params = @{@"SearchContent":self.search.text,@"pageIndex":@(1),@"pageSize":@(1000000)};
    [[YHJsonRequest shared] searchUserWithMoblieNumberWithParameter:params SucceededBlock:^(YHUserMainModel *model) {
        if (model.UserRows.count>0) {
            for (NSDictionary *dict in model.UserRows) {
                YHUserModel *model = [YHUserModel mj_objectWithKeyValues:dict];
                [self.searchList addObject:model];
            }
        }
        YHSearchViewController *vc = [[YHSearchViewController alloc]init];
        vc.modelList = self.searchList;
        vc.isFromAduit = false;
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSString *errorMessage) {
        [self.view makeToast:errorMessage duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)goChatVC:(UIButton *)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    YHUserModel *model = nil;
    if (self.selectIndex == 0) {
        model = self.dataListOne[sender.tag];
    }else if (self.selectIndex == 1){
        model = self.dataListTwo[sender.tag];
    }
    vc.listID = model.UserId;
    vc.userAvatar = model.HeadImageUrl;
    vc.userType = model.UserIdentity;
    if ((model.RealName == nil) || (model.RealName.length <= 0)){
        vc.userName = [NSString stringWithFormat:@"用户%@",[model.MobileNumber substringFromIndex:model.MobileNumber.length-4]];
    }else{
       vc.userName = model.RealName;
    }
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
    if (tableView.tag == 500) {
        [cell setData:self.dataListOne[indexPath.row]];
    }else if (tableView.tag == 501) {
        [cell setData:self.dataListTwo[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sendMessageBtn.tag = indexPath.row;
    [cell.sendMessageBtn addTarget:self action:@selector(goChatVC:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 500) {
        return self.dataListOne.count;
    }else if (tableView.tag == 501) {
        return self.dataListTwo.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    YHUserAuditedViewController *vc = [[YHUserAuditedViewController alloc]init];
    YHUserModel *model = nil;
    if (tableView.tag == 500) {
        model = self.dataListOne[indexPath.row];
    }else if (tableView.tag == 501) {
        model = self.dataListTwo[indexPath.row];
    }
    vc.userId = model.UserId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --- YHTitleViewDelegate
- (void)titleView:(id)titleView selectItemWithIndex:(NSInteger)index{
    [self.search endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
    self.selectIndex = index;
    UITableView *table = [self.scrollView viewWithTag:500+index];
    [table reloadData];
}
#pragma mark ---UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.scrollView]) {
        NSInteger index = scrollView.contentOffset.x/ScreenWidth;
        [self.titleView ChageItemWithIndex:index];
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

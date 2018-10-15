//
//  YHAllStoreViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHAllStoreViewController.h"
#import "Header.h"
#import "YHStoreModel.h"
#import "YHStoreTableViewCell.h"
#import "YHStoreDetailViewController.h"
#import "YHSearchStoreViewController.h"
#import "ChatNewViewController.h"
@interface YHAllStoreViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataList;
@property(nonatomic,assign)NSInteger indexPage;
@property (nonatomic,retain)NSMutableArray *searchList;
@property (nonatomic,strong)UISearchBar *search;
@property (nonatomic,assign)BOOL isMaxPage;
@end

@implementation YHAllStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上线店铺";
    self.indexPage = 1;
    self.view.backgroundColor = TextColor_F7F7F7;
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    [self configSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllStore) name:NotificationStoreRefresh object:nil];
}
- (void)configSubViews{
    
    self.search = [[UISearchBar alloc]init];
    self.search.placeholder = @"按掌柜姓名和店铺名搜索";
    self.search.delegate = self;
    self.search.barTintColor = [UIColor whiteColor];
    self.search.searchBarStyle = UISearchBarStyleMinimal;
    self.search.backgroundColor = [UIColor clearColor];
    UITextField * searchField = [self.search valueForKey:@"_searchField"];
    [searchField setValue:TextColor_999999 forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.search];
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(15));
        make.right.mas_equalTo(WidthRate(-15));
        make.top.mas_equalTo(HeightRate(10)+(TOP_BAR_HEIGHT));
        make.height.mas_equalTo(HeightRate(35));
    }];
    
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
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.search.mas_bottom).offset(HeightRate(10));
        make.bottom.mas_equalTo(0);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllStore)];
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
- (void)extracted {
    [[YHJsonRequest shared] getAppCustomerAllStoreWithPageIndex:self.indexPage andPageSize:10 SuccessBlock:^(NSArray *messageArray) {
        [self.dataList addObjectsFromArray:messageArray];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fialureBlock:^(NSString *errorMessages) {
        [self.tableView.mj_header endRefreshing];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)getAllStore{
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    self.indexPage = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self extracted];
}
- (void)loadMoreData{
    
    if (self.isMaxPage) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.indexPage = self.indexPage + 1;
    [[YHJsonRequest shared] getAppCustomerAllStoreWithPageIndex:self.indexPage andPageSize:10 SuccessBlock:^(NSArray *messageArray) {
        [self.dataList addObjectsFromArray:messageArray];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (messageArray.count <10) {
            self.isMaxPage = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } fialureBlock:^(NSString *errorMessages) {
        self.indexPage = self.indexPage - 1;
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)goChatVC:(UIButton *)sender{
    YHStoreModel *model = self.dataList[sender.tag];
    NSString *topic = [NSString stringWithFormat:@"chatroom/%@/%@",model.StoreId,model.UserId];
    [[YHMQTTClient sharedClient] subcriceMessageTopic:topic];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.listID = [NSString stringWithFormat:@"%@_%@",model.StoreId,model.UserId];
    vc.userAvatar = model.StorePhoto;
    vc.userName = model.StoreName;
    vc.phoneNumber = model.MobileNumber;
    vc.userType = @"";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    self.searchList = [NSMutableArray arrayWithCapacity:0];
    if (!searchBar.text||searchBar.text.length<=0) {
        return;
    }
    [[YHJsonRequest shared] searchAppCustomerStoreWithSearchText:searchBar.text SuccessBlock:^(NSArray *messageArray) {
        YHSearchStoreViewController *vc = [[YHSearchStoreViewController alloc] init];
        vc.modelList = messageArray;
        [self.navigationController pushViewController:vc animated:YES];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHStoreTableViewCell *cell = nil;
    if (!cell) {
        cell =[[YHStoreTableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sendMessageBtn.tag = indexPath.row;
    [cell.sendMessageBtn addTarget:self action:@selector(goChatVC:) forControlEvents:UIControlEventTouchUpInside];
    YHStoreModel *model = self.dataList[indexPath.row];
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
    YHStoreModel *model = self.dataList[indexPath.row];
    YHStoreDetailViewController *vc = [[YHStoreDetailViewController alloc] init];
    vc.StoreId = model.StoreId;
    vc.isAudit = false;
    vc.storeUserId = model.UserId;
    vc.storeState = model.StoreState;
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

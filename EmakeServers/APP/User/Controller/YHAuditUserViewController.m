//
//  YHAuditUserViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHAuditUserViewController.h"
#import "Header.h"
#import "YHUserAuditTableViewCell.h"
#import "YHUserAuditingViewController.h"
@interface YHAuditUserViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSMutableArray *dataList;
@property(nonatomic,assign)NSInteger indexPage;
@property(nonatomic,assign)NSInteger MaxPage;
@end

@implementation YHAuditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待审核合伙人";
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubviews];
    [self addRigthDropBtn];
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
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
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
- (void)refreshData{
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    self.indexPage = 1;
    [self.view showWait:@"加载中" viewType:CurrentView];
    
}
- (void)loadMoreData{
    if (self.MaxPage <=1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    self.indexPage = self.indexPage + 1;
    
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHUserAuditTableViewCell *cell = nil;
    if (!cell) {
        cell =[[YHUserAuditTableViewCell alloc]init];
    }
    YHUserModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:model];
    cell.sendMessageBtn.hidden = true;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YHUserAuditingViewController *vc = [[YHUserAuditingViewController alloc]init];
    vc.model = self.dataList[indexPath.row];
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
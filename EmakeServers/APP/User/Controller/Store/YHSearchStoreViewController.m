//
//  YHSearchStoreViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/24.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHSearchStoreViewController.h"
#import "Header.h"
#import "YHStoreTableViewCell.h"
#import "YHStoreDetailViewController.h"
@interface YHSearchStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@end

@implementation YHSearchStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索店铺";
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
    YHStoreModel *model = self.modelList[indexPath.row];
    [cell setData:model];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(60);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YHStoreDetailViewController *vc = [[YHStoreDetailViewController alloc]init];
    vc.model = self.modelList[indexPath.row];
    vc.StoreId = vc.model.StoreId;
    vc.storeState = vc.model.StoreState;
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
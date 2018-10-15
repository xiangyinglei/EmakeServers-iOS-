//
//  YHCustomServersListViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/5.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHCustomServersListViewController.h"
#import "Header.h"
@interface YHCustomServersListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@end

@implementation YHCustomServersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TextColor_F5F5F5;
    self.title = @"客服转接";
    [self configSubViews];
}
- (void)configSubViews{
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorColor = SepratorLineColor;
    self.table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.table];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.bottom.mas_equalTo(0);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.serversArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.serversArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  HeightRate(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *serverId = self.serversArray[indexPath.row];
    if (self.selectServers) {
        self.selectServers(serverId);
        [self.navigationController popViewControllerAnimated:YES];
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

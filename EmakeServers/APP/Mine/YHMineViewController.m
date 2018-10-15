//
//  YHMineViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMineViewController.h"
#import "Header.h"
#import "YHMineTableViewCell.h"
#import "YHLoginViewController.h"
#import "YHMineHeaderTableViewCell.h"
#import "TestModel.h"
@interface YHMineViewController ()<UITableViewDataSource,UITableViewDelegate,YHActionSheetViewDelegete>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *leftTilte;
@end

@implementation YHMineViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TextColor_F7F7F7;
    self.navigationItem.leftBarButtonItem = nil;
    self.leftTilte = [NSArray arrayWithObjects:@"头像",@"用户名",@"真实姓名",@"手机号",@"工号",@"类型",@"版本", nil];
    [self configSubviews];
}
- (void)configSubviews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = false;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.height.mas_equalTo(HeightRate(486));
        make.right.mas_equalTo(0);
    }];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeCustom];
    [exit setTitle:@"退出登录" forState:UIControlStateNormal];
    exit.titleLabel.font = SYSTEM_FONT(AdaptFont(16));
    [exit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exit setBackgroundColor:[UIColor whiteColor]];
    [exit addTarget:self action:@selector(quitAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exit];
    
    [exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(15));
        make.height.mas_equalTo(HeightRate(50));
    }];
    
}
- (void)quitAccount{
    NSArray *title =@[@"确定"];
    YHActionSheetView *sheetView = [[YHActionSheetView alloc]initWithDelegate:self withCancleTitle:@"取消" andItemArrayTitle:title];
    [sheetView showAnimated];
}
#pragma mark=====YHActionSheetViewDelegete
- (void)actionSheetView:(id)actionSheet selectItemWithIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            [self exitAccount];
        }
            break;
        default:
            break;
    }
}
- (void)exitAccount{
    //获得Documents目录路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *serverID = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_ServiceID];
    NSString *fileName=[NSString stringWithFormat:@"%@/%@_chat",doc,serverID];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:LOGIN_MOBILEPHONE];
    [userDefaults removeObjectForKey:LOGIN_PASSWORD];
    [userDefaults removeObjectForKey:LOGIN_USERID];
    [userDefaults removeObjectForKey:LOGIN_UserRealName];
    [userDefaults removeObjectForKey:LOGIN_UserEmail];
    [userDefaults removeObjectForKey:LOGIN_ServiceID];
    [userDefaults removeObjectForKey:LOGIN_HeadImageUrl];
    [userDefaults removeObjectForKey:Is_Login];
    [userDefaults removeObjectForKey:LOGIN_ConsoleType];
    [userDefaults removeObjectForKey:LOGIN_TIME];
    [userDefaults removeObjectForKey:LOGIN_TOKEN];
    [userDefaults synchronize];
    [self clearCacheWithPath:fileName];
    [[YHMQTTClient sharedClient] disConnect];
    YHLoginViewController *loginVC = [[YHLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)clearCacheWithPath:(NSString *)path{
    
    NSFileManager *manager =[[NSFileManager alloc]init];
    [manager removeItemAtPath:[Tools getPath:path] error:nil];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.row == 0) {
        YHMineHeaderTableViewCell *cell = nil;
        if (!cell) {
            cell =[[YHMineHeaderTableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = self.leftTilte[indexPath.row];
        NSString *URL = [userDefaults objectForKey:LOGIN_HeadImageUrl];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"guanfangkefu"]];
        return cell;
    }else{
        YHMineTableViewCell *cell = nil;
        if (!cell) {
            cell =[[YHMineTableViewCell alloc]init];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = self.leftTilte[indexPath.row];
        if (indexPath.row == 1) {
            NSString *name = [userDefaults objectForKey:LOGIN_USERNAME];
            cell.rightLabel.text = name;
        }else if (indexPath.row == 2) {
            NSString *RealName = [userDefaults objectForKey:LOGIN_UserRealName];
            cell.rightLabel.text = RealName;
        }else if (indexPath.row == 3) {
            NSString *MOBILEPHONE = [userDefaults objectForKey:LOGIN_MOBILEPHONE];
            cell.rightLabel.text = MOBILEPHONE;
        }else if (indexPath.row == 4) {
            NSString *ServiceID = [userDefaults objectForKey:LOGIN_ServiceID];
            cell.rightLabel.text = ServiceID;
        }else if (indexPath.row == 5) {
            NSString *ConsoleType = [userDefaults objectForKey:LOGIN_ConsoleType];
            if ([ConsoleType isEqualToString:@"2"]) {
                cell.rightLabel.text = @"官方客服";
            }else{
                cell.rightLabel.text = @"订单业务员";
            }
        }else if (indexPath.row == 6) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",app_Version];
        }
        return cell;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return HeightRate(96);
    }
    return HeightRate(65);
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

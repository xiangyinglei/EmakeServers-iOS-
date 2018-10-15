//
//  YHUserMainViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHUserMainViewController.h"
#import "YHUserHeaderCell.h"
#import "Header.h"
#import "YHUserCommonCell.h"
#import "YHAllUserViewController.h"
#import "YHTitleView.h"
#import "YHCityDelegateUserViewController.h"
#import "YHAllStoreUserViewController.h"
#import "YHAuditStoreViewController.h"
@interface YHUserMainViewController ()<UITableViewDataSource,UITableViewDelegate,YHTitleViewViewDelegete>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *titles;
@property (nonatomic,retain)NSDictionary *userDic;
@property (nonatomic,retain)NSDictionary *userLastWeekDic;
@property (nonatomic,retain)NSDictionary *storeDic;
@property (nonatomic,strong)YHTitleView *titleView;
@end

@implementation YHUserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平台";
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubviews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titles = [NSArray arrayWithObjects:@"新增用户",@"新增城市代理商",@"新增会员",@"上周订单额",nil];
    [self getStoreDataWithRequestType:2 andTop:YES];
    [self getStoreDataWithRequestType:1 andTop:false];
    [Tools getAllFileNames];
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

- (void)getStoreDataWithRequestType:(NSInteger)type andTop:(BOOL)top{
    [[YHJsonRequest shared] getAppCustomerPlatformDataWithRequestType:type SuccessBlock:^(NSDictionary *dict) {
        self.storeDic = dict;
        if (top) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            NSIndexPath *indexpath1 = [NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSIndexPath *indexpath3 = [NSIndexPath indexPathForRow:2 inSection:1];
            NSIndexPath *indexpath4 = [NSIndexPath indexPathForRow:3 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexpath1,indexpath2,indexpath3,indexpath4] withRowAnimation:UITableViewRowAnimationNone];
        }
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)goAuditCityDelegateVC{
    
    YHCityDelegateUserViewController *vc = [[YHCityDelegateUserViewController alloc] init];
    vc.isCityAudit = true;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goAllStoreUserVC{
    
    YHAllUserViewController *vc = [[YHAllUserViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goAllCityDelegateVC{
    
    YHCityDelegateUserViewController *vc = [[YHCityDelegateUserViewController alloc] init];
    vc.isCityAudit = false;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        YHUserHeaderCell *cell = nil;
        if (!cell) {
            cell =[[YHUserHeaderCell alloc]init];
        }
        [cell updateCellConstraints];
        UITapGestureRecognizer *gestureThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAuditCityDelegateVC)];
        [cell.viewThree addGestureRecognizer:gestureThree];
        UITapGestureRecognizer *gestureOne = nil;
        gestureOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllStoreUserVC)];
        [cell.viewOne addGestureRecognizer:gestureOne];
        NSNumber *AuditUserNum = self.userDic[@"AllUserNum"];
        UIImageView *image = (UIImageView *)[cell.viewTwo viewWithTag:100];
        if (AuditUserNum.integerValue<=0) {
            [image clearBadge];
        }else{
            image.badgeCenterOffset = CGPointMake(WidthRate(-11), WidthRate(11));
            [image showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        }
        NSNumber *AuditStoreNum = self.storeDic[@"AgentUserNum"];
        UIImageView *imageStore = (UIImageView *)[cell.viewThree viewWithTag:100];
        if (AuditStoreNum.integerValue<=0) {
            [imageStore clearBadge];
        }else{
            imageStore.badgeCenterOffset = CGPointMake(WidthRate(0), WidthRate(6));
            [imageStore showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        }
        UITapGestureRecognizer *gestureTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllCityDelegateVC)];
        [cell.viewTwo addGestureRecognizer:gestureTwo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.storeDic];
        
        return cell;
    }else{
        YHUserCommonCell *cell = nil;
        if (!cell) {
            cell =[[YHUserCommonCell alloc]init];
        }
        cell.nameLabel.text = self.titles[indexPath.row];
        if (indexPath.row == 0) {
            cell.headImage.image = [UIImage imageNamed:@"hehuoren-65"];
            cell.countLabel.text = [NSString stringWithFormat:@"%ld",[self.storeDic[@"NewUserNum"] integerValue]];
        }else if (indexPath.row == 1) {
            cell.headImage.image = [UIImage imageNamed:@"Group 162"];
            cell.countLabel.text = [NSString stringWithFormat:@"%ld",[self.storeDic[@"NewAgentNum"] integerValue]];
            
        }else if (indexPath.row == 2) {
            cell.headImage.image = [UIImage imageNamed:@"huiyuantouxiang65"];
            cell.countLabel.text = [NSString stringWithFormat:@"%ld",[self.storeDic[@"NewVipNum"] integerValue]];
            
        }else{
            cell.headImage.image = [UIImage imageNamed:@"shangzhoudingdan"];
            NSString *price = self.storeDic[@"ALLPrice"];
            cell.countLabel.text = [NSString stringWithFormat:@"¥%.2f",floorNumber(price.doubleValue)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0){
        return HeightRate(170);
    }else{
        return HeightRate(60);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TableViewHeaderNone;
    }else{
        return HeightRate(40);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        self.titleView = [[YHTitleView alloc] initWithCommonFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(40)) titleFont:14 delegate:self andTitleArray:@[@"上周",@"本周",@"上月",@"本月"]];
        self.titleView.backgroundColor = TextColor_F5F5F5;
        return self.titleView;
    }else{
        return nil;
    }
}
#pragma mark --- YHTitleViewViewDelegete
- (void)titleView:(id)titleView selectItemWithIndex:(NSInteger)index{
    [self getStoreDataWithRequestType:index+1 andTop:false];
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

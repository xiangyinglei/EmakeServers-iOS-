//
//  YHUserAuditedViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHUserAuditedViewController.h"
#import "Header.h"
#import "YHMineTableViewCell.h"
#import "YHUserInfoHeaderTableViewCell.h"
#import "ChatNewViewController.h"
#import "YHMessageClassifyMainViewController.h"
#import "YHMessageClassifyOrderViewController.h"
#import "YHDelegateCategoryPresentViewController.h"
@interface YHUserAuditedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *leftTilteOne;
@property (nonatomic,retain)NSArray *leftTilteTwo;
@property (nonatomic,retain)NSArray *leftTilteThree;
@end

@implementation YHUserAuditedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubViews];
    [self addRigthDropBtn];
    self.leftTilteOne = [NSArray arrayWithObjects:@"用户类型：",@"代理品类：",@"会员权益：",@"性别：",@"代理城市：",@"注册时间：",@"审核日期：", nil];
    self.leftTilteTwo = [NSArray arrayWithObjects:@"用户类型：",@"会员权益：",@"性别：",@"注册时间：", nil];
    self.leftTilteThree = [NSArray arrayWithObjects:@"用户类型：",@"性别：",@"注册时间：", nil];
    [self configBottomView];
    [self getUserData];
    // Do any additional setup after loading the view.
}
- (void)getUserData{
    if (self.userId) {
        [[YHJsonRequest shared] getUsersInfoWithUserId:self.userId SucceededBlock:^(YHUserModel *model) {
            self.model = model;
            [self.tableView reloadData];
        } failedBlock:^(NSString *errorMessage) {
            [self.view makeToast:errorMessage duration:1.0 position:CSToastPositionCenter];
        }];
    }
}
- (void)configBottomView{
    UIView *view =[[UIView alloc]init];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    
    UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendMessageBtn.layer.cornerRadius = WidthRate(3);
    sendMessageBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
    [sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMessageBtn setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [sendMessageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sendMessageBtn];
    
    [sendMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(25));
        make.right.mas_equalTo(WidthRate(-25));
        make.centerY.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(HeightRate(40));
    }];
    
}
- (void)goLookUpMessageClassify{
    YHMessageClassifyMainViewController *vc = [[YHMessageClassifyMainViewController alloc]init];
    vc.isLookUp = YES;
    vc.userId = self.model.UserId;
    vc.userPhoneNumber = self.model.MobileNumber;
    vc.userType = self.model.UserType;
    vc.userName = self.model.RealName;
    vc.isFromUserInfo = YES;
    vc.isFormStore = false;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sendMessage{
    NSString *topic = [NSString stringWithFormat:@"chatroom/%@",self.model.UserId];
    [[YHMQTTClient sharedClient] subcriceMessageTopic:topic];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.listID = self.model.UserId;
    vc.userAvatar = self.model.HeadImageUrl;
    vc.userType = self.model.UserIdentity;
    if (!self.model.RealName||self.model.RealName.length<=0) {
        vc.userName = self.model.MobileNumber;
    }else{
        vc.userName = self.model.RealName;
    }
    vc.phoneNumber = self.model.MobileNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getOrderList{
    
    YHMessageClassifyOrderViewController *vc = [[YHMessageClassifyOrderViewController alloc] init];
    if (self.model.RealName.length<=0||!self.model.RealName) {
        vc.userName = [NSString stringWithFormat:@"用户%@",[self.model.MobileNumber substringFromIndex:self.model.MobileNumber.length-4]];
    }else{
        vc.userName = self.model.RealName;
    }
    vc.userId = self.model.UserId;
    vc.userPhoneNumber = self.model.MobileNumber;
    vc.isFromUserInfo = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)configSubViews{
    
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
        make.bottom.mas_equalTo(HeightRate(-65));
        make.right.mas_equalTo(0);
    }];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YHUserInfoHeaderTableViewCell *cell = nil;
        if (!cell) {
            cell =[[YHUserInfoHeaderTableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.model];
        if (!self.model.RealName||self.model.RealName.length<=0) {
            self.title = [NSString stringWithFormat:@"用户%@",[self.model.MobileNumber substringFromIndex:self.model.MobileNumber.length-4]];
        }else{
            self.title = self.model.RealName;
        }
        return cell;
    }else{
        YHMineTableViewCell *cell = nil;
        if (!cell) {
            cell =[[YHMineTableViewCell alloc]init];
        }
        cell.leftLabel.text = self.leftTilteOne[indexPath.row-1];
        switch (indexPath.row) {
            case 1:
                if ([self.model.UserIdentity isEqualToString:@"0"]) {
                    cell.rightLabel.text = @"普通用户";
                }else if ([self.model.UserIdentity isEqualToString:@"1"]) {
                    cell.rightLabel.text = @"城市代理商";
                }else if ([self.model.UserIdentity isEqualToString:@"2"]) {
                    cell.rightLabel.text = @"VIP用户";
                }else if ([self.model.UserIdentity isEqualToString:@"3"]) {
                    cell.rightLabel.text = @"体验VIP用户";
                }
                break;
            case 2:
                if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
                    cell.leftLabel.text = @"会员权益：";
                    NSMutableArray *cateArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dict in self.model.IdentityCategorys) {
                        NSString *cateName = [dict objectForKey:@"CategoryBName"];
                        [cateArray addObject:cateName];
                    }
                    cell.rightLabel.text = [cateArray componentsJoinedByString:@"、"];
                    if (cateArray.count >0) {
                        [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-38));
                        }];
                        UIImageView *rigthImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"direction_down"]];
                        [cell.contentView addSubview:rigthImage];
                        
                        [rigthImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-20));
                            make.width.mas_equalTo(WidthRate(14));
                            make.height.mas_equalTo(WidthRate(14));
                            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        }];
                    }
                    
                }else if ([self.model.UserIdentity isEqualToString:@"1"]){
                    cell.leftLabel.text = @"代理品类：";
                    NSMutableArray *cateArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dict in self.model.IdentityCategorys) {
                        NSString *cateName = [dict objectForKey:@"CategoryBName"];
                        [cateArray addObject:cateName];
                    }
                    cell.rightLabel.text = [cateArray componentsJoinedByString:@"、"];
                    if (cateArray.count >0) {
                        [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-38));
                        }];
                        UIImageView *rigthImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"direction_down"]];
                        [cell.contentView addSubview:rigthImage];
                        
                        [rigthImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-20));
                            make.width.mas_equalTo(WidthRate(14));
                            make.height.mas_equalTo(WidthRate(14));
                            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        }];
                    }
                }else{
                    cell.leftLabel.text = @"性别：";
                    if ([self.model.Sex isEqualToString:@"0"]) {
                        cell.rightLabel.text = @"男";
                    }else if ([self.model.Sex isEqualToString:@"1"]){
                        cell.rightLabel.text = @"女";
                    }else{
                        cell.rightLabel.text = @"保密";
                    }
                }
                break;
            case 3:
                if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
                    cell.leftLabel.text = @"性别：";
                    if ([self.model.Sex isEqualToString:@"0"]) {
                        cell.rightLabel.text = @"男";
                    }else if ([self.model.Sex isEqualToString:@"1"]){
                        cell.rightLabel.text = @"女";
                    }else{
                        cell.rightLabel.text = @"保密";
                    }
                }else if ([self.model.UserIdentity isEqualToString:@"1"]){
                    cell.leftLabel.text = @"会员权益：";
                    NSMutableArray *cateArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dict in self.model.IdentityCategorys) {
                        NSString *cateName = [dict objectForKey:@"CategoryBName"];
                        [cateArray addObject:cateName];
                    }
                    cell.rightLabel.text = [cateArray componentsJoinedByString:@"、"];
                    if (cateArray.count >0) {
                        [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-38));
                        }];
                        UIImageView *rigthImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"direction_down"]];
                        [cell.contentView addSubview:rigthImage];
                        
                        [rigthImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(WidthRate(-20));
                            make.width.mas_equalTo(WidthRate(14));
                            make.height.mas_equalTo(WidthRate(14));
                            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        }];
                    }
                }else{
                    cell.leftLabel.text = @"注册时间：";
                    NSArray *part = [self.model.CreateTime componentsSeparatedByString:@" "];
                    if (part.count ==2) {
                        cell.rightLabel.text = part[0];
                    }else{
                        cell.rightLabel.text = self.model.CreateTime;
                    }
                }
                break;
            case 4:
                if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
                    cell.leftLabel.text = @"注册时间：";
                    NSArray *part = [self.model.CreateTime componentsSeparatedByString:@" "];
                    if (part.count ==2) {
                        cell.rightLabel.text = part[0];
                    }else{
                        cell.rightLabel.text = self.model.CreateTime;
                    }
                }else if ([self.model.UserIdentity isEqualToString:@"1"]){
                    cell.leftLabel.text = @"性别：";
                    if ([self.model.Sex isEqualToString:@"0"]) {
                        cell.rightLabel.text = @"男";
                    }else if ([self.model.Sex isEqualToString:@"1"]){
                        cell.rightLabel.text = @"女";
                    }else{
                        cell.rightLabel.text = @"保密";
                    }
                }
                break;
            case 5:
                cell.leftLabel.text = @"代理城市： ";
                cell.rightLabel.text = self.model.AgentCity;
                break;
            case 6:{
                cell.leftLabel.text = @"注册时间：";
                NSArray *part = [self.model.CreateTime componentsSeparatedByString:@" "];
                if (part.count ==2) {
                    cell.rightLabel.text = part[0];
                }else{
                    cell.rightLabel.text = self.model.CreateTime;
                }
            }
                break;
            case 7:
                cell.leftLabel.text = @"审核日期：";
                cell.rightLabel.text = self.model.AuditTime;
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
        return self.leftTilteTwo.count+1;
    }else if ([self.model.UserIdentity isEqualToString:@"1"]){
       return self.leftTilteOne.count+1;
    }else{
        return self.leftTilteThree.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return HeightRate(90);
    }else{
        return HeightRate(44);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TableViewHeaderNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
        if (indexPath.row == 2) {
            if (self.model.IdentityCategorys.count <= 0) {
                return;
            }
            YHDelegateCategoryPresentViewController *vc = [[YHDelegateCategoryPresentViewController alloc] init];
            vc.isDelegateOrNot = NO;
            vc.cateArray = self.model.IdentityCategorys;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if ([self.model.UserIdentity isEqualToString:@"1"]){
        if (indexPath.row == 2) {
            if (self.model.IdentityCategorys.count <= 0) {
                return;
            }
            YHDelegateCategoryPresentViewController *vc = [[YHDelegateCategoryPresentViewController alloc] init];
            vc.isDelegateOrNot = YES;
            vc.cateArray = self.model.IdentityCategorys;
            [self presentViewController:vc animated:YES completion:nil];
        }else if (indexPath.row == 3) {
            if (self.model.IdentityCategorys.count <= 0) {
                return;
            }
            YHDelegateCategoryPresentViewController *vc = [[YHDelegateCategoryPresentViewController alloc] init];
            vc.isDelegateOrNot = NO;
            vc.cateArray = self.model.IdentityCategorys;
            [self presentViewController:vc animated:YES completion:nil];
        }
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

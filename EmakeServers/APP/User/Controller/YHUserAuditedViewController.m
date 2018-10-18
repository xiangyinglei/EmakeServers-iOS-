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
  //  self.leftTilteTwo = [NSArray arrayWithObjects:@"用户类型：",@"会员权益：",@"性别：",@"注册日期：", nil];
    self.leftTilteThree = [NSArray arrayWithObjects:@"用户类型：",@"性别：",@"注册时间：", nil];
    
    
    self.leftTilteTwo = @[
                          @[
                              @{@"text":@"用户类型：",@"value":@""},
                              @{@"text":@"性别：",   @"value":@""},
                              @{@"text":@"注册日期：",@"value":@""},
                              @{@"text":@"备注姓名：",@"value":@""},
                              @{@"text":@"公司名称：",@"value":@""},
                              ],
                          @[
                              @{@"text":@"代理品类：",@"value":@""},
                              @{@"text":@"代理城市：",@"value":@""},
                              @{@"text":@"审核日期：",@"value":@""},
                              @{@"text":@"审核人："  ,@"value":@""},
                              
                            ]
                          ];
    [self configBottomView];
    [self getUserData];
    // Do any additional setup after loading the view.
}
- (void)getUserData{
    if (self.userId) {
        [[YHJsonRequest shared] getUsersInfoWithUserId:self.userId SucceededBlock:^(YHUserModel *model) {
            self.model = model;
            // 设置数据源
            [self lazyDataSource];
            [self.tableView reloadData];
        } failedBlock:^(NSString *errorMessage) {
            [self.view makeToast:errorMessage duration:1.0 position:CSToastPositionCenter];
        }];
    }
}

- (void)lazyDataSource{
    // 注册日期
    NSArray *part = [self.model.CreateTime componentsSeparatedByString:@" "];
    NSString *createTime;
    if (part.count >=2) {
        createTime = part[0];
    }else{
        createTime = self.model.CreateTime;
    }
    // 审核日期
    NSArray *auditPartArr = [self.model.AuditTime componentsSeparatedByString:@" "];
    NSString *auditTime;
    if (auditPartArr.count >= 2) {
        auditTime = auditPartArr[0];
    }else{
        auditTime = self.model.AuditTime;
    }
    
    // 会员权益
    NSMutableArray *cateArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.model.IdentityCategorys) {
        NSString *cateName = [dict objectForKey:@"CategoryBName"];
        [cateArray addObject:cateName];
    }
    // 如果是代理商的话
    if ([self.model.UserIdentity isEqualToString:@"1"]) {
        
        self.leftTilteTwo = @[@[
                                  @{@"text":@"用户类型：",@"value":@"城市代理商"},
                                  @{@"text":@"会员权益：",@"value":[cateArray componentsJoinedByString:@"、"]},
                                  @{@"text":@"性别：",   @"value":[self.model.Sex isEqualToString:@"0"]?@"男":[self.model.Sex isEqualToString:@"1"]?@"女":@"未知"},
                                  @{@"text":@"注册日期：",@"value":createTime},
                                  @{@"text":@"备注姓名：",@"value":self.model.RemarkName},
                                  @{@"text":@"公司名称：",@"value":self.model.RemarkCompany},
                                  ],
                              @[
                                  @{@"text":@"代理品类：",@"value":[cateArray componentsJoinedByString:@"、"]},
                                  @{@"text":@"代理城市：",@"value":self.model.AgentCity},
                                  @{@"text":@"审核日期：",@"value":auditTime},
                                  @{@"text":@"审核人："  ,@"value":self.model.AuditUserId},
                                  ]
                              ];
    }else if ([self.model.UserIdentity isEqualToString:@"2"]){
        
        // 会员用户、VIP用户
        self.leftTilteTwo = @[@[
                                  @{@"text":@"用户类型：",@"value":@"会员用户"},
                                  @{@"text":@"会员权益：",@"value": [cateArray componentsJoinedByString:@"、"]},
                                  @{@"text":@"性别：",   @"value":[self.model.Sex isEqualToString:@"0"]?@"男":[self.model.Sex isEqualToString:@"1"]?@"女":@"未知"},
                                  @{@"text":@"注册日期：",@"value":createTime},
                                  @{@"text":@"备注姓名：",@"value":self.model.RemarkName},
                                  @{@"text":@"公司名称：",@"value":self.model.RemarkCompany},
                                  ]
                              ];
    }else{
        // 普通用户
        self.leftTilteTwo = @[
                              @[
                                  @{@"text":@"用户类型：",@"value":@"普通用户"},
                                  @{@"text":@"性别：",   @"value":[self.model.Sex isEqualToString:@"0"]?@"男":[self.model.Sex isEqualToString:@"1"]?@"女":@"未知"},
                                  @{@"text":@"注册日期：",@"value":createTime},
                                  @{@"text":@"备注姓名：",@"value":self.model.RemarkName},
                                  @{@"text":@"公司名称：",@"value":self.model.RemarkCompany},
                                  ]
                              ];
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
    
    if (indexPath.section == 0) {
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
            NSDictionary *dataSource = self.leftTilteTwo[0][indexPath.row - 1];
            static NSString *cellID = @"cellID";
            YHMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell =[[YHMineTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
            }
            cell.leftLabel.text  = dataSource[@"text"];
            cell.rightLabel.text = dataSource[@"value"];
            if ([dataSource[@"text"] isEqualToString:@"会员权益："] && [dataSource[@"value"] length] > 0) {
                [self updateConstraintWithCell:cell];
            }
            /* switch (indexPath.row) {
                case 1:
                    if ([self.model.UserIdentity isEqualToString:@"0"]) {
                        cell.rightLabel.text = @"普通用户";
                    }else if ([self.model.UserIdentity isEqualToString:@"1"]) {
                        cell.rightLabel.text = @"城市代理商";
                    }else if ([self.model.UserIdentity isEqualToString:@"2"]) {
                        cell.rightLabel.text = @"VIP用户";
                    }else if ([self.model.UserIdentity isEqualToString:@"3"]) {
                        //   cell.rightLabel.text = @"体验VIP用户";
                        cell.rightLabel.text = @"";
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
            }*/
            return cell;
        }
    }
        NSDictionary *dataSource = self.leftTilteTwo[1][indexPath.row];
        static NSString *cellID = @"cell";
        YHMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
             cell =[[YHMineTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault)reuseIdentifier:cellID];
         }
             cell.leftLabel.text  = dataSource[@"text"];
             cell.rightLabel.text = dataSource[@"value"];
          if ([dataSource[@"text"] isEqualToString:@"代理品类："] && [dataSource[@"value"] length] > 0) {
              [self updateConstraintWithCell:cell];
          }
            return cell;
}

- (void)updateConstraintWithCell:(YHMineTableViewCell*)cell{
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   // return 1;
    return self.leftTilteTwo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   /* if ([self.model.UserIdentity isEqualToString:@"2"]||[self.model.UserIdentity isEqualToString:@"3"]) {
        return self.leftTilteTwo.count+1;
    }else if ([self.model.UserIdentity isEqualToString:@"1"]){
       return self.leftTilteOne.count+1;
    }else{
        return self.leftTilteThree.count+1;
    }*/
    if (section == 0) {
        return [self.leftTilteTwo[section] count] + 1;
    }
       return [self.leftTilteTwo[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        return HeightRate(90);
    }else{
        return HeightRate(44);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TableViewHeaderNone;
    }
        return HeightRate(50);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(50))];
    
    headerView.backgroundColor = [UIColor colorWithHexString:@"E5EFFC"];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"已审核城市代理商";
    textLabel.textColor = [UIColor colorWithHexString:@"6699FF"];
    textLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(HeightRate(50));
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.centerX.mas_equalTo(headerView.mas_centerX);
    }];
    
    UIImageView *daiImgView = [[UIImageView alloc]init];
    daiImgView.image = [UIImage imageNamed:@"dailishangbig.png"];
    [headerView addSubview:daiImgView];
    [daiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(31);
        make.centerY.mas_equalTo(textLabel.mas_centerY);
        make.left.mas_equalTo(HeightRate(90));
    }];
    
    return headerView;
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
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                if (self.model.IdentityCategorys.count <= 0) {
                    return;
                }
                YHDelegateCategoryPresentViewController *vc = [[YHDelegateCategoryPresentViewController alloc] init];
                vc.isDelegateOrNot = NO;
                vc.cateArray = self.model.IdentityCategorys;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }else{
            if (indexPath.row == 0) {
                if (self.model.IdentityCategorys.count <= 0) {
                    return;
                }
                YHDelegateCategoryPresentViewController *vc = [[YHDelegateCategoryPresentViewController alloc] init];
                vc.isDelegateOrNot = YES;
                vc.cateArray = self.model.IdentityCategorys;
                [self presentViewController:vc animated:YES completion:nil];
            }
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

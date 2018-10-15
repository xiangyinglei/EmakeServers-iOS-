//
//  YHStoreDetailViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHStoreDetailViewController.h"
#import "Header.h"
#import "YHStoreDetailHeaderCell.h"
#import "YHMineTableViewCell.h"
#import "YHStoreChargeCardCell.h"
#import "YHStoreDescriptionCell.h"
#import "YHCategoryViewController.h"
#import "YHMessageClassifyOrderViewController.h"
#import "YHMessageClassifyMainViewController.h"
#import "YHMissonCreatSuccessView.h"
#import "ChatNewViewController.h"
@interface YHStoreDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,YBPopupMenuDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)NSArray *leftTitleOne;
@property (nonatomic,strong)NSArray *leftTitleTwo;
@property (nonatomic,strong)PlaceholderTextView *textView;
@property (nonatomic,strong)YHStoreModel *storeModel;
@end

@implementation YHStoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"店铺资料";
    self.view.backgroundColor = TextColor_F7F7F7;
    if (!self.isAudit) {
        [self setRightBtnImage:@"qunliao_shezhi"];
    }
    self.leftTitleOne = [NSArray arrayWithObjects:@"提交审核日期",@"店铺审核日期",@"店铺开业日期", nil];
    self.leftTitleTwo = [NSArray arrayWithObjects:@"掌柜姓名",@"身份证号码",@"掌柜手机",nil];
    [self configSubViews];
    [self getStoreDetails];
}
- (void)rightBtnClick:(UIButton *)sender{
    
    [YBPopupMenu showRelyOnView:self.navigationItem.rightBarButtonItem.customView titles:@[@"店铺下架"] icons:@[@"dianpuxiajia"] menuWidth:WidthRate(140) messgaeCount:0  delegate:self];
}
- (void)configSubViews{
    self.tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.bottom.mas_equalTo(HeightRate(-70));
    }];
    
    UIButton *pass = [UIButton buttonWithType:UIButtonTypeCustom];
    [pass setTitle:@"审核上架" forState:UIControlStateNormal];
    pass.layer.cornerRadius = WidthRate(3);
    [pass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pass setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [pass addTarget:self action:@selector(passNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pass];
    
    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(159));
        make.right.mas_equalTo(WidthRate(-22));
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(20));
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    UIButton *Unpass = [UIButton buttonWithType:UIButtonTypeCustom];
    [Unpass setTitle:@"不通过" forState:UIControlStateNormal];
    Unpass.layer.cornerRadius = WidthRate(3);
    [Unpass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Unpass setBackgroundColor:ColorWithHexString(SymbolTopColor)];
    [Unpass addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Unpass];
    
    [Unpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(22));
        make.width.mas_equalTo(WidthRate(159));
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(15));
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    UIButton *orderListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderListBtn setTitle:@"订单列表" forState:UIControlStateNormal];
    orderListBtn.layer.cornerRadius = WidthRate(3);
    orderListBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
    [orderListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderListBtn setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [orderListBtn addTarget:self action:@selector(getOrderList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderListBtn];
    
    [orderListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(115));
        make.left.mas_equalTo(WidthRate(10));
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(20));
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    
    UIButton *lookUpButotn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookUpButotn setTitle:@"归档信息" forState:UIControlStateNormal];
    lookUpButotn.layer.cornerRadius = WidthRate(3);
    lookUpButotn.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
    [lookUpButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookUpButotn setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [lookUpButotn addTarget:self action:@selector(goLookUpMessageClassify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookUpButotn];
    
    [lookUpButotn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(115));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(20));
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendMessageBtn.layer.cornerRadius = WidthRate(3);
    sendMessageBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
    [sendMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMessageBtn setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [sendMessageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendMessageBtn];
    
    [sendMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(115));
        make.right.mas_equalTo(WidthRate(-10));
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(HeightRate(20));
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    if (self.isAudit) {
        orderListBtn.hidden = true;
        lookUpButotn.hidden = true;
        sendMessageBtn.hidden = true;
    }else{
        pass.hidden = true;
        Unpass.hidden = true;
    }
}
- (void)getStoreDetails{
    [[YHJsonRequest shared] getAppCustomerStoreDetailWithStoreId:self.StoreId SuccessBlock:^(YHStoreModel *model) {
        self.storeModel = model;
        [self.tableView reloadData];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)passNext{
    
    [self.view endEditing:YES];
    NSDictionary *dict = nil;
    if (!self.textView.text||self.textView.text.length<=0) {
        dict = @{@"StoreState":@"1",@"StoreId":self.StoreId,@"Remark":@""};
    }else{
        dict = @{@"StoreState":@"1",@"Remark":self.textView.text,@"StoreId":self.StoreId};
    }
    [[YHJsonRequest shared] auditAppCustomerStoreWithParams:dict SuccessBlock:^(NSString *successMessages) {
        [self.view makeToast:@"审核成功" duration:1.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAuditStoreRefresh object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)reject{
    [self.view endEditing:YES];
    if (!self.textView.text||self.textView.text.length<=0) {
        [self.view makeToast:@"请填写审核备注" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *dict = @{@"StoreState":@"2",@"Remark":self.textView.text,@"StoreId":self.StoreId};
    [[YHJsonRequest shared] auditAppCustomerStoreWithParams:dict SuccessBlock:^(NSString *successMessages) {
        [self.view makeToast:@"操作成功" duration:1.5 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAuditStoreRefresh object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)getOrderList{
    YHMessageClassifyOrderViewController *vc = [[YHMessageClassifyOrderViewController alloc] init];
    vc.storeId = self.storeModel.StoreId;
    vc.storeName = self.storeModel.StoreName;
    vc.storePhoneNumber = self.storeModel.MobileNumber;
    vc.storePhoto = self.storeModel.StorePhoto;
    vc.isFromUserInfo = YES;
    vc.isFormStore = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goLookUpMessageClassify{
    YHMessageClassifyMainViewController *vc = [[YHMessageClassifyMainViewController alloc]init];
    vc.isLookUp = YES;
    vc.isFromUserInfo = YES;
    vc.storeId = self.storeModel.StoreId;
    vc.storeUserId = self.storeModel.StoreId;
    vc.storePhoto = self.storeModel.StorePhoto;
    vc.storePhoneNumber = self.storeModel.MobileNumber;
    vc.storeName = self.storeModel.StoreName;
    vc.isFormStore = YES;
    vc.isLookUp = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sendMessage{
    NSString *topic = [NSString stringWithFormat:@"chatroom/%@/%@",self.model.StoreId,self.storeUserId];
    [[YHMQTTClient sharedClient] subcriceMessageTopic:topic];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.listID = [NSString stringWithFormat:@"%@_%@",self.storeModel.StoreId,self.storeUserId];
    vc.userAvatar = self.storeModel.StorePhoto;
    vc.userName = self.storeModel.StoreName;
    vc.phoneNumber = self.storeModel.MobileNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource&UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YHStoreDetailHeaderCell *cell = nil;
        if (!cell) {
            cell = [[YHStoreDetailHeaderCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.storeModel];
        return cell;
    }else if (indexPath.section == 1){
        YHMineTableViewCell *cell = nil;
        if (!cell) {
            cell = [[YHMineTableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = self.leftTitleOne[indexPath.row];
        if (self.isAudit) {
            if (indexPath.row == 1) {
                cell.leftLabel.text = @"店铺开业日期";
            }
        }
        switch (indexPath.row) {
            case 0:
                cell.rightLabel.text = self.storeModel.ApplyTime;
                break;
            case 1:
                if (self.isAudit) {
                    cell.rightLabel.text = self.storeModel.OpenTime;
                }else{
                    cell.rightLabel.text = self.storeModel.AuditTime;
                }
                break;
            default:
                cell.rightLabel.text = self.storeModel.OpenTime;
                break;
        }
        return cell;
    }else if (indexPath.section == 2){
        YHMineTableViewCell *cell = nil;
        if (!cell) {
            cell = [[YHMineTableViewCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-38));
        }];
        UIImageView *rigthImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"direction_right"]];
        [cell.contentView addSubview:rigthImage];
        
        [rigthImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-20));
            make.width.mas_equalTo(WidthRate(14));
            make.height.mas_equalTo(WidthRate(14));
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        }];
        cell.leftLabel.text = @"主营品类";
        NSString *str = @"";
        for (NSDictionary *dict in self.storeModel.StoreCategoryList) {
            str = [NSString stringWithFormat:@"%@ %@",str,[dict objectForKey:@"CategoryName"]];
        }
        cell.rightLabel.numberOfLines = 1;
        cell.rightLabel.text = str;
        [cell.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WidthRate(200));
        }];
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 3) {
            YHStoreChargeCardCell *cell = nil;
            if (!cell) {
                cell = [[YHStoreChargeCardCell alloc] init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.cardImage sd_setImageWithURL:[NSURL URLWithString:self.storeModel.RawCardUrl] placeholderImage:[UIImage imageNamed:@"mingpian-1"]];
            return cell;
        }else{
            YHMineTableViewCell *cell = nil;
            if (!cell) {
                cell = [[YHMineTableViewCell alloc]init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = self.leftTitleTwo[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.rightLabel.text = self.storeModel.RealName;
                    break;
                case 1:
                    cell.rightLabel.text = self.storeModel.PSPDId;
                    break;
                default:
                    cell.rightLabel.text = self.storeModel.MobileNumber;
                    break;
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            YHStoreDescriptionCell *cell = nil;
            if (!cell) {
                cell = [[YHStoreDescriptionCell alloc]init];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.descriptionLabel.text = self.storeModel.StoreSummary;
            return cell;
        }else{
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc]init];
            }
            self.textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(WidthRate(15), 0, ScreenWidth - WidthRate(30), HeightRate(78))];
            self.textView.placeholder = @"请输入审核备注";
            self.textView.placeholderColor = TextColor_797979;
            self.textView.delegate = self;
            [cell.contentView addSubview:self.textView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (self.isAudit) {
            return 2;
        }
        return 3;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 4;
    }else{
        if (self.isAudit) {
            return 2;
        }
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TableViewHeaderNone;
    }else{
        return HeightRate(8);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TableViewFooterNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HeightRate(110);
    }else if(indexPath.section == 1) {
        return HeightRate(48);
    }else if(indexPath.section == 2) {
        return HeightRate(48);
    }else if(indexPath.section == 3) {
        if (indexPath.row == 3) {
            return HeightRate(220);
        }else{
            return HeightRate(48);
        }
    }else{
        if (indexPath.row == 1) {
            return HeightRate(227);
        }else{
            return HeightRate(215);
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        YHCategoryViewController *vc = [[YHCategoryViewController alloc] init];
        vc.StoreCategoryDetail = self.storeModel.StoreCategoryDetail;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.placeholder = @"";
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (!textView.text||textView.text.length<=0) {
        self.textView.placeholder = @"请输入审核备注";
    }else{
        self.model.StoreSummary = textView.text;
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    switch (index) {
        case 0:{
            YHMissonCreatSuccessView *view = [[YHMissonCreatSuccessView alloc] initDisbandView];
            view.block = ^(NSString *msg) {
                NSDictionary *params = @{@"StoreId":self.StoreId,@"Remark":@"",@"StoreState":@"1",@"OnShow":@"0"};
                [[YHJsonRequest shared] storeDownWithParameters:params SuccessBlock:^(NSString *successMessage) {
                    [self.view makeToast:@"下架成功" duration:1.0 position:CSToastPositionCenter title:@"" image:nil style:nil completion:^(BOOL didTap) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStoreRefresh object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                } fialureBlock:^(NSString *errorMessages) {
                    [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
                }];
            };
            [view showAnimated];
        }
            break;
            
        default:
            break;
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

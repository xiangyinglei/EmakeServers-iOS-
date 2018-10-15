//
//  YHMessageClassifyOrderViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/5.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMessageClassifyOrderViewController.h"
#import "Header.h"
#import "YHOrderHeaderRevelanceCell.h"
#import "YHRevelanceOrderContentCell.h"
#import "YHOrderContract.h"
#import "ChatNewViewController.h"
#import "YHOrderModel.h"
#import "YHGoodsModel.h"
#import "YHItemModel.h"
@interface YHMessageClassifyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YHMessageClassifyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TextColor_F5F5F5;
    [self addRigthDropBtn];
    [self configSubviews];
    if (self.isFormStore) {
        self.title = [NSString stringWithFormat:@"%@的订单",self.storeName];
        [self getStoreOrderData];
    }else{
        self.title = [NSString stringWithFormat:@"%@的订单",self.userName];
        [self getOrderData];
    }
}
- (void)configSubviews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
- (void)getOrderData{
    [self.view showWait:@"加载中" viewType:CurrentView];
    [[YHJsonRequest shared] getOrderListWithUserId:self.userId orStoreId:nil  SuccessBlock:^(NSArray *dataArray) {
        [self.view hideWait:CurrentView];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self.tableView reloadData];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)getStoreOrderData{
    [self.view showWait:@"加载中" viewType:CurrentView];
    [[YHJsonRequest shared] getOrderListWithUserId:nil orStoreId:self.storeId  SuccessBlock:^(NSArray *dataArray) {
        [self.view hideWait:CurrentView];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self.tableView reloadData];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)archiveWithOrder:(NSString *)orderNo{
    [self.view showWait:@"归档中" viewType:CurrentView];
    NSDictionary *dict = nil;
    if (self.isFormStore) {
        dict = @{@"OrderNo":orderNo,@"StoreId": self.storeId,@"ArchiveType":@"1",@"Messages":self.archiveArray,@"UserId":@""};
    }else{
        dict = @{@"OrderNo":orderNo,@"UserId": self.userId,@"ArchiveType":@"1",@"Messages":self.archiveArray,@"StoreId":@""};
    }
    [[YHJsonRequest shared] appChatPostToServers:dict SuccessBlock:^(NSString *successMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:successMessages duration:0.3 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ChatNewViewController class]]) {
                    if (self.block) {
                        self.block(@"success");
                    }
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        }];
    }fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)getReveleanceMessage:(NSString *)orderNo{
    NSString *requsetParams = @"";
    if (self.isFormStore) {
        requsetParams = [NSString stringWithFormat:@"OrderNo=%@&ArchiveType=%@&StoreId=%@",orderNo,@"1",self.storeId];
    }else{
        requsetParams = [NSString stringWithFormat:@"OrderNo=%@&ArchiveType=%@&UserId=%@",orderNo,@"1",self.userId];
    }
    [[YHJsonRequest shared] getAppChatFromServers:requsetParams SuccessBlock:^(NSArray *messageArray) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        ChatNewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.listID = self.listId;
        vc.userType = @"";
        if (self.isFormStore) {
            vc.userName = self.storeName;
            vc.phoneNumber = self.storePhoneNumber;
            vc.userAvatar = self.storePhoto;
        }else{
            vc.userName = self.userName;
            vc.phoneNumber = self.userPhoneNumber;
            vc.userAvatar = self.userAvata;
        }
        vc.isDisplayArchiveMessage = YES;
        vc.archiveData = messageArray;
        vc.isLookUpArchive = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isFromUserInfo) {
        YHOrderModel *model = self.dataArray[section];
        return model.ProductList.count + 1;
    }else{
        return 2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHOrderModel *model = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        YHOrderHeaderRevelanceCell *cell = nil;
        if (!cell) {
            cell = [[YHOrderHeaderRevelanceCell alloc]init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *text = [NSString stringWithFormat:@"订单号：%@",model.ContractNo];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AdaptFont(14)] range:NSMakeRange(4, model.ContractNo.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(4, model.ContractNo.length)];
        [cell.storeImage sd_setImageWithURL:[NSURL URLWithString:model.StorePhoto]];
        cell.storeName.text = model.StoreName;
        cell.labelTime.text = model.AddWhen;
        if ([model.OrderState isEqual:@"0"]) {
            cell.labelState.text = @"待付款";
        }else if ([model.OrderState isEqual:@"1"]) {
            cell.labelState.text = @"生产中";
        }else if ([model.OrderState isEqual:@"2"]) {
            cell.labelState.text = @"已入库";
        }else if ([model.OrderState isEqual:@"3"]) {
            cell.labelState.text = @"已发货";
        }else if ([model.OrderState isEqual:@"-2"]) {
            cell.labelState.text = @"待签订";
        }
        return cell;
    }else{
        NSDictionary *dic = model.ProductList[indexPath.row-1];
        YHItemModel *GoodsModel = [YHItemModel mj_objectWithKeyValues:dic];
        YHRevelanceOrderContentCell *cell = nil;
        if (!cell) {
            cell = [[YHRevelanceOrderContentCell alloc]init];
        }
        if (self.isFromUserInfo || self.isLookUp) {
            cell.revelanceButton.hidden = true;
        }else{
            cell.revelanceButton.hidden = false;
        }
        cell.revelanceBlock = ^(NSString *success) {
            if (!self.isLookUp) {
                [self archiveWithOrder:model.ContractNo];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:GoodsModel];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TableViewHeaderNone;
    }
    return HeightRate(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(10))];
    view.backgroundColor = TextColor_F5F5F5;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return HeightRate(37);
    }else{
        return HeightRate(75);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFromUserInfo && self.isLookUp) {
        YHOrderContract *model = self.dataArray[indexPath.section];
        [self getReveleanceMessage:model.ContractNo];
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

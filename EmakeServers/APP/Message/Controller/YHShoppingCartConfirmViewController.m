//
//  YHShoppingCartConfirmViewController.m
//  emake
//
//  Created by 谷伟 on 2017/11/13.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHShoppingCartConfirmViewController.h"
#import "YHShoppingCartConfirmCell.h"
#import "Tools.h"
#import "Header.h"
#import "YHOrderContract.h"
#import <UIKit/UIKit.h>

@interface YHShoppingCartConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * myTableView;
    NSInteger recordSection;
    BOOL isLeader;
    NSString *groupID;
}
@property (nonatomic,retain)UIButton *dicussBtn;
@property (nonatomic,retain)NSMutableArray *selectArray;
@property (nonatomic,retain)UILabel *totalLabel;
@property(nonatomic,strong)NSArray *groupArr;
@property(nonatomic,copy)NSDictionary *contractDict;
@property(nonatomic,copy)NSDictionary *contractProtocolDict;
@property(nonatomic,copy)NSDictionary *contractSaleDict;
@property(nonatomic,strong)NSArray *productArray;
@property(nonatomic,strong)UIButton *sendSaleButton;
@property(nonatomic,strong)UIButton *sendContractButton;
@property(nonatomic,strong)YHOrderContract *contract;
@property(nonatomic,strong)YHChatOrderContract *chatContract;

@property(nonatomic,assign)BOOL isShowInsuranceView;

@end

@implementation YHShoppingCartConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title =@"订单详情";
    self.view.backgroundColor = TextColor_F7F7F7;

    [self configUI];
    [self addRigthDropBtn];
    [self addBottomView];
    [self getContractData];
}

-(void)getContractData{
    
    NSDictionary *dict = [self.eventText mj_JSONObject];
    self.chatContract = [YHChatOrderContract mj_objectWithKeyValues:dict];
    if (self.chatContract.ContractNo == nil){
        return;
    }
    [self getProtocolDataWithContractNo:self.chatContract.ContractNo];
    [self.view showWait:@"加载中" viewType:CurrentView];
    NSDictionary * paramDic =@{@"RequestType":@"1",@"OrderNo":self.chatContract.ContractNo};
    
    [[YHJsonRequest shared] userUseOrderManageParams:paramDic SucceededBlock:^(NSArray *orderArray) {
        if (orderArray.count ==1) {
            self.contract = orderArray.firstObject;
            self.isShowInsuranceView =   [self.chatContract.IsStore  isEqualToString:@"0"] && self.contract.InsurdAmount.floatValue > @"2000".floatValue;
            [myTableView reloadData];
        }else{
            
            [self.view makeToast:@"合同号异常" duration:1.5f position:CSToastPositionCenter];
        }
        [self.view hideWait:CurrentView];
    
    } failedBlock:^(NSString *errorMessage) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessage duration:1.5f position:CSToastPositionCenter];
    }];
}
- (void)getProtocolDataWithContractNo:(NSString *)contractNo{
    
    [[YHJsonRequest shared] getWebContractWithContractNo:contractNo successBlock:^(NSDictionary *dict) {
        if ([dict objectForKey:@"MessageBody"]) {
            NSDictionary *MessageBody = [dict objectForKey:@"MessageBody"];
            //协议
            if ([MessageBody objectForKey:@"ContractAgreement"] != nil) {
                self.contractProtocolDict = [MessageBody objectForKey:@"ContractAgreement"] ;
            }
            //买卖合同
            self.contractSaleDict = [MessageBody objectForKey:@"ContractHeader"] ;
            if (self.contractSaleDict != nil && [self.contractSaleDict objectForKey:@"Url"] != nil) {
                self.sendSaleButton.hidden = false;
                [self.sendContractButton setTitle:@"合同+协议" forState:UIControlStateNormal];
            }else{
                self.sendSaleButton.hidden = true;
                [self.sendContractButton setTitle:@"合同" forState:UIControlStateNormal];
            }
            //完整合同
            if ([MessageBody objectForKey:@"ContractTotal"] != nil) {
                self.contractDict = [MessageBody objectForKey:@"ContractTotal"];
            }
        }
        if ([dict objectForKey:@"Products"] != nil) {
            self.productArray = [dict objectForKey:@"Products"];
        }
        [myTableView reloadData];
    }fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)addBottomView{
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(HeightRate(50));
    }];
    
    self.sendSaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendSaleButton.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
    self.sendSaleButton.hidden = true;
    [self.sendSaleButton setTitle:@"买卖合同" forState:UIControlStateNormal];
    [self.sendSaleButton addTarget:self action:@selector(sendSaleContract) forControlEvents:UIControlEventTouchUpInside];
    [self.sendSaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendSaleButton setImage:[UIImage imageNamed:@"fasong01s"] forState:UIControlStateNormal];
    [self.sendSaleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, WidthRate(10))];
    self.sendSaleButton.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
    self.sendSaleButton.layer.cornerRadius = HeightRate(15);
    [bottomView addSubview:self.sendSaleButton];
    
    [self.sendSaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(WidthRate(-80));
        make.height.mas_equalTo(HeightRate(30));
        make.width.mas_equalTo(WidthRate(124));
        make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];
    
    
    self.sendContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendContractButton.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
    [self.sendContractButton setTitle:@"合同+协议" forState:UIControlStateNormal];
    [self.sendContractButton addTarget:self action:@selector(sendContract) forControlEvents:UIControlEventTouchUpInside];
    [self.sendContractButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendContractButton setImage:[UIImage imageNamed:@"fasong01s"] forState:UIControlStateNormal];
    [self.sendContractButton setImageEdgeInsets:UIEdgeInsetsMake(0, WidthRate(0), 0, WidthRate(10))];
    self.sendContractButton.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
    self.sendContractButton.layer.cornerRadius = HeightRate(15);
    [bottomView addSubview:self.sendContractButton];
    
    [self.sendContractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(WidthRate(80));
        make.height.mas_equalTo(HeightRate(30));
        make.width.mas_equalTo(WidthRate(124));
        make.centerY.mas_equalTo(bottomView.mas_centerY);
    }];
}
- (void)configUI{
    
    CGFloat height = self.view.frame.size.height-(TOP_BAR_HEIGHT)-HeightRate(50);
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, self.view.frame.size.width, height) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.estimatedSectionHeaderHeight =0;
    myTableView.estimatedSectionFooterHeight = 0;
    myTableView.estimatedRowHeight = 200;
    myTableView.backgroundColor = TextColor_F7F7F7;
    [self.view addSubview:myTableView];
    
    
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(HeightRate(-50));
    }];
}

- (void)sendSaleContract{
    chatBodyModel *model = [chatBodyModel mj_objectWithKeyValues:self.contractSaleDict];
    model.Type = @"MutilePart";
    model.Url = [NSString stringWithFormat:@"%@%@",model.Url,self.chatContract.ContractNo];
    model.Contract = self.chatContract.ContractNo;
    if (!self.chatContract.ContractNo||self.chatContract.ContractNo.length<=0) {
        [self.view makeToast:@"获取合同号失败" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!model.Url||model.Url.length<=0) {
        [self.view makeToast:@"获取买卖合同地址失败" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    self.sendProtocolBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendContract{
    
    chatBodyModel *model = [chatBodyModel mj_objectWithKeyValues:self.contractDict];
    model.Type = @"MutilePart";
    model.Url = [NSString stringWithFormat:@"%@%@",model.Url,self.chatContract.ContractNo];
    model.Contract = self.chatContract.ContractNo;
    if (!self.chatContract.ContractNo||self.chatContract.ContractNo.length<=0) {
        [self.view makeToast:@"获取合同号失败" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (!model.Url||model.Url.length<=0) {
        [self.view makeToast:@"获取完整合同地址失败" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    self.sendProtocolBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark === UITableViewDelegate & UITableViewDataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contract.goodsModelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YHShoppingCartConfirmCell *cell = nil;
    if (!cell) {
        cell = [[YHShoppingCartConfirmCell alloc]init];
    }
    YHOrder *model1 = self.contract.goodsModelArr[indexPath.row];
    [cell setData:model1];
    cell.sendBlock = ^{
        chatBodyModel *model = [chatBodyModel mj_objectWithKeyValues:self.contractProtocolDict];
        model.Type = @"MutilePart";
        if (_productArray.count==0) {
            [self.view makeToast:@"该商品没有技术协议" duration:1.5 position:CSToastPositionCenter];
            
        }else{
            if (indexPath.row<self.productArray.count) {
                NSDictionary *productIdsDict =_productArray[indexPath.row];
                model.Url = [NSString stringWithFormat:@"%@%@/%@",model.Url,self.chatContract.ContractNo,productIdsDict[@"MainGoodsCode"]];
                model.Contract = self.chatContract.ContractNo;
                self.sendProtocolBlock(model);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.isShowInsuranceView == YES){
        return HeightRate(110);
    }
    return HeightRate(64);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return HeightRate(33);
  
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, ScreenWidth, HeightRate(33))];
    backView.backgroundColor = ColorWithHexString(@"ffffff");
    UILabel *orderIdItemLabel = [[UILabel alloc] init];
    orderIdItemLabel.text =[NSString stringWithFormat:@"合同号：%@",self.contract.ContractNo] ;
    orderIdItemLabel.translatesAutoresizingMaskIntoConstraints   = NO;
    orderIdItemLabel.font =[UIFont systemFontOfSize:AdaptFont(13)];
    orderIdItemLabel.textColor = ColorWithHexString(@"666666");
    [backView addSubview:orderIdItemLabel];
    
    [orderIdItemLabel PSSetLeft:WidthRate(12)];
    [orderIdItemLabel PSSetCenterHorizontalAtItem:backView];
   
    
    //订单日期
    UILabel *orderDateItemLabel = [[UILabel alloc] init];
    orderDateItemLabel.text =[NSString stringWithFormat:@"%@",self.contract.InDate] ;
    orderDateItemLabel.translatesAutoresizingMaskIntoConstraints   = NO;
    orderDateItemLabel.font =[UIFont systemFontOfSize:AdaptFont(13)];
    orderDateItemLabel.textColor = ColorWithHexString(@"666666");
    [backView addSubview:orderDateItemLabel];
    
    [orderDateItemLabel PSSetRight:WidthRate(15)];
    [orderDateItemLabel PSSetCenterHorizontalAtItem:backView];
    


    return backView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat hight =  self.isShowInsuranceView?(148):84;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(hight))];
    footView.backgroundColor =ColorWithHexString(@"ffffff");
    
    UILabel *line;
    if (self.isShowInsuranceView==YES) {
        
        UILabel *insureFee = [[UILabel alloc] init];
        insureFee.textColor = ColorWithHexString(@"5792F0") ;
        insureFee.text = [NSString stringWithFormat:@"人保保费0.5%%：¥%@",[Tools getHaveNum:(floorNumber(self.contract.InsurdAmount.doubleValue*0.005))]];
        insureFee.font = [UIFont systemFontOfSize:AdaptFont(12)];
        insureFee.textAlignment = NSTextAlignmentRight;
        [footView addSubview:insureFee];
        [insureFee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-13));
            make.height.mas_equalTo(HeightRate(20));
            make.top.mas_equalTo(HeightRate(10));
        }];
        
        line = [[UILabel alloc] init];
        line.backgroundColor = SepratorLineColor;
        [footView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(1));
            make.width.mas_equalTo(ScreenWidth);
            make.top.mas_equalTo(insureFee.mas_bottom).offset(HeightRate(10));
            
        }];
        
    }
    
    UILabel *tipsRightLableTop = [[UILabel alloc] init];
    tipsRightLableTop.textColor = ColorWithHexString(SymbolTopColor) ;
    tipsRightLableTop.font = [UIFont systemFontOfSize:AdaptFont(13)];
    tipsRightLableTop.textAlignment = NSTextAlignmentRight;
    [footView addSubview:tipsRightLableTop];
    [tipsRightLableTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-10));
        make.height.mas_equalTo(HeightRate(0.01));
        if (self.isShowInsuranceView==YES) {
            make.top.mas_equalTo(line.mas_bottom).offset(HeightRate(5));
        }else{
            make.top.mas_equalTo(HeightRate(5));
        }
    }];
    
    float AllShippingFee = 0.00f;
    for (NSDictionary *dict in self.contract.ProductList) {
        if ([dict objectForKey:@"TotalShippingFee"]) {
            float fee = [[dict objectForKey:@"TotalShippingFee"] floatValue];
            AllShippingFee = AllShippingFee + fee;
        }
    }
    float allPrice = self.contract.ContractAmount.doubleValue;
    if ([self.contract.OrderState isEqualToString:@"-2"]) {
        allPrice = allPrice - AllShippingFee;
    }
    UILabel *priceLable = [[UILabel alloc] init];
    priceLable.textColor = ColorWithHexString(StandardBlueColor) ;
    priceLable.text = [NSString stringWithFormat:@"¥%@", [Tools getHaveNum:allPrice]];
    
    priceLable.font = [UIFont systemFontOfSize:AdaptFont(14)];
    priceLable.textAlignment = NSTextAlignmentRight;
    [footView addSubview:priceLable];
    [priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-10));
        make.height.mas_equalTo(HeightRate(20));
        make.top.mas_equalTo(tipsRightLableTop.mas_bottom).offset(HeightRate(5));
        
    }];
    
    UILabel *fixlable = [[UILabel alloc] init];
    fixlable.textColor = ColorWithHexString(@"000000") ;
    fixlable.text = [NSString stringWithFormat:@"共%@件商品  合计：",self.contract.ContractQuantity];
    fixlable.font = [UIFont systemFontOfSize:AdaptFont(12)];
    fixlable.textAlignment = NSTextAlignmentRight;
    [footView addSubview:fixlable];
    [fixlable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(priceLable.mas_left).offset(0);
        make.height.mas_equalTo(HeightRate(20));
        make.centerY.mas_equalTo(priceLable.mas_centerY).offset(HeightRate(0));
    }];
    
    UILabel *tipsRightLable = [[UILabel alloc] init];
    tipsRightLable.textColor = ColorWithHexString(SymbolTopColor) ;
    tipsRightLable.font = [UIFont systemFontOfSize:AdaptFont(13)];
    tipsRightLable.textAlignment = NSTextAlignmentRight;
    [footView addSubview:tipsRightLable];
    [tipsRightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-10));
        make.height.mas_equalTo(HeightRate(20));
        make.top.mas_equalTo(priceLable.mas_bottom).offset(HeightRate(5));
        
    }];

    return footView;
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

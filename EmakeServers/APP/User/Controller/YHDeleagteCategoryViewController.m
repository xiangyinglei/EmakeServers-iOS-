//
//  YHDeleagteCategoryViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/9/13.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHDeleagteCategoryViewController.h"
#import "Header.h"
#import "YHDelegateInputCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import <PGDatePicker/PGDatePicker.h>
#import <PGDatePicker/PGDatePickManager.h>
#import "YHCategoryModel.h"
#import "ChatNewViewController.h"
@interface YHDeleagteCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate,UITextFieldDelegate>
@property (nonatomic,retain)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,retain)NSArray *leftTitles;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation YHDeleagteCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"代理品类";
    self.view.backgroundColor = TextColor_F7F7F7;
    self.leftTitles = @[@"提成金额",@"优惠码额度",@"代理开始日期",@"代理截止日期"];
    [self configSubViews];
}
- (void)configSubViews{
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.showsHorizontalScrollIndicator = false;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedSectionFooterHeight = TableViewFooterNone;
    self.tableView.estimatedSectionHeaderHeight = TableViewHeaderNone;
    self.tableView.estimatedRowHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.height.mas_equalTo(HeightRate(500));
    }];
    
    
    UIButton *confrimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confrimButton setTitle:@"确定" forState:UIControlStateNormal];
    [confrimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confrimButton.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
    confrimButton.titleLabel.font = SYSTEM_FONT(AdaptFont(16));
    confrimButton.layer.cornerRadius = WidthRate(3);
    [confrimButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimButton];
    
    [confrimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(310));
        make.bottom.mas_equalTo(HeightRate(-20));
        make.height.mas_equalTo(HeightRate(40));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
- (void)showDatePicker:(NSIndexPath*)indexpath{
    self.indexPath = indexpath;
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.headerViewBackgroundColor = [UIColor whiteColor];
    datePickManager.style = PGDatePickManagerStyle1;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    [self presentViewController:datePickManager animated:false completion:nil];
}
- (void)confirm{
    NSMutableArray *cateNewArray = [NSMutableArray arrayWithCapacity:0];
    for (int i= 0; i<self.cateArray.count; i++) {
        YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:self.cateArray[i]];
        for (int j = 0; j<4; j++) {
            YHDelegateInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
            switch (j) {
                case 0:
                    model.BonusAmount = cell.input.text;
                    break;
                case 1:
                    model.CouponPrice = cell.input.text;
                    break;
                case 2:
                    model.BeginAt = cell.input.text;
                    break;
                default:
                    model.EndAt = cell.input.text;
                    break;
            }
        }
        [cateNewArray addObject:[model mj_keyValues]];
    }
    for (int i= 0; i<cateNewArray.count; i++) {
        
        YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:cateNewArray[i]];
        if (model.BonusAmount.length<=0||!model.BeginAt) {
            [self.view makeToast:@"请输入提成金额" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (model.BonusAmount.doubleValue <= 0.0) {
            [self.view makeToast:@"您输入的提成金额需大于0" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (model.CouponPrice.length<=0||!model.CouponPrice) {
            [self.view makeToast:@"请输入优惠码额度" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (model.CouponPrice.doubleValue <= 0 ) {
            [self.view makeToast:@"您输入的优惠码额度需大于0" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (model.BeginAt.length<=0||!model.BeginAt) {
            [self.view makeToast:@"请选择开始日期" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (model.EndAt.length<=0||!model.EndAt) {
            [self.view makeToast:@"请选择截止日期" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }
    NSDictionary *params = @{@"CategoryBList":cateNewArray,@"UserId":self.userId};
    [[YHJsonRequest shared] auditCityDelegateUserCategoryExchangeWithParams:params SuccessBlock:^(NSString *successMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserInfoRefresh object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
#pragma mark ---UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger section = textField.tag/100;
    NSInteger row = textField.tag - 100*section;
    if (!textField.text || textField.text.length <=0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark --- PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents{
    
    YHDelegateInputCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.input.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
}

#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YHDelegateInputCell *cell = nil;
    if (!cell) {
        cell = [[YHDelegateInputCell alloc]init];
    }
    cell.leftLabel.text = self.leftTitles[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.cateArray[indexPath.section];
    YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:dict];
    switch (indexPath.row) {
        case 0:
            cell.input.placeholder = @"请输入提成金额（元）";
            cell.input.delegate = self;
            cell.input.text = model.BonusAmount;
            cell.input.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 1:
            cell.input.placeholder = @"请输入优惠码额度（元）";
            cell.input.delegate = self;
            cell.input.text = model.CouponPrice;
            cell.input.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 2:
            cell.input.placeholder = @"请选择时间";
            cell.rightImage.image = [UIImage imageNamed:@"direction_down"];
            if (model.BeginAt.length <=0 || !model.BeginAt) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                NSDate *datenow = [NSDate date];
                NSString *currentTimeString = [formatter stringFromDate:datenow];
                cell.input.text = currentTimeString;
            }else{
                NSArray *part = [model.BeginAt componentsSeparatedByString:@" "];
                if (part.count ==2) {
                    cell.input.text = part[0];
                }else{
                    cell.input.text = model.BeginAt;
                }
            }
            cell.input.userInteractionEnabled = false;
            break;
        default:
            cell.input.placeholder = @"请选择时间";
            cell.rightImage.image = [UIImage imageNamed:@"direction_down"];
            cell.input.userInteractionEnabled = false;
            if (model.EndAt.length <=0 || !model.EndAt) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                NSDate *datenow = [NSDate date];
                NSString *currentTimeString = [formatter stringFromDate:datenow];
                NSArray *part = [currentTimeString componentsSeparatedByString:@"-"];
                if (part.count==3) {
                    NSInteger year = [part[0] integerValue];
                    year = year + 1;
                    NSString *timeAfter = [NSString stringWithFormat:@"%ld-%@-%@",year,part[1],part[2]];
                    cell.input.text = timeAfter;
                }
                
            }else{
                NSArray *part = [model.EndAt componentsSeparatedByString:@" "];
                if (part.count ==2) {
                    cell.input.text = part[0];
                }else{
                    cell.input.text = model.EndAt;
                }
            }
            cell.input.userInteractionEnabled = false;
            break;
    }
    cell.input.tag = indexPath.section*100 + indexPath.row;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HeightRate(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TableViewFooterNone;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(50))];
    view.backgroundColor = TextColor_F7F7F7;
    for (int i= 0; i<self.cateArray.count; i++) {
        YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:self.cateArray[i]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WidthRate(10*(i+1))+WidthRate(87*i), HeightRate(7), WidthRate(87), HeightRate(36))];
        label.textColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        label.layer.borderColor = ColorWithHexString(APP_THEME_MAIN_COLOR).CGColor;
        label.layer.borderWidth = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.CategoryBName;
        [view addSubview:label];
    }
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 || indexPath.row == 3) {
        [self showDatePicker:indexPath];
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

//
//  YHMemeberViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/9/13.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMemeberViewController.h"
#import "Header.h"
#import <PGDatePicker/PGDatePicker.h>
#import <PGDatePicker/PGDatePickManager.h>
#import "YHDelegateInputCell.h"
#import "YHCategoryModel.h"
@interface YHMemeberViewController ()<UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate,UITextFieldDelegate>
@property (nonatomic,retain)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,retain)NSArray *leftTitles;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation YHMemeberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员权益";
    self.view.backgroundColor = TextColor_F7F7F7;
    self.leftTitles = @[@"会员权益",@"权益开始日期",@"权益截止日期"];
    [self configSubViews];
    // Do any additional setup after loading the view.
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
        make.height.mas_equalTo(HeightRate(215));
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
#pragma mark --- PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents{
    YHDelegateInputCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.input.text = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
}

#pragma mark ---UITableViewDataSource,UITableViewDelegate
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
        {
            cell.input.text = model.DisCount;
            cell.input.delegate = self;
            cell.input.keyboardType = UIKeyboardTypeDecimalPad;
            cell.rightImage.hidden = YES;
            cell.userInteractionEnabled = false;
        }
            break;
        case 1:{
            cell.input.placeholder = @"请选择时间";
            cell.rightImage.image = [UIImage imageNamed:@"direction_down"];
            cell.input.userInteractionEnabled = false;
            NSArray *part = [model.BeginAt componentsSeparatedByString:@" "];
            if (part.count ==2) {
                cell.input.text = part[0];
            }else{
                cell.input.text = model.BeginAt;
            }
        }
            break;
        default:
            cell.input.placeholder = @"请选择时间";
            cell.rightImage.image = [UIImage imageNamed:@"direction_down"];
            cell.input.userInteractionEnabled = false;
            NSArray *partAnother = [model.EndAt componentsSeparatedByString:@" "];
            if (partAnother.count ==2) {
                cell.input.text = partAnother[0];
            }else{
                cell.input.text = model.EndAt;
            }
            cell.input.text = model.EndAt;
            break;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cateArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HeightRate(55);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TableViewFooterNone;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(50))];
    view.backgroundColor = TextColor_F7F7F7;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WidthRate(10), 0, ScreenWidth, HeightRate(50))];
    label.textColor = TextColor_333333;
    NSDictionary *dict = self.cateArray[section];
    YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:dict];
    label.text = model.CategoryBName;
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 2) {
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

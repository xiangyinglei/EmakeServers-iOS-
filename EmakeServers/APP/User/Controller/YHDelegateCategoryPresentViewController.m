//
//  YHDelegateCategoryPresentViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/9/14.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHDelegateCategoryPresentViewController.h"
#import "Header.h"
@interface YHDelegateCategoryPresentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,retain)NSArray *leftTitles;
@end

@implementation YHDelegateCategoryPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TextColor_F7F7F7;
    if (self.isDelegateOrNot) {
        self.leftTitles = @[@"提成金额：",@"优惠码额度：",@"代理有效期："];
    }else{
      self.leftTitles = @[@"会员权益：",@"权益有效期："];
    }
    [self configSubViews];
    // Do any additional setup after loading the view.
}
- (void)configSubViews{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = RGBColor(249, 249, 249);
    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    if (self.isDelegateOrNot) {
        label.text = @"代理品类";
    }else{
        label.text = @"会员权益";
    }
    label.textColor = TextColor_333333;
    [titleView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = SepratorLineColor;
    [titleView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"guanbitianchukuang"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-20));
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.width.mas_equalTo(WidthRate(15));
        make.height.mas_equalTo(WidthRate(15));
    }];
    
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
        make.top.mas_equalTo(titleView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
}
- (void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.cateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    NSDictionary *dict = self.cateArray[indexPath.section];
    switch (indexPath.row) {
        case 0:
            if (self.isDelegateOrNot) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@元",self.leftTitles[indexPath.row],[dict objectForKey:@"BonusAmount"]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@下单享%@折优惠",self.leftTitles[indexPath.row],[dict objectForKey:@"DisCount"]];
            }
            break;
        case 1:
            if (self.isDelegateOrNot) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@元",self.leftTitles[indexPath.row],[dict objectForKey:@"CouponPrice"]];
            }else{
                NSString *EndAt = [dict objectForKey:@"EndAt"];
                NSArray *part = [EndAt componentsSeparatedByString:@" "];
                if (part.count ==2) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.leftTitles[indexPath.row],part[0]];
                }else{
                    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.leftTitles[indexPath.row],[dict objectForKey:@"EndAt"]];
                }
            }
            break;
        case 2:{
            NSString *EndAt = [dict objectForKey:@"EndAt"];
            NSArray *part = [EndAt componentsSeparatedByString:@" "];
            if (part.count ==2) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.leftTitles[indexPath.row],part[0]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",self.leftTitles[indexPath.row],[dict objectForKey:@"EndAt"]];
            }
        }
            break;
        default:
            break;
    }
    cell.textLabel.textColor = TextColor_333333;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.leftTitles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HeightRate(44);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HeightRate(50);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return TableViewFooterNone;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(50))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, HeightRate(50))];
    label.textColor = TextColor_333333;
    NSDictionary *dict = self.cateArray[section];
    label.text = [dict objectForKey:@"CategoryBName"];
    [view addSubview:label];
    return view;
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
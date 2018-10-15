//
//  YHConvenientReplyViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/4/27.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHConvenientReplyViewController.h"
#import "Header.h"
#import "YHReplyModel.h"
@interface YHConvenientReplyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *largeProblemArray;
@property (nonatomic,strong)NSMutableArray *contentArray;
@property (nonatomic,strong)NSMutableArray *problemArray;
@property (nonatomic,strong)NSString *selectReplyString;
@end

@implementation YHConvenientReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"快捷回复";
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubViews];
    [self getReplyData];
}
- (void)configSubViews{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorColor = SepratorLineColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(HeightRate(-65));
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(HeightRate(65));
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(22));
        make.right.mas_equalTo(WidthRate(-22));
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(HeightRate(38));
    }];
}
- (void)getReplyData{
    [self.view showWait:@"加载中" viewType:CurrentView];
    [[YHJsonRequest shared] getQuickReplySuccessBlock:^(NSArray *array) {
        [self.view hideWait:CurrentView];
        [self classifyReplty:array];
        [self.tableView reloadData];
    } fialureBlock:^(NSString *errorMessages) {
        [self.view hideWait:CurrentView];
        [self.view makeToast:errorMessages duration:1.0 position:CSToastPositionCenter];
    }];
}
- (void)classifyReplty:(NSArray *)array{
    self.problemArray = [NSMutableArray arrayWithCapacity:0];
    for (YHReplyModel *model in array) {
        if (![self.problemArray containsObject:model.ProblemType]) {
            [self.problemArray addObject:model.ProblemType];
        }
    }
    self.largeProblemArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *problem in self.problemArray) {
        NSMutableArray *content = [NSMutableArray arrayWithCapacity:0];
        for (YHReplyModel *model in array) {
            if ([problem isEqualToString:model.ProblemType]) {
                [content addObject:model];
            }
        }
        [self.largeProblemArray addObject:content];
    }
}
- (void)confirm{
    if (!self.selectReplyString||self.selectReplyString.length<=0) {
        [self.view makeToast:@"请选择一个回复语" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    self.replyBlock(self.selectReplyString);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate & UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.largeProblemArray[section];
    return array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.largeProblemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    NSArray *array = self.largeProblemArray[indexPath.section];
    
    YHReplyModel *model = array[indexPath.row];
    UILabel *labelContent = [[UILabel alloc]init];
    labelContent.text = model.Content;
    labelContent.numberOfLines = 0;
    labelContent.font = SYSTEM_FONT(AdaptFont(14));
    
    [cell.contentView addSubview:labelContent];
    [labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(20));
        make.width.mas_equalTo(WidthRate(22));
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        make.right.mas_equalTo(WidthRate(-50));
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageSelect = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_no"]];
    imageSelect.tag = 100;
    [cell.contentView addSubview:imageSelect];
    [imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthRate(-20));
        make.width.mas_equalTo(WidthRate(22));
        make.height.mas_equalTo(WidthRate(22));
        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
    }];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(20))];
    view.backgroundColor = TextColor_F7F7F7;
    UILabel *label =[[UILabel alloc]init];
    NSString *problem = self.problemArray[section];
    label.text = problem;
    label.font = SYSTEM_FONT(AdaptFont(13));
    label.textColor = TextColor_666666;
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(20));
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeightRate(37);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageselect = [cell.contentView viewWithTag:100];
    imageselect.image = [UIImage imageNamed:@"select_yes"];
    NSArray *array = self.largeProblemArray[indexPath.section];
    YHReplyModel *model = array[indexPath.row];
    self.selectReplyString = model.Content;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageselect = [cell.contentView viewWithTag:100];
    imageselect.image = [UIImage imageNamed:@"select_no"];
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

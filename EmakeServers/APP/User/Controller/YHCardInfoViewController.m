//
//  YHCardInfoViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHCardInfoViewController.h"
#import "Header.h"
#import "YHIdentityInfoViewController.h"
#import "YHCardImageTableViewCell.h"
#import "YHMineTableViewCell.h"
#import "YHAuditUserViewController.h"
@interface YHCardInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,retain)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,retain)NSArray *leftTilteTwo;
@property (nonatomic,retain)PlaceholderTextView *textView;
@end

@implementation YHCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"名片信息";
    self.view.backgroundColor = TextColor_F7F7F7;
    [self configSubViews];
    [self configBottomView];
    self.leftTilteTwo = [NSArray arrayWithObjects:@"经营品类：",@"公司：",@"办公电话：",@"部门：",@"职务：",@"E-mail：",@"地址：", nil];
    [self addRigthDropBtn];
}
- (void)configSubViews{
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
- (void)configBottomView{
    
    UIView *view =[[UIView alloc]init];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    UIButton *pass = [UIButton buttonWithType:UIButtonTypeCustom];
    [pass setTitle:@"通过" forState:UIControlStateNormal];
    [pass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pass setBackgroundColor:ColorWithHexString(APP_THEME_MAIN_COLOR)];
    [pass addTarget:self action:@selector(passNext) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pass];
    
    [pass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WidthRate(159));
        make.right.mas_equalTo(WidthRate(-22));
        make.centerY.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(HeightRate(40));
    }];
    
    UIButton *Unpass = [UIButton buttonWithType:UIButtonTypeCustom];
    [Unpass setTitle:@"不通过" forState:UIControlStateNormal];
    [Unpass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Unpass setBackgroundColor:ColorWithHexString(SymbolTopColor)];
    [Unpass addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Unpass];
    
    [Unpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(22));
        make.width.mas_equalTo(WidthRate(159));
        make.centerY.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(HeightRate(40));
    }];
    
}
- (void)passNext{
    
    YHIdentityInfoViewController *vc = [[YHIdentityInfoViewController alloc]init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)reject{
    
    [self.view endEditing:YES];
    if (!self.model.UserId||self.model.UserId.length<=0) {
        self.model.UserId = @"";
    }
    if (!self.model.AuditRemark||self.model.AuditRemark.length<=0) {
        self.model.AuditRemark = @"";
    }
    if (!self.model.UserState||self.model.UserState<=0) {
        self.model.UserState = 1;
    }
    if (!self.model.UserType||self.model.UserType.length<=0) {
        self.model.UserType = @"";
    }
    if (!self.model.RealName||self.model.RealName.length<=0) {
        self.model.RealName = @"";
    }
    if (!self.model.Sex||self.model.Sex.length<=0) {
        self.model.Sex = @"";
    }
    if (!self.model.Title||self.model.Title.length<=0) {
        self.model.Title = @"";
    }
    if (!self.model.Company||self.model.Company.length<=0) {
        self.model.Company = @"";
    }
    if (!self.model.Address||self.model.Address.length<=0) {
        self.model.Address = @"";
    }
    if (!self.model.Email||self.model.Email.length<=0) {
        self.model.Email = @"";
    }
    if (!self.model.TelCell||self.model.TelCell.length<=0) {
        self.model.TelCell = @"";
    }
    if (!self.model.PSPDId||self.model.PSPDId.length<=0) {
        self.model.PSPDId = @"";
    }
    if (!self.model.TelWork||self.model.TelWork.length<=0) {
        self.model.TelWork = @"";
    }
    if (!self.model.Department||self.model.Department.length<=0) {
        self.model.Department = @"";
    }
    if (!self.model.Province||self.model.Province.length<=0) {
        self.model.Province = @"";
    }
    if (!self.model.City||self.model.City.length<=0) {
        self.model.City = @"";
    }
    self.model.UserState = 4;
}
- (void)tapCardImage{
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < 1;i++)
    {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        // 加载网络图片大图地址
        browseItem.bigImageUrl = self.model.RawCardUrl;
        // 小图
        //browseItem.smallImageView = imageView;
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:0];
    bvc.isEqualRatio = YES;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}
#pragma mark ___UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.placeholder = @"";
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (!textView.text||textView.text.length<=0) {
        self.textView.placeholder = @"    审核备注";
    }else{
        self.model.AuditRemark = textView.text;
    }
}
#pragma mark ---UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            YHCardImageTableViewCell *cell = nil;
            if (!cell) {
                cell =[[YHCardImageTableViewCell alloc]init];
            }
            [cell.cardImage sd_setImageWithURL:[NSURL URLWithString:self.model.RawCardUrl] placeholderImage:[UIImage imageNamed:@"mingpian"]];
            UITapGestureRecognizer *gestureOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCardImage)];
            [cell.cardImage addGestureRecognizer:gestureOne];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            YHMineTableViewCell *cell = nil;
            if (!cell) {
                cell =[[YHMineTableViewCell alloc]init];
            }
            cell.leftLabel.text = self.leftTilteTwo[indexPath.row-1];
            switch (indexPath.row) {
                case 1:
                    cell.rightLabel.text = self.model.BusinessCategoryName;
                    break;
                case 2:
                    cell.rightLabel.text = self.model.Company;
                    break;
                case 3:
                    cell.rightLabel.text = self.model.TelCell;
                    break;
                case 4:
                    cell.rightLabel.text = self.model.Department;
                    break;
                case 5:
                    cell.rightLabel.text = self.model.Title;
                    break;
                case 6:
                    cell.rightLabel.text = self.model.Email;
                    break;
                case 7:
                    cell.rightLabel.text = self.model.Address;
                    break;
                default:
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        self.textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightRate(78))];
        self.textView.placeholder = @"    审核备注";
        self.textView.placeholderColor = TextColor_797979;
        self.textView.delegate = self;
        [cell.contentView addSubview:self.textView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return  HeightRate(188);
        }else{
            return HeightRate(44);
        }
    }else{
        return HeightRate(78);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TableViewHeaderNone;
    }else{
        return HeightRate(38);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = TextColor_F5F5F5;
        UILabel *label = [[UILabel alloc]init];
        label.text = @"名片审核";
        label.font = [UIFont systemFontOfSize:AdaptFont(15)];
        label.textColor = TextColor_999999;
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(20));
            make.centerY.mas_equalTo(view.mas_centerY);
            make.height.mas_equalTo(HeightRate(20));
        }];
        return view;
    }else{
        return nil;
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

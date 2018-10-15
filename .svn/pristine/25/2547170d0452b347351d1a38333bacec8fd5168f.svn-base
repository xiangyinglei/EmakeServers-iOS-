//
//  YHCategoryViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/17.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHCategoryViewController.h"
#import "Header.h"
#import "YHCategoryModel.h"
@interface YHCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YHCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"经营品类";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSubViews];
    [self classifyCategory];
}
- (void)configSubViews{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我的品类";
    label.textColor = TextColor_333333;
    label.font = SYSTEM_FONT(AdaptFont(16));
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(18));
        make.top.mas_equalTo(HeightRate(20)+(TOP_BAR_HEIGHT));
        make.height.mas_equalTo(HeightRate(22));
    }];
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, HeightRate(25));
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(label.mas_bottom).offset(HeightRate(10));
        make.bottom.mas_equalTo(HeightRate(0));
    }];
}
- (void)classifyCategory{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.StoreCategoryDetail) {
        YHCategoryModel *model = [YHCategoryModel mj_objectWithKeyValues:dict];
        [self.dataArray addObject:model];
    }
}
#pragma mark -----UICollectionViewDelegate & UICollectionViewDataSources
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    YHCategoryModel *model = self.dataArray[section];
    return model.CategoryCList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    for(UIView * subView in item.subviews){
        if(subView){
            [subView removeFromSuperview];
        }
    }
    if (!item) {
        item = [[UICollectionViewCell alloc]init];
    }
    YHCategoryModel *model = self.dataArray[indexPath.section];
    UILabel *btn = [[UILabel alloc]initWithFrame:item.bounds];
    btn.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = model.CategoryCList[indexPath.item];
    btn.text = [dict objectForKey:@"CategoryCName"];
    btn.font = SYSTEM_FONT(AdaptFont(12));
    btn.tag = indexPath.item + 100;
    btn.layer.borderWidth = 1;
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = SepratorLineColor.CGColor;
    btn.textColor = TextColor_2B2B2B;
    [item addSubview:btn];
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHCategoryModel *model = self.dataArray[indexPath.section];
    NSDictionary *dict = model.CategoryCList[indexPath.item];
    NSString *cateName = [dict objectForKey:@"CategoryCName"];
    CGFloat width = cateName.length*12+10;
    return CGSizeMake(WidthRate(width), HeightRate(31));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return WidthRate(16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return HeightRate(10);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(HeightRate(13), WidthRate(18), HeightRate(13), WidthRate(10));
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YHCategoryModel *model = self.dataArray[indexPath.section];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] init];
    label.text = model.CategoryBName;
    label.font = SYSTEM_FONT(AdaptFont(13));
    label.textColor = TextColor_333333;
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(18));
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    return headerView;
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

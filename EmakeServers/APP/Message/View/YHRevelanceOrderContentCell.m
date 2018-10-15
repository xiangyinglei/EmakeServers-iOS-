//
//  YHRevelanceOrderContentCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/6.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHRevelanceOrderContentCell.h"
#import "Header.h"
@interface YHRevelanceOrderContentCell()
@property (nonatomic,strong)YHItemModel *model;
@property (nonatomic,strong)UIImageView *itemImage;
@property (nonatomic,strong)UILabel *itemName;
@property (nonatomic,strong)UILabel *itemPrice;
@property (nonatomic,strong)UILabel *itemState;
@end
@implementation YHRevelanceOrderContentCell
- (instancetype)init{
    if (self = [super init]) {
        
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = SepratorLineColor;
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0.7);
        }];
        
        self.itemImage = [[UIImageView alloc]init];
        self.itemImage.contentMode = UIViewContentModeScaleAspectFit;
        self.itemImage.layer.borderColor = SepratorLineColor.CGColor;
        self.itemImage.layer.borderWidth = 1;
        [self.contentView addSubview:self.itemImage];
        
        [self.itemImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(18));
            make.width.mas_equalTo(WidthRate(59));
            make.height.mas_equalTo(WidthRate(59));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
    
        self.itemName = [[UILabel alloc]init];
        self.itemName.font = SYSTEM_FONT(AdaptFont(14));
        self.itemName.text = @"S11系列油浸式变压器";
        [self.contentView addSubview:self.itemName];

        [self.itemName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.itemImage.mas_right).offset(WidthRate(13));
            make.top.mas_equalTo(HeightRate(10));
            make.height.mas_equalTo(HeightRate(20));
        }];
        
        self.itemPrice = [[UILabel alloc]init];
        self.itemPrice.font = SYSTEM_FONT(AdaptFont(18));
        self.itemPrice.text = @"￥7000.00";
        self.itemPrice.textColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        [self.contentView addSubview:self.itemPrice];
        
        [self.itemPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.itemImage.mas_right).offset(WidthRate(13));
            make.top.mas_equalTo(self.itemName.mas_bottom).offset(HeightRate(7));
            make.height.mas_equalTo(HeightRate(25));
        }];
        
        self.revelanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.revelanceButton.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        [self.revelanceButton setTitle:@"关联订单" forState:UIControlStateNormal];
        [self.revelanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.revelanceButton.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
        self.revelanceButton.layer.cornerRadius = WidthRate(3);
        [self.revelanceButton addTarget:self action:@selector(goRevelance) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.revelanceButton];
        
        [self.revelanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.height.mas_equalTo(HeightRate(27));
            make.width.mas_equalTo(WidthRate(79));
            make.bottom.mas_equalTo(HeightRate(-11));
        }];
    }
    return self;
}
- (void)goRevelance{
    if (self.revelanceBlock) {
        if (self.model != nil) {
            self.revelanceBlock(@"success");
        }
    }
}
- (void)setData:(YHItemModel *)goods{
    self.model = goods;
    [self.itemImage sd_setImageWithURL:[NSURL URLWithString:goods.GoodsSeriesIcon] placeholderImage:[UIImage imageNamed:@""]];
    self.itemName.text = goods.GoodsTitle;
    self.itemPrice.text = [NSString stringWithFormat:@"¥%@",goods.MainProductPrice];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  YHStoreTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHStoreTableViewCell.h"
#import "Header.h"


@interface YHStoreTableViewCell()
@property (nonatomic,strong)UIImageView *storeImage;
@property (nonatomic,strong)UILabel *storeName;
@property (nonatomic,strong)UILabel *storeChargeName;
@property (nonatomic,strong)UILabel *storeChargePhoneNumber;

@end

@implementation YHStoreTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.storeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.storeImage.layer.cornerRadius = WidthRate(3);
        [self.contentView addSubview:self.storeImage];
        
        [self.storeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(10));
            make.width.mas_equalTo(WidthRate(40));
            make.height.mas_equalTo(WidthRate(40));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.storeName = [[UILabel alloc] init];
        self.storeName.font = SYSTEM_FONT(AdaptFont(14));
        self.storeName.text = @"江苏天成食品销售中心";
        [self.contentView addSubview:self.storeName];

        [self.storeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(4));
            make.top.mas_equalTo(HeightRate(7));
            make.height.mas_equalTo(HeightRate(15));
        }];

        self.storeChargeName = [[UILabel alloc] init];
        self.storeChargeName.font = SYSTEM_FONT(AdaptFont(9));
        self.storeChargeName.text = @"掌柜：张三三";
        self.storeChargeName.textColor = TextColor_333333;
        [self.contentView addSubview:self.storeChargeName];

        [self.storeChargeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(4));
            make.top.mas_equalTo(self.storeName.mas_bottom).offset(HeightRate(5));
            make.height.mas_equalTo(HeightRate(10));
        }];


        self.storeChargePhoneNumber = [[UILabel alloc] init];
        self.storeChargePhoneNumber.font = SYSTEM_FONT(AdaptFont(9));
        self.storeChargePhoneNumber.text = @"手机：13338619241";
        self.storeChargePhoneNumber.textColor = TextColor_333333;
        [self.contentView addSubview:self.storeChargePhoneNumber];

        [self.storeChargePhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(4));
            make.top.mas_equalTo(self.storeChargeName.mas_bottom).offset(HeightRate(4));
            make.height.mas_equalTo(HeightRate(10));
        }];
        
        self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [self.sendMessageBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        self.sendMessageBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        self.sendMessageBtn.layer.borderWidth = WidthRate(2);
        self.sendMessageBtn.layer.borderColor = ColorWithHexString(APP_THEME_MAIN_COLOR).CGColor;
        self.sendMessageBtn.layer.cornerRadius = WidthRate(15);
        [self.contentView addSubview:self.sendMessageBtn];
        
        [self.sendMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(WidthRate(-18));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(WidthRate(60));
            make.height.mas_equalTo(HeightRate(30));
        }];
        
    }
    return self;
}
- (void)setData:(YHStoreModel *)model{
    SVGKImage *svgImage = [SVGKImage imageNamed:@"dianpuicon_fang"];
    svgImage.size = CGSizeMake(WidthRate(40), WidthRate(40));
    [self.storeImage sd_setImageWithURL:[NSURL URLWithString:model.StorePhoto] placeholderImage:svgImage.UIImage];
    self.storeName.text = model.StoreName;
    self.storeChargeName.text = [NSString stringWithFormat:@"掌柜：%@",model.RealName];
    self.storeChargePhoneNumber.text = [NSString stringWithFormat:@"手机：%@",model.MobileNumber];
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

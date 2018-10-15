//
//  YHStoreDetailHeaderCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHStoreDetailHeaderCell.h"
#import "Header.h"
@interface YHStoreDetailHeaderCell()
@property (nonatomic,strong)UIImageView *storeImage;
@property (nonatomic,strong)UILabel *storeName;
@property (nonatomic,strong)UILabel *storeNo;
@property (nonatomic,strong)UILabel *storeInviteFrom;
@end
@implementation YHStoreDetailHeaderCell
- (instancetype)init{
    if (self = [super init]) {
        self.storeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.storeImage.layer.cornerRadius = WidthRate(3);
        [self.contentView addSubview:self.storeImage];
        
        [self.storeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(18));
            make.width.mas_equalTo(WidthRate(74));
            make.height.mas_equalTo(WidthRate(74));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.storeName = [[UILabel alloc] init];
        self.storeName.font = SYSTEM_FONT(AdaptFont(16));
        self.storeName.text = @"江苏天成食品销售中心";
        [self.contentView addSubview:self.storeName];
        
        [self.storeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(13));
            make.top.mas_equalTo(HeightRate(16));
            make.height.mas_equalTo(HeightRate(25));
        }];
        
        self.storeNo = [[UILabel alloc] init];
        self.storeNo.font = SYSTEM_FONT(AdaptFont(14));
        self.storeNo.text = @"店铺编号  00574";
        self.storeNo.textColor = TextColor_333333;
        [self.contentView addSubview:self.storeNo];
        
        [self.storeNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(13));
            make.centerY.mas_equalTo(self.storeImage.mas_centerY);
            make.height.mas_equalTo(HeightRate(15));
        }];
        
        
        self.storeInviteFrom = [[UILabel alloc] init];
        self.storeInviteFrom.font = SYSTEM_FONT(AdaptFont(14));
        self.storeInviteFrom.text = @"邀请店铺  三只小猪食品销售公司";
        self.storeInviteFrom.textColor = TextColor_333333;
        [self.contentView addSubview:self.storeInviteFrom];
        
        [self.storeInviteFrom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(13));
            make.top.mas_equalTo(self.storeNo.mas_bottom).offset(HeightRate(10));
            make.height.mas_equalTo(HeightRate(15));
        }];
        
        UILabel *labelLine = [[UILabel alloc]init];
        labelLine.backgroundColor = SepratorLineColor;
        [self.contentView addSubview:labelLine];
        
        [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
- (void)setData:(YHStoreModel *)model{
    SVGKImage *svgImage = [SVGKImage imageNamed:@"dianpuicon_fang"];
    svgImage.size = CGSizeMake(WidthRate(74), WidthRate(74));
    [self.storeImage sd_setImageWithURL:[NSURL URLWithString:model.StorePhoto] placeholderImage:svgImage.UIImage];
    self.storeName.text = model.StoreName;
    self.storeNo.text = [NSString stringWithFormat:@"店铺编号  %@",model.StoreNum];
    self.storeInviteFrom.text = [NSString stringWithFormat:@"邀请店铺  %@",model.InvitedStore];
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

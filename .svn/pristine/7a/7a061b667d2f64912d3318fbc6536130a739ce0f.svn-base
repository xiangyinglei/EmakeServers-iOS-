//
//  YHStoreChargeCardCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHStoreChargeCardCell.h"
#import "Header.h"
@interface YHStoreChargeCardCell()
@end
@implementation YHStoreChargeCardCell
- (instancetype)init{
    if (self = [super init]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"掌柜名片";
        label.font = SYSTEM_FONT(AdaptFont(16));
        label.textColor = TextColor_333333;
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(20));
            make.top.mas_equalTo(HeightRate(12));
        }];
        
        
        self.cardImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.cardImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.cardImage];
        
        [self.cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(18));
            make.width.mas_equalTo(WidthRate(286));
            make.height.mas_equalTo(HeightRate(156));
            make.top.mas_equalTo(label.mas_bottom).offset(HeightRate(15));
        }];
        
    }
    return self;
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

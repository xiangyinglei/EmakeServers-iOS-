//
//  YHStoreDescriptionCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHStoreDescriptionCell.h"
#import "Header.h"
@implementation YHStoreDescriptionCell
- (instancetype)init{
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"店铺简介";
        label.textColor = TextColor_333333;
        label.font = SYSTEM_FONT(AdaptFont(16));
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(20));
            make.top.mas_equalTo(HeightRate(12));
        }];
        
        
        self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.font = SYSTEM_FONT(AdaptFont(12));
        self.descriptionLabel.userInteractionEnabled = false;
        [self.contentView addSubview:self.descriptionLabel];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(18));
            make.top.mas_equalTo(label.mas_bottom).offset(HeightRate(15));
            make.right.mas_equalTo(WidthRate(-25));
            make.height.mas_equalTo(HeightRate(167));
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

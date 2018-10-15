//
//  YHDelegateInputCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/9/13.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHDelegateInputCell.h"
#import "Header.h"
@implementation YHDelegateInputCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.font = SYSTEM_FONT(AdaptFont(16));
        self.leftLabel.text = @"提成金额";
        self.leftLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.leftLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(10));
            make.height.mas_equalTo(HeightRate(20));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.input = [[UITextField alloc]init];
        self.input.font = SYSTEM_FONT(AdaptFont(16));
        self.input.textColor = TextColor_333333;
        [self.contentView addSubview:self.input];
        
        [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(132));
            make.width.mas_equalTo(WidthRate(180));
            make.height.mas_equalTo(HeightRate(40));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"direction_right"]];
        self.rightImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.rightImage];
        
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.width.mas_lessThanOrEqualTo(WidthRate(15));
            make.height.mas_lessThanOrEqualTo(WidthRate(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
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

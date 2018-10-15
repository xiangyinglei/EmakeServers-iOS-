//
//  YHMineTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMineTableViewCell.h"
#import "Header.h"
@interface YHMineTableViewCell()

@end
@implementation YHMineTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.font = SYSTEM_FONT(AdaptFont(16));
        self.leftLabel.text = @"用户名";
        self.leftLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.leftLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(20));
            make.height.mas_equalTo(HeightRate(20));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.rightLabel = [[UILabel alloc]init];
        self.rightLabel.font = SYSTEM_FONT(AdaptFont(16));
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.rightLabel];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-20));
            make.width.mas_lessThanOrEqualTo(WidthRate(260));
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

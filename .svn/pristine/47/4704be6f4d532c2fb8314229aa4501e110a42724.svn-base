//
//  YHMineHeaderTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/2.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMineHeaderTableViewCell.h"
#import "Header.h"
@implementation YHMineHeaderTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.leftLabel = [[UILabel alloc]init];
        self.leftLabel.text = @"用户名";
        self.leftLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.leftLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(20));
            make.height.mas_equalTo(HeightRate(20));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanfangkefu"]];
        [self.contentView addSubview:self.headImage];
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-20));
            make.height.mas_equalTo(WidthRate(69));
            make.width.mas_equalTo(WidthRate(69));
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

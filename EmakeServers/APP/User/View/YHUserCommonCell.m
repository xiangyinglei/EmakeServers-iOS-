//
//  YHUserCommonCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHUserCommonCell.h"
#import "Header.h"
@interface YHUserCommonCell()

@end
@implementation YHUserCommonCell
- (instancetype)init{
    if (self = [super init]) {
        self.headImage = [[UIImageView alloc]init];
        self.headImage.layer.cornerRadius = WidthRate(18.5);
        self.headImage.clipsToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headImage];
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(30));
            make.height.mas_equalTo(WidthRate(37));
            make.width.mas_equalTo(WidthRate(37));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        self.nameLabel.text = @"用户名";
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(10));
            make.top.mas_equalTo(HeightRate(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.countLabel = [[UILabel alloc]init];
        self.countLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        self.countLabel.text = @"145";
        self.countLabel.textColor = TextColor_999999;
        [self.contentView addSubview:self.countLabel];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-30));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(HeightRate(20));
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

//
//  YHIDImageTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/2.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHIDImageTableViewCell.h"
#import "Header.h"
@implementation YHIDImageTableViewCell
- (instancetype)init{
    if (self =[super init]) {
        self.IDImageSide = [[UIImageView alloc]init];
        self.IDImageSide.image = [UIImage imageNamed:@"shenfenzheng-zheng"];
        self.IDImageSide.userInteractionEnabled = YES;
        [self.contentView addSubview:self.IDImageSide];
        
        [self.IDImageSide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WidthRate(264));
            make.height.mas_equalTo(WidthRate(152));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(HeightRate(13));
        }];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.font = SYSTEM_FONT(AdaptFont(13));
        label.text = @"身份证正面";
        label.textColor =TextColor_797979;
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.IDImageSide.mas_bottom).offset(HeightRate(5));
            make.height.mas_equalTo(HeightRate(15));
        }];
        
        self.IDImageBackSide = [[UIImageView alloc]init];
        self.IDImageBackSide.image = [UIImage imageNamed:@"shenfenzheng-fan"];
        self.IDImageBackSide.userInteractionEnabled = YES;
        [self.contentView addSubview:self.IDImageBackSide];
        
        [self.IDImageBackSide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WidthRate(264));
            make.height.mas_equalTo(WidthRate(152));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(label.mas_bottom).offset(HeightRate(30));
        }];
        
        
        UILabel *labelAnother = [[UILabel alloc]init];
        labelAnother.font = SYSTEM_FONT(AdaptFont(13));
        labelAnother.text = @"身份证反面";
        labelAnother.textColor = TextColor_797979;
        [self.contentView addSubview:labelAnother];
        
        [labelAnother mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.IDImageBackSide.mas_bottom).offset(HeightRate(5));
            make.height.mas_equalTo(HeightRate(15));
        }];
        
        UILabel *labelLineAnother = [[UILabel alloc]init];
        labelLineAnother.backgroundColor = SepratorLineColor;
        [self.contentView addSubview:labelLineAnother];
        
        [labelLineAnother mas_makeConstraints:^(MASConstraintMaker *make) {
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

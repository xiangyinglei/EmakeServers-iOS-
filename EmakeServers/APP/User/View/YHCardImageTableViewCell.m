//
//  YHCardImageTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHCardImageTableViewCell.h"
#import "Header.h"
@interface YHCardImageTableViewCell()

@end
@implementation YHCardImageTableViewCell
- (instancetype)init{
    if (self =[super init]) {
        self.cardImage = [[UIImageView alloc]init];
        self.cardImage.image = [UIImage imageNamed:@"mingpian"];
        self.cardImage.userInteractionEnabled = YES;
        [self.contentView addSubview:self.cardImage];
        
        [self.cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WidthRate(264));
            make.height.mas_equalTo(HeightRate(148));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(HeightRate(13));
        }];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.font = SYSTEM_FONT(AdaptFont(13));
        label.text = @"名片";
        label.textColor =TextColor_797979;
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.cardImage.mas_bottom).offset(HeightRate(5));
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

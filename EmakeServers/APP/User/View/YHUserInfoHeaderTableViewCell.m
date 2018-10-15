//
//  YHUserInfoHeaderTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHUserInfoHeaderTableViewCell.h"
#import "Header.h"
@interface YHUserInfoHeaderTableViewCell()
@property (nonatomic,retain)UIImageView *headImage;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *phoneLabel;
@property (nonatomic,retain)UIImageView *flagImage;
@end
@implementation YHUserInfoHeaderTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        self.headImage = [[UIImageView alloc]init];
        self.headImage.image = [UIImage imageNamed:@"daishenhe-65"];
        self.headImage.layer.cornerRadius = WidthRate(32.5);
        self.headImage.clipsToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headImage];
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(30));
            make.height.mas_equalTo(WidthRate(65));
            make.width.mas_equalTo(WidthRate(65));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.flagImage = [[UIImageView alloc]init];
        self.flagImage.layer.cornerRadius = WidthRate(13);
        self.flagImage.clipsToBounds = YES;
        self.flagImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.flagImage];
        
        [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.headImage.mas_centerX).offset(WidthRate(23));
            make.height.mas_equalTo(WidthRate(26));
            make.width.mas_equalTo(WidthRate(26));
            make.centerY.mas_equalTo(self.headImage.mas_centerY).offset(WidthRate(23));
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        self.nameLabel.text = @"用户名";
        self.nameLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(16));
            make.top.mas_equalTo(HeightRate(18));
            make.height.mas_equalTo(HeightRate(21));
        }];
        
        UILabel *labelLine = [[UILabel alloc]init];
        labelLine.backgroundColor = SepratorLineColor;
        [self.contentView addSubview:labelLine];
        
        [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(16));
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoujiicon"]];
        [self.contentView addSubview:phoneImage];
        
        [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(16));
            make.width.mas_equalTo(WidthRate(18));
            make.height.mas_equalTo(HeightRate(21));
            make.top.mas_equalTo(labelLine.mas_bottom).offset(HeightRate(10));
        }];
        
        self.phoneLabel = [[UILabel alloc]init];
        self.phoneLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        self.phoneLabel.text = @"17740879467";
        self.phoneLabel.textColor = TextColor_333333;
        [self.contentView addSubview:self.phoneLabel];
        
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(phoneImage.mas_right).offset(WidthRate(13));
            make.top.mas_equalTo(HeightRate(18));
            make.centerY.mas_equalTo(phoneImage.mas_centerY);
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
- (void)setData:(YHUserModel *)model{
    
    if ([model.UserIdentity isEqualToString:@"1"]) {
        
        self.flagImage.image = [UIImage imageNamed:@"dailishangbiaozhi"];
        
    }else if ([model.UserIdentity isEqualToString:@"2"]) {
        
        self.flagImage.image = [UIImage imageNamed:@"huiyuanbiaozhi"];
        
    }else if ([model.UserIdentity isEqualToString:@"3"]) {
        
        self.flagImage.image = [UIImage imageNamed:@"huiyuanbiaozhi"];
    }else{
        
        self.flagImage.image = [UIImage imageNamed:@""];
    }
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadImageUrl] placeholderImage:[UIImage imageNamed:@"hehuoren-65"]];
    if (!model.RealName||model.RealName.length<=0) {
        self.nameLabel.text = [NSString stringWithFormat:@"用户%@",[model.MobileNumber substringFromIndex:model.MobileNumber.length-4]];
    }else{
        self.nameLabel.text = model.RealName;
    }
    self.phoneLabel.text = model.MobileNumber;
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

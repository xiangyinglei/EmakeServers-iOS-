//
//  YHMessageListTableViewCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMessageListTableViewCell.h"
#import "Header.h"
#import "YHGroupModel.h"
@interface YHMessageListTableViewCell()

@end
@implementation YHMessageListTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WidthRate(50), WidthRate(50))];
        self.headImage.contentMode = UIViewContentModeScaleAspectFit;
        self.headImage.layer.cornerRadius = WidthRate(25);
        self.headImage.clipsToBounds = YES;
        [self.contentView addSubview:self.headImage];
        
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(15));
            make.height.mas_equalTo(WidthRate(50));
            make.width.mas_equalTo(WidthRate(50));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        
        self.flagImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WidthRate(16), WidthRate(16))];
        self.flagImage.contentMode = UIViewContentModeScaleAspectFit;
        self.flagImage.layer.cornerRadius = WidthRate(8);
        self.flagImage.clipsToBounds = YES;
        [self.contentView addSubview:self.flagImage];
        
        [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.headImage.mas_centerX).offset(WidthRate(17));
            make.height.mas_equalTo(WidthRate(16));
            make.width.mas_equalTo(WidthRate(16));
            make.centerY.mas_equalTo(self.headImage.mas_centerY).offset(WidthRate(17));;
        }];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        self.nameLabel.text = @"用户名";
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(10));
            make.top.mas_equalTo(HeightRate(15));
            make.height.mas_equalTo(HeightRate(18));
            make.width.mas_equalTo(WidthRate(200));
        }];
        
        self.messageLabel = [[UILabel alloc]init];
        self.messageLabel.textColor = TextColor_666666;
        self.messageLabel.font = [UIFont systemFontOfSize:AdaptFont(14)];
        [self.contentView addSubview:self.messageLabel];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(10));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(HeightRate(5));
            make.height.mas_equalTo(HeightRate(14));
            make.right.mas_equalTo(WidthRate(-90));
        }];
        
        
        self.timelabel = [[UILabel alloc]init];
        self.timelabel.textColor = TextColor_888888;
        self.timelabel.font = [UIFont systemFontOfSize:12];
        self.timelabel.text = @"18/10/29";
        [self.contentView addSubview:self.timelabel];
        
        [self.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.top.mas_equalTo(HeightRate(15));
            make.height.mas_equalTo(HeightRate(13));
        }];
        
        
        self.messageCountLabel = [[UILabel alloc]init];
        self.messageCountLabel.textColor = [UIColor whiteColor];
        self.messageCountLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
        self.messageCountLabel.text = @"10";
        self.messageCountLabel.clipsToBounds = YES;
        self.messageCountLabel.textAlignment = NSTextAlignmentCenter;
        self.messageCountLabel.layer.cornerRadius = WidthRate(9);
        self.messageCountLabel.font = [UIFont systemFontOfSize:14];
        self.messageCountLabel.backgroundColor = ColorWithHexString(SymbolTopColor);
        [self.contentView addSubview:self.messageCountLabel];
        
        [self.messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.top.mas_equalTo(self.timelabel.mas_bottom).offset(HeightRate(4));
            make.height.mas_equalTo(WidthRate(18));
            make.width.mas_equalTo(WidthRate(18));
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
- (void)setData:(SDChatMessage *)model{

    if ([model.userId containsString:@"_"]) {
        NSDictionary *dict = [model.group mj_JSONObject];
        YHGroupModel *group = [YHGroupModel mj_objectWithKeyValues:dict];
        SVGKImage *svgImage = [SVGKImage imageNamed:@"dianpuicon_fang"];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:group.GroupPhoto] placeholderImage:svgImage.UIImage];
        if (!group.GroupName||group.GroupName.length<=0) {
            self.nameLabel.text = model.staffName;
        }else{
            self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",group.GroupName,model.staffName];
        }
        self.flagImage.hidden = true;
    }else{
        
        if (!model.staffName||model.staffName.length<=0) {
            self.nameLabel.text = [NSString stringWithFormat:@"用户%@",[model.phoneNumber substringFromIndex:model.phoneNumber.length-4]];
            
        }else{
            self.nameLabel.text = model.staffName;
        }
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.staffAvata] placeholderImage:[UIImage imageNamed:@"hehuoren-65"]];
        if ([model.staffType isEqualToString:@"0"]) {
            self.flagImage.hidden = true;
        }else if ([model.staffType isEqualToString:@"1"]) {
            self.flagImage.hidden = false;
            self.flagImage.image = [UIImage imageNamed:@"dailishangbiaozhi"];
        }else if ([model.staffType isEqualToString:@"2"]) {
            self.flagImage.hidden = false;
            self.flagImage.image = [UIImage imageNamed:@"huiyuanbiaozhi"];
        }else if ([model.staffType isEqualToString:@"3"]) {
            self.flagImage.hidden = false;
            self.flagImage.image = [UIImage imageNamed:@"huiyuanbiaozhi"];
        }
    }
    if ([model.msgType isEqualToString:@"Text"]) {
        self.messageLabel.text = model.msg;
    }else if([model.msgType isEqualToString:@"Image"]){
        self.messageLabel.text = @"[图片]";
    }else if([model.msgType isEqualToString:@"Order"]){
        self.messageLabel.text = @"[订单]";
    }else if([model.msgType isEqualToString:@"MutilePart"]){
        self.messageLabel.text = @"[合同]";
    }else if([model.msgType isEqualToString:@"Goods"]){
        self.messageLabel.text = @"[商品]";
    }else if([model.msgType isEqualToString:@"Voice"]){
        self.messageLabel.text = @"[语音]";
    }else if([model.msgType isEqualToString:@"File"]){
        self.messageLabel.text = @"[文件]";
    }
    NSArray *stringArray = [model.sendTime componentsSeparatedByString:@" "];
    if (stringArray.count>=1) {
        self.timelabel.text = stringArray[0];
    }
    if ([model.messageCount integerValue] <=0) {
        self.messageCountLabel.hidden = true;
    }else if ([model.messageCount integerValue] >=99) {
        self.messageCountLabel.hidden = false;
        self.messageCountLabel.text = @"99+";
    }else{
        self.messageCountLabel.hidden = false;
        self.messageCountLabel.text = model.messageCount;
    }
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

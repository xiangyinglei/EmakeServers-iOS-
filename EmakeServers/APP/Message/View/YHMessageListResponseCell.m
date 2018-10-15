//
//  YHMessageListResponseCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/2.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHMessageListResponseCell.h"
#import "Header.h"
#import "YHGroupModel.h"
@interface YHMessageListResponseCell()
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *timelabel;
@property (nonatomic,strong)UILabel *userTypeLabel;
@property (nonatomic,strong)UIButton *responseButton;
@property (nonatomic,retain)UIImageView *flagImage;
@property (nonatomic,strong)SDChatMessage *message;
@end
@implementation YHMessageListResponseCell
- (instancetype)init{
    if (self = [super init]) {
        
        self.headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"putongyonghu-36"]];
        self.headImage.layer.cornerRadius = WidthRate(25);
        self.headImage.clipsToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
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
        }];
        
        
        self.switchLabel = [[UILabel alloc]init];
        self.switchLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
        self.switchLabel.textColor = ColorWithHexString(SymbolTopColor);
        [self.contentView addSubview:self.switchLabel];
        
        [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(10));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(HeightRate(5));
        }];
        
        self.messageLabel = [[UILabel alloc]init];
        self.messageLabel.textColor = TextColor_666666;
        self.messageLabel.font = [UIFont systemFontOfSize:AdaptFont(14)];
        [self.contentView addSubview:self.messageLabel];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImage.mas_right).offset(WidthRate(10));
            make.top.mas_equalTo(self.switchLabel.mas_bottom).offset(HeightRate(2));
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
        
        
        self.responseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.responseButton setTitle:@"应答" forState:UIControlStateNormal];
        self.responseButton.layer.borderWidth = WidthRate(1);
        self.responseButton.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        self.responseButton.layer.borderColor = ColorWithHexString(APP_THEME_MAIN_COLOR).CGColor;
        self.responseButton.layer.cornerRadius = WidthRate(12.5);
        [self.responseButton setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        [self.responseButton addTarget:self action:@selector(response) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.responseButton];
        
        [self.responseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.bottom.mas_equalTo(HeightRate(-5));
            make.height.mas_equalTo(HeightRate(25));
            make.width.mas_equalTo(WidthRate(70));
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
    
    self.message = model;
    if (!model.isStoreMessage) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.staffAvata] placeholderImage:[UIImage imageNamed:@"hehuoren-36"]];
        if (!model.staffName||model.staffName.length<=0) {
            self.nameLabel.text = [NSString stringWithFormat:@"用户%@",[model.phoneNumber substringFromIndex:model.phoneNumber.length-4]];
        }else{
            self.nameLabel.text = model.staffName;
        }
        self.flagImage.hidden = true;
    }else{
        NSDictionary *dict = [model.group mj_JSONObject];
        YHGroupModel *group = [YHGroupModel mj_objectWithKeyValues:dict];
        SVGKImage *svgImage = [SVGKImage imageNamed:@"dianpuicon_yuan"];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:group.GroupPhoto] placeholderImage:svgImage.UIImage];
        if (!group.GroupName||group.GroupName.length<=0) {
            self.nameLabel.text = model.staffName;
        }else{
            self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",group.GroupName,model.staffName];
        }
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
    NSArray *part = [model.sendTime componentsSeparatedByString:@" "];
    if (part.count == 2) {
         self.timelabel.text = part[0];
    }else{
        self.timelabel.text = model.sendTime;
    }
   
}
- (void)response{
    if (self.responseBlock) {
        self.responseBlock(self.message);
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

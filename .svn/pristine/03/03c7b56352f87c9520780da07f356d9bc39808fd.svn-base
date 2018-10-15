//
//  YHOrderHeaderRevelanceCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/6.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHOrderHeaderRevelanceCell.h"
#import "Header.h"
@interface YHOrderHeaderRevelanceCell()
@end
@implementation YHOrderHeaderRevelanceCell
- (instancetype)init{
    if (self = [super init]) {
        
        SVGKImage *svgImage = [SVGKImage imageNamed:@"dianpuicon_fang"];
        self.storeImage = [[UIImageView alloc] initWithImage:svgImage.UIImage];
        [self.contentView addSubview:self.storeImage];
        
        [self.storeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(10));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(WidthRate(20));
            make.height.mas_equalTo(WidthRate(20));
        }];
        
        
        self.storeName = [[UILabel alloc]init];
        self.storeName.textColor = TextColor_999999;
        self.storeName.font = SYSTEM_FONT(AdaptFont(13));
        [self.contentView addSubview:self.storeName];
        
        [self.storeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeImage.mas_right).offset(WidthRate(7));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.includeTax = [[UILabel alloc]init];
        self.includeTax.textColor = [UIColor whiteColor];
        self.includeTax.text = @"含税";
        self.includeTax.textAlignment = NSTextAlignmentCenter;
        self.includeTax.font = SYSTEM_FONT(AdaptFont(9));
        self.includeTax.backgroundColor = ColorWithHexString(@"FFCC00");
        self.includeTax.layer.cornerRadius = WidthRate(2);
        [self.contentView addSubview:self.includeTax];
        
        [self.includeTax mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.storeName.mas_right).offset(WidthRate(10));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(WidthRate(30));
            make.height.mas_equalTo(HeightRate(17));
        }];
        
        
        
        self.labelTime = [[UILabel alloc]init];
        self.labelTime.textColor = TextColor_999999;
        self.labelTime.font = SYSTEM_FONT(AdaptFont(12));
        [self.contentView addSubview:self.labelTime];
        
        [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];

        self.labelState = [[UILabel alloc]init];
        self.labelState.textColor = ColorWithHexString(SymbolTopColor);
        self.labelState.font = SYSTEM_FONT(AdaptFont(12));
        [self.contentView addSubview:self.labelState];
        
        [self.labelState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.labelTime.mas_left).offset(WidthRate(-5));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
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

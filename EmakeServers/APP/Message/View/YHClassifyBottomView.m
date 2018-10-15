//
//  YHClassifyBottomView.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/6.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHClassifyBottomView.h"
#import "Header.h"
@interface YHClassifyBottomView()

@end
@implementation YHClassifyBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = SepratorLineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0.6);
        }];
        
        
        UIButton *classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [classifyButton setTitle:@"归档" forState:UIControlStateNormal];
        classifyButton.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        [classifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        classifyButton.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        [classifyButton addTarget:self action:@selector(classify) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:classifyButton];
        
        [classifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(0));
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(WidthRate(104));
        }];
        
        
        self.selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectAll setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selectAll.titleLabel.font = SYSTEM_FONT(AdaptFont(12));
        [self.selectAll setImage:[UIImage imageNamed:@"shopping_cart_select_no2x"] forState:UIControlStateNormal];
        [self.selectAll setImage:[UIImage imageNamed:@"shopping_cart_select_yes"] forState:UIControlStateSelected];
        [self.selectAll setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, WidthRate(15))];
        [self addSubview:self.selectAll];
        
        [self.selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(13));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(HeightRate(22));
            make.width.mas_equalTo(WidthRate(70));
        }];
        
    }
    return self;
}
- (void)classify{
    self.clssifyBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

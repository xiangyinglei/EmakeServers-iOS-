//
//  YHSendFileTipsView.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/5/22.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHSendFileTipsView.h"
#import "Header.h"
@interface YHSendFileTipsView()
@property (nonatomic,strong)UIView *maskView;
@end
@implementation YHSendFileTipsView

- (instancetype)initWithDelegete:(id)delegate andUserType:(NSString *)userType andUserName:(NSString *)userName andUserAvata:(NSString *)userAvata andFileName:(NSString *)fileName{
    
    self = [super init];
    if (self) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIColor *color = [UIColor blackColor];
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.3];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = WidthRate(3);
        self.frame = CGRectMake(0, 0, WidthRate(280), HeightRate(156));
        self.center = self.maskView.center;
        self.delegate = delegate;
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont boldSystemFontOfSize:AdaptFont(16)];
        label.text = @"发送给";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HeightRate(15));
            make.left.mas_equalTo(WidthRate(10));
        }];
        
        UIImageView *headImage = [[UIImageView alloc]init];
        headImage.layer.cornerRadius = WidthRate(1);
        if ([userType isEqualToString:@"1"]) {
            [headImage sd_setImageWithURL:[NSURL URLWithString:userAvata] placeholderImage:[UIImage imageNamed:@"hehuoren-36"]];
        }else if ([userType isEqualToString:@"2"]) {
            [headImage sd_setImageWithURL:[NSURL URLWithString:userAvata] placeholderImage:[UIImage imageNamed:@"putongyonghu-36"]];
        }else{
            [headImage sd_setImageWithURL:[NSURL URLWithString:userAvata] placeholderImage:[UIImage imageNamed:@"putongyonghu-36"]];
        }
        [self addSubview:headImage];
        
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(10));
            make.width.mas_equalTo(WidthRate(30));
            make.height.mas_equalTo(WidthRate(30));
            make.top.mas_equalTo(label.mas_bottom).offset(HeightRate(10));
        }];
        
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.font = SYSTEM_FONT(AdaptFont(16));
        namelabel.text = userName;
        [self addSubview:namelabel];
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImage.mas_right).offset(WidthRate(5));
            make.centerY.mas_equalTo(headImage.mas_centerY);
        }];
        
        
        UILabel *fileNameLabel = [[UILabel alloc]init];
        fileNameLabel.font = SYSTEM_FONT(AdaptFont(13));
        fileNameLabel.text = [NSString stringWithFormat:@"[文件] %@",fileName];
        fileNameLabel.textColor = TextColor_666666;
        [self addSubview:fileNameLabel];
        
        [fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headImage.mas_bottom).offset(WidthRate(10));
            make.left.mas_equalTo(WidthRate(10));
        }];
        
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = SepratorLineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fileNameLabel.mas_bottom).offset(WidthRate(10));
            make.left.mas_equalTo(WidthRate(0));
            make.right.mas_equalTo(WidthRate(0));
            make.height.mas_equalTo(HeightRate(0.7));
        }];
        
        
        UILabel *lineH = [[UILabel alloc]init];
        lineH.backgroundColor = SepratorLineColor;
        [self addSubview:lineH];
        
        [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(WidthRate(1));
            make.height.mas_equalTo(HeightRate(45));
        }];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(line.mas_bottom);
            make.width.mas_equalTo(WidthRate(139.5));
            make.height.mas_equalTo(HeightRate(45));
        }];
        
        UIButton *rigthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        [rigthBtn setTitle:@"发送" forState:UIControlStateNormal];
        [rigthBtn addTarget:self action:@selector(rightbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rigthBtn];
        
        [rigthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(line.mas_bottom);
            make.width.mas_equalTo(WidthRate(139.5));
            make.height.mas_equalTo(HeightRate(45));
        }];
        
    }
    return self;
}
- (void)showAnimated{
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [self.maskView addSubview:self];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,CGFLOAT_MIN, CGFLOAT_MIN);
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.transform =
                         CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}
- (void)leftbuttonclick:(UIButton *)btn{
    [self.maskView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertViewLeftBtnClick:)]) {
        [self.delegate alertViewLeftBtnClick:self];
    }
}
- (void)rightbuttonclick:(UIButton *)btn{
    [self.maskView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertViewRightBtnClick:)]) {
        [self.delegate alertViewRightBtnClick:self];
    }
    
}
@end

//
//  YHAlertView.m
//  AlertViewTest
//
//  Created by 谷伟 on 2017/10/9.
//  Copyright © 2017年 谷伟. All rights reserved.
//

#import "YHAlertView.h"
#import "header.h"
@interface YHAlertView()
@property (nonatomic,strong)UIView *maskView;
@end
@implementation YHAlertView

- (instancetype)initWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle{
    self = [super init];
    if (self) {
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.5];
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake(0, 0, WidthRate(270), HeightRate(140));
        
        self.center = self.maskView.center;
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthRate(32), self.bounds.size.width, HeightRate(40))];
        
        label.textColor = TextColor_666666;
        
        label.text = title;
        
        label.numberOfLines = 0;
        
        label.font = SYSTEM_FONT(AdaptFont(16));
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        
        
        UILabel *lineH = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthRate(89), self.bounds.size.width, 0.5)];
        
        lineH.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineH];
        
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        leftBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [leftBtn setTitleColor:TextColor_A8A7A8 forState:UIControlStateNormal];
        
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(leftbuttonclick) forControlEvents:UIControlEventTouchUpInside];
  
        [self addSubview:leftBtn];
        
        UIButton *rigthBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        
        [rigthBtn setTitle:rightTitle forState:UIControlStateNormal];
        
        [rigthBtn addTarget:self action:@selector(rightbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rigthBtn];
        
        UILabel *lineV = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), 0.5, HeightRate(40))];
        
        lineV.backgroundColor = SepratorLineColor;
        [self addSubview:lineV];
        
       
        
    }
    return self;
}
- (instancetype)initWithDelegete:(id)delegate Title:(NSString *)title leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle{
    self = [super init];
    if (self) {
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.5];
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = delegate;
        
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake(0, 0, WidthRate(270), HeightRate(140));
        
        self.center = self.maskView.center;
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthRate(32), self.bounds.size.width, HeightRate(40))];
        
        label.textColor = TextColor_666666;
        
        label.text = title;
        
        label.numberOfLines = 0;
        
        label.font = SYSTEM_FONT(AdaptFont(16));
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        
        
        UILabel *lineH = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthRate(189), self.bounds.size.width, 0.5)];
        
        lineH.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineH];
        
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        leftBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [leftBtn setTitleColor:TextColor_A8A7A8 forState:UIControlStateNormal];
        
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:leftBtn];
        
        
        
        UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        
        [rigthBtn setTitle:rightTitle forState:UIControlStateNormal];
        
        [rigthBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:rigthBtn];
        
        
        UILabel *lineV = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), 1, HeightRate(50))];
        
        lineV.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineV];
        
    
        
        
        
    }
    return self;
}
- (instancetype)initWithDelegete:(id)delegate Title:(NSString *)title cancleButtonTitle:(NSString *)cancleButtonTitle{
    self = [super init];
    if (self) {
        

        
    }
    return self;
}
- (instancetype)initWithDelegete:(id)delegate image:(UIImage *)image Title:(NSString *)title leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightTitle{
    self = [super init];
    if (self) {
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.7];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = delegate;
        
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake(0, 0, WidthRate(270), HeightRate(160));
        
        self.center = self.maskView.center;

        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HeightRate(11));
            make.width.mas_equalTo(WidthRate(45));
            make.height.mas_equalTo(HeightRate(45));
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UILabel *labelTile = [[UILabel alloc]init];
        labelTile.text = title;
        labelTile.font = SYSTEM_FONT(AdaptFont(14));
        labelTile.textAlignment = NSTextAlignmentCenter;
        labelTile.numberOfLines = 0;
        [self addSubview:labelTile];
        
        [labelTile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(26));
            make.right.mas_equalTo(WidthRate(-26));
            make.top.mas_equalTo(HeightRate(61));
            make.height.mas_equalTo(HeightRate(40));
        }];
        
        
        UILabel *lineH = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthRate(89), self.bounds.size.width, 0.5)];
        
        lineH.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineH];
        
        
        [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(0));
            make.right.mas_equalTo(WidthRate(0));
            make.top.mas_equalTo(HeightRate(118));
            make.height.mas_equalTo(HeightRate(0.5 ));
        }];
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        leftBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [leftBtn setTitleColor:TextColor_A8A7A8 forState:UIControlStateNormal];
        
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WidthRate(134.5));
            make.top.mas_equalTo(lineH.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        
        UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), self.bounds.size.width/2, HeightRate(50))];
        
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        
        [rigthBtn setTitle:rightTitle forState:UIControlStateNormal];
        
        [rigthBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:rigthBtn];
        
        [rigthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(0));
            make.width.mas_equalTo(WidthRate(134.5));
            make.top.mas_equalTo(lineH.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        
        UILabel *lineV = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, WidthRate(90), 0.5, HeightRate(40))];
        lineV.backgroundColor = SepratorLineColor;
        [self addSubview:lineV];
        
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HeightRate(43));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(1);
            make.bottom.mas_equalTo(HeightRate(0));
        }];
        
    }
    return self;
}
//强制更新内容
- (instancetype)initWithTitle:(NSString *)title AndUpdateNecessaryText:(NSString *)text{
    
    self = [super init];
    if (self) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.5];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake(0, 0, WidthRate(270), HeightRate(200));
        
        self.center = self.maskView.center;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(10), self.bounds.size.width, HeightRate(40))];
        
        NSString *titleName =[NSString stringWithFormat:@"易智造%@",title];
        
        label.text = titleName;
        
        label.numberOfLines = 0;
        
        label.font = [UIFont boldSystemFontOfSize:18];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        UILabel *lineH = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(50), self.bounds.size.width, 0.5)];
        
        lineH.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineH];
        
        
        UITextView *labelText = [[UITextView alloc]initWithFrame:CGRectMake(WidthRate(15), HeightRate(51), self.bounds.size.width-WidthRate(30), HeightRate(90))];
        
        labelText.userInteractionEnabled = false;
        
        NSString *updateText = [NSString stringWithFormat:@"更新说明：\n%@",text];
        
        labelText.text = updateText;
        
        labelText.font = SYSTEM_FONT(AdaptFont(16));
        
        
        [self addSubview:labelText];
        
        UILabel *lineHA = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(145), self.bounds.size.width, 0.5)];
        
        lineHA.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineHA];
        
        UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, HeightRate(146), self.bounds.size.width, HeightRate(50))];
        
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(16));
        
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        
        [rigthBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        
        [rigthBtn addTarget:self action:@selector(rightbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:rigthBtn];
        
    }
    return self;
}
//非强制更新
- (instancetype)initWithTitle:(NSString *)title AndUpdateUnNecessaryText:(NSString *)text{
    self = [super init];
    if (self) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.5];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 5;
        
        self.frame = CGRectMake(0, 0, WidthRate(270), HeightRate(200));
        
        self.center = self.maskView.center;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(10), self.bounds.size.width, HeightRate(40))];
        
        NSString *titleName =[NSString stringWithFormat:@"易智造%@",title];
        
        label.text = titleName;
        
        label.numberOfLines = 0;
        
        label.font = [UIFont boldSystemFontOfSize:18];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        UILabel *lineH = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(50), self.bounds.size.width, 0.5)];
        
        lineH.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineH];
        
        
        UITextView *labelText = [[UITextView alloc]initWithFrame:CGRectMake(WidthRate(15), HeightRate(51), self.bounds.size.width-WidthRate(30), HeightRate(90))];
        
        labelText.userInteractionEnabled = false;
        
        NSString *updateText = [NSString stringWithFormat:@"更新说明：\n%@",text];
        
        labelText.text = updateText;
        
        labelText.font = SYSTEM_FONT(AdaptFont(16));
        
        
        [self addSubview:labelText];
        
        UILabel *lineHA = [[UILabel alloc]initWithFrame:CGRectMake(0, HeightRate(145), self.bounds.size.width, 0.5)];
        
        lineHA.backgroundColor = SepratorLineColor;
        
        [self addSubview:lineHA];
        
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, HeightRate(146), self.bounds.size.width/2, HeightRate(50))];
        
        leftBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(14));
        
        [leftBtn setTitleColor:TextColor_A8A7A8 forState:UIControlStateNormal];
        
        [leftBtn setTitle:@"暂不更新" forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(leftbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:leftBtn];
        
        UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, HeightRate(146), self.bounds.size.width/2, HeightRate(50))];
        
        rigthBtn.titleLabel.font = SYSTEM_FONT(AdaptFont(16));
        
        [rigthBtn setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        
        [rigthBtn setTitle:@"立即更新" forState:UIControlStateNormal];
        
        [rigthBtn addTarget:self action:@selector(rightbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:rigthBtn];
        
        UILabel *lineV = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, HeightRate(146), 0.5, HeightRate(50))];
        lineV.backgroundColor = SepratorLineColor;
        [self addSubview:lineV];
        
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
- (void)right:(UIButton *)btn{
    [self.maskView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertViewRightBtnClick:)]) {
        [self.delegate alertViewRightBtnClick:self];
    }
    
}

-(void)leftbuttonclick
{
    [self.maskView removeFromSuperview];
    
}
-(void)rightbuttonclick
{
    [self.maskView removeFromSuperview];

    self.rightBlock(@"确定");
}
- (void)left:(UIButton *)btn{
    [self.maskView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(alertViewLeftBtnClick:)]) {
        [self.delegate alertViewLeftBtnClick:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

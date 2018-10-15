//
//  YHMissonCreatSuccessView.m
//  emake
//
//  Created by 谷伟 on 2018/1/7.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "YHMissonCreatSuccessView.h"
#import "Header.h"
@interface YHMissonCreatSuccessView()
@property (nonatomic,strong)UIView *maskView;
@end
@implementation YHMissonCreatSuccessView
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

- (instancetype)initDisbandView{
    if (self = [super init]) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIColor *color = [UIColor blackColor];
        
        self.maskView.backgroundColor = [color colorWithAlphaComponent:0.5];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 3;
        
        self.frame = CGRectMake(0, 0, WidthRate(300), HeightRate(206));
        
        self.center = self.maskView.center;
        
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        topView.layer.cornerRadius = 3;
        [self addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(HeightRate(58));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = SYSTEM_FONT(AdaptFont(17));
        NSString *inviteText = @"结束咨询";
        titleLabel.text = inviteText;
        [topView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(topView.mas_centerX);
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.height.mas_equalTo(HeightRate(28));
        }];
        
        UILabel *missonLabel = [[UILabel alloc]init];
        missonLabel.textColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        missonLabel.numberOfLines = 2;
        missonLabel.font = SYSTEM_FONT(AdaptFont(16));
        missonLabel.text = @"结束咨询，需要您重新应答此用户的咨询要求";
        [topView addSubview:missonLabel];
        
        [missonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(topView.mas_centerX);
            make.top.mas_equalTo(topView.mas_bottom).offset(HeightRate(16));
            make.width.mas_equalTo(WidthRate(247));
            make.height.mas_equalTo(HeightRate(54));
        }];
        
        UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        cancle.backgroundColor = ColorWithHexString(APP_THEME_MAIN_COLOR);
        [cancle setTitle:@"确定" forState:UIControlStateNormal];
        [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
        cancle.layer.cornerRadius = 3;
        [self addSubview:cancle];
        
        [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthRate(30));
            make.top.mas_equalTo(missonLabel.mas_bottom).offset(HeightRate(14));
            make.width.mas_equalTo(WidthRate(115));
            make.height.mas_equalTo(WidthRate(36));
        }];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:@"取消" forState:UIControlStateNormal];
        [confirm setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        [confirm addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        confirm.layer.cornerRadius = 3;
        confirm.layer.borderColor = ColorWithHexString(APP_THEME_MAIN_COLOR).CGColor;
        confirm.layer.borderWidth = 1;
        [self addSubview:confirm];
        
        [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(WidthRate(-30));
            make.top.mas_equalTo(missonLabel.mas_bottom).offset(HeightRate(14));
            make.width.mas_equalTo(WidthRate(115));
            make.height.mas_equalTo(WidthRate(36));
        }];
    }
    return self;
}

- (void)disappear{
    if (self.block) {
        self.block(@"");
    }
    [self.maskView removeFromSuperview];
}
- (void)thinkSB{
    if (self.block) {
        self.block(@"thinkAgain");
    }
    [self.maskView removeFromSuperview];
}
- (void)remove{
    
    [self.maskView removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

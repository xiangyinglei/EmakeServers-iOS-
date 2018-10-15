//
//  YHUserHeaderCell.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YHUserHeaderCell.h"
#import "Header.h"
@interface YHUserHeaderCell()

@end
@implementation YHUserHeaderCell
- (instancetype)init{
    if (self = [super init]) {
        self.viewOne = [self headerViewWithImageName:@"suoyouyonghu" titleName:@"所有用户"];
        [self.contentView addSubview:self.viewOne];
        
        [self.viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth/2);
        }];
        
        
        self.viewTwo = [self headerViewWithImageName:@"dailishang" titleName:@"城市代理商"];
        [self.contentView addSubview:self.viewTwo];
        
        [self.viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth/2);
        }];
    }
    return self;
}
- (UIView *)headerViewWithImageName:(NSString *)imageName titleName:(NSString *)title{
    
    UIView *view = [[UIView alloc]init];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    image.tag = 100;
    [view addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(HeightRate(20));
        make.width.mas_equalTo(WidthRate(76));
        make.height.mas_equalTo(WidthRate(76));
    }];
    
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.text = title;
    labelTitle.tag = 101;
    labelTitle.font = [UIFont systemFontOfSize:AdaptFont(15)];
    [view addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(image.mas_bottom).offset(HeightRate(15));
        make.height.mas_equalTo(HeightRate(17));
    }];

    UILabel *labelCount = [[UILabel alloc]init];
    labelCount.tag = 102;
    labelCount.textColor = TextColor_999999;
    labelCount.font = [UIFont systemFontOfSize:AdaptFont(15)];
    [view addSubview:labelCount];
    [labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(HeightRate(6));
        make.height.mas_equalTo(HeightRate(14));
    }];
    return view;
}
- (void)updateCellConstraints{
    
    [self.viewOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    UILabel *labelTitleOne = [self.viewOne viewWithTag:101];
    labelTitleOne.text = @"所有用户";
    
    
    [self.viewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ScreenWidth/3);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    UIImageView *viewImage = [self.viewTwo viewWithTag:100];
    viewImage.image = [UIImage imageNamed:@"dailishang"];
    UILabel *labelTitleTwo = [self.viewTwo viewWithTag:101];
    labelTitleTwo.text = @"城市代理商";

    
    self.viewThree = [self headerViewWithImageName:@"daishenhedailishang" titleName:@"待审核城市代理商"];
    [self.contentView addSubview:self.viewThree];
    [self.viewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
}
- (void)setData:(NSDictionary *)userDic{
    NSNumber *AllUserNum = userDic[@"AllUserNum"];
    NSNumber *AgentUserNum = userDic[@"AgentUserNum"];
    NSNumber *AgentAuditNum = userDic[@"AgentAuditNum"];
    UILabel *labelCountOne = [self.viewOne viewWithTag:102];
    labelCountOne.text = [NSString stringWithFormat:@"%@",AllUserNum.integerValue?userDic[@"AllUserNum"]:@"0"];
    UILabel *labelCountTwo = [self.viewTwo viewWithTag:102];
    labelCountTwo.text = [NSString stringWithFormat:@"%@",AgentUserNum.integerValue?userDic[@"AgentUserNum"]:@"0"];
    UILabel *labelCountThree = [self.viewThree viewWithTag:102];
    labelCountThree.text = [NSString stringWithFormat:@"%@",AgentAuditNum.integerValue?userDic[@"AgentAuditNum"]:@"0"];
    
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
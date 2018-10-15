//
//  YHUserHeaderCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHUserHeaderCell : UITableViewCell
@property (nonatomic,retain)UIView *viewOne;
@property (nonatomic,retain)UIView *viewTwo;
@property (nonatomic,retain)UIView *viewThree;
- (void)updateCellConstraints;
- (void)setData:(NSDictionary *)userDic;
@end

//
//  YHRevelanceOrderContentCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/6.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHItemModel.h"
typedef void (^RevelanceBlock)(NSString *success);
@interface YHRevelanceOrderContentCell : UITableViewCell
@property (nonatomic,copy)RevelanceBlock revelanceBlock;
@property (nonatomic,strong)UIButton *revelanceButton;
- (void)setData:(YHItemModel *)goods;
@end
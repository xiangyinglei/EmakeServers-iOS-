//
//  YHMessageListResponseCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/2.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDChatMessage.h"
typedef  void(^ResponseBlock)(SDChatMessage *msg);
@interface YHMessageListResponseCell : UITableViewCell
- (void)setData:(SDChatMessage *)model;
@property (nonatomic,copy)ResponseBlock responseBlock;
@property (nonatomic,strong)UILabel *switchLabel;
@end

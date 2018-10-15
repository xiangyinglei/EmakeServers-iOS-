//
//  YHFileSendMessageListTableViewCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/5/23.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDChatMessage.h"
@interface YHFileSendMessageListTableViewCell : UITableViewCell
- (void)setData:(SDChatMessage *)model;
@end

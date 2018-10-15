//
//  YHMessageListTableViewCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDChatMessage.h"
#import "WSIconView.h"
@interface YHMessageListTableViewCell : UITableViewCell
@property (nonatomic,retain)UIImageView *headImage;
@property (nonatomic,retain)UIImageView *flagImage;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *messageLabel;
@property (nonatomic,retain)UILabel *timelabel;
@property (nonatomic,retain)UILabel *messageCountLabel;
- (void)setData:(SDChatMessage *)model;
@end

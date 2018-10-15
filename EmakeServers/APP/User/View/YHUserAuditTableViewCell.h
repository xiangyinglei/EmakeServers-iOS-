//
//  YHUserAuditTableViewCell.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHUserModel.h"
@interface YHUserAuditTableViewCell : UITableViewCell
@property (nonatomic,retain)UIButton *sendMessageBtn;
- (void)setData:(YHUserModel *)model;
@end

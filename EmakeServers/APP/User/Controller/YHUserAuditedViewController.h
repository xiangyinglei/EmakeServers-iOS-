//
//  YHUserAuditedViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/2/1.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"
#import "YHUserModel.h"
@interface YHUserAuditedViewController : BaseViewController
@property (nonatomic,retain)YHUserModel *model;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *creatTime;
@end
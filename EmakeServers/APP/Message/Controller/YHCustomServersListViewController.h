//
//  YHCustomServersListViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/5.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SelectServers)(NSString *serverID);
@interface YHCustomServersListViewController : BaseViewController
@property (nonatomic,strong)NSArray *serversArray;
@property (nonatomic,copy)SelectServers selectServers;
@end

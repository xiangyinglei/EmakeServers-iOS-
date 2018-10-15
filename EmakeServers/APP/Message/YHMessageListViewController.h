//
//  YHMessageListViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"

@interface YHMessageListViewController : BaseViewController
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *responseArray;
@property (nonatomic,strong)NSMutableArray *chatListArray;
@end

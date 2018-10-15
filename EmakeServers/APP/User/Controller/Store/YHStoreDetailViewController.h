//
//  YHStoreDetailViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/7/16.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"
#import "YHStoreModel.h"
@interface YHStoreDetailViewController : BaseViewController
@property (nonatomic,assign)BOOL isAudit;
@property (nonatomic,copy)NSString *StoreId;
@property (nonatomic,copy)NSString *storeUserId;
@property (nonatomic,retain)YHStoreModel *model;
@property (nonatomic,copy)NSString *storeState;
@end

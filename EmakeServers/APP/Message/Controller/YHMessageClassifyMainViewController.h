//
//  YHMessageClassifyMainViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/6/5.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"

@interface YHMessageClassifyMainViewController : BaseViewController
@property (nonatomic,strong)NSMutableArray *messageArray;
//普通用户信息
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *userType;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userAvata;
@property (nonatomic,copy)NSString *userPhoneNumber;

//店铺信息
@property (nonatomic,copy)NSString *storeUserId;
@property (nonatomic,copy)NSString *storeId;
@property (nonatomic,copy)NSString *storePhoto;
@property (nonatomic,copy)NSString *storeName;
@property (nonatomic,copy)NSString *storePhoneNumber;

@property (nonatomic,assign)BOOL isFormStore;
@property (nonatomic,assign)BOOL isLookUp;
@property (nonatomic,assign)BOOL isFromUserInfo;

@property (nonatomic,copy)NSString *listId;
@end

//
//  MQTTCommandModel.h
//  emake
//
//  Created by 谷伟 on 2018/6/20.
//  Copyright © 2018年 emake. All rights reserved.
//

#import <Foundation/Foundation.h>

//CMD指令集

@interface MQTTCommandModel : NSObject
@property (nonatomic,copy)NSString *cmd;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,assign)NSInteger message_id_last;
@property (nonatomic,copy)NSString *customer_id;
@property (nonatomic,strong)NSArray *customer_ids;
@property (nonatomic,copy)NSString *message_last;
@property (nonatomic,copy)NSString *user_info;
@property (nonatomic,copy)NSString *chatroom_id;
//请求聊天记录
- (instancetype)creatMessageListCMD:(NSString *)userId andStoreId:(NSString *)storeID lastMessageId:(NSInteger)messageId;

//转接客服列表获取
- (instancetype)creatCustomerLisCMDWithstoreID:(NSString *)storeId andUserId:(NSString *)userId;

//客服转接
- (instancetype)creatRequestSwitchServiceCMD:(NSString *)userId andStoreId:(NSString *)storeId withCustomerServersId:(NSString *)serverId andUserInfo:(NSString *)userInfo;
@end

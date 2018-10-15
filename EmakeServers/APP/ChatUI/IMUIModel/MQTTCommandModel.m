//
//  MQTTCommandModel.m
//  emake
//
//  Created by 谷伟 on 2018/6/20.
//  Copyright © 2018年 emake. All rights reserved.
//

#import "MQTTCommandModel.h"

@implementation MQTTCommandModel
//请求聊天记录
- (instancetype)creatMessageListCMD:(NSString *)userId andStoreId:(NSString *)storeID lastMessageId:(NSInteger)messageId{
    self.cmd = @"MessageList";
    self.user_id = userId;
    self.message_id_last = messageId;
    if (storeID != nil) {
        self.chatroom_id = [NSString stringWithFormat:@"%@/%@",storeID,userId];
    }else{
        self.chatroom_id = [NSString stringWithFormat:@"%@",userId];
    }
    return self;
}
//转接客服列表获取
- (instancetype)creatCustomerLisCMDWithstoreID:(NSString *)storeId andUserId:(NSString *)userId{
    self.cmd = @"CustomerList";
    self.user_id = @"";
    self.message_id_last = 0;
    self.customer_id = @"";
    if (storeId != nil) {
        self.chatroom_id = [NSString stringWithFormat:@"%@/%@",storeId,userId];
    }else{
        self.chatroom_id = [NSString stringWithFormat:@"%@",userId];
    }
    return self;
}
//客服转接
- (instancetype)creatRequestSwitchServiceCMD:(NSString *)userId andStoreId:(NSString *)storeId withCustomerServersId:(NSString *)serverId andUserInfo:(NSString *)userInfo{
    self.cmd = @"RequestSwitchService";
    self.user_id = userId;
    self.customer_id = serverId;
    self.message_id_last = 0;
    self.user_info = userInfo;
    if (storeId != nil) {
        self.chatroom_id = [NSString stringWithFormat:@"%@/%@",storeId,userId];
    }else{
        self.chatroom_id = [NSString stringWithFormat:@"%@",userId];
    }
    return self;
}

@end

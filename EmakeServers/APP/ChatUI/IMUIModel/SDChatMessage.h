//
//  SDChatMessage.h
//  SDChat
//
//  Created by Megatron Joker on 2017/5/19.
//  Copyright © 2017年 SlowDony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDChatMessage : NSObject

/**
 消息
 */
@property (nonatomic,strong)NSString *msg;

/**
 消息id
 */
@property (nonatomic,strong)NSString *msgID;

/**
 消息类型
 */
@property (nonatomic,copy)NSString* msgType;

/**
 发送时间
 */
@property (nonatomic,strong)NSString *sendTime;

/**
  0顾客/1客服
 */
@property (nonatomic,copy)NSString *sender;


/**
 用户名字
 */
@property (nonatomic,strong)NSString *staffName;

/**
 用户id
 */
@property (nonatomic,strong)NSString *staffID;
/**
 用户头像
 */
@property (nonatomic,strong)NSString *staffAvata;

/**
 用户类型
 */
@property (nonatomic,strong)NSString *staffType;
/**
 消息个数
 */
@property (nonatomic,strong)NSString *messageCount;
/**
 用户userID
 */
@property (nonatomic,strong)NSString *userId;
/**
 用户手机号
 */
@property (nonatomic,strong)NSString *phoneNumber;

/**
 是否为转接应答消息
 */
@property (nonatomic,copy)NSString *switchCustomerServers;

/**
 是否为店铺消息
 */
@property (nonatomic,assign)BOOL isStoreMessage;
/**
 组织信息
 */
@property (nonatomic,copy)NSString *group;

/**
 clientID
 */
@property (nonatomic,copy)NSString *clientID;

/**
 UUID
 */
@property (nonatomic,copy)NSString *messgaeUUID;

-(instancetype)initWithChatMessageDic:(NSDictionary *)dic;
+(instancetype)chatMessageWithDic:(NSDictionary *)dic;
@end

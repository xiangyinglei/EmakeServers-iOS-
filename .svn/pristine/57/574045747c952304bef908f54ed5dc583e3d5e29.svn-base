//
//  YHMQTTClient.h
//  MQTTClientManager
//
//  Created by 谷伟 on 2017/9/30.
//  Copyright © 2017年 谷伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import "YHMQTTClientDelegate.h"

typedef void(^MQTTMessageBlock)(MQTTMessage *);

@interface YHMQTTClient : NSObject

//单利属性
@property (nonatomic,strong)MQTTCFSocketTransport *transport;

@property (nonatomic,strong)MQTTSession *session;


@property(nonatomic, weak)UIViewController<YHMQTTClientDelegate>* delegate;//代理
//消息个数
@property(nonatomic, assign)NSInteger MessageCount;
//事件个数
@property(nonatomic, assign)NSInteger EventCount;
// 单例
+ (YHMQTTClient *)sharedClient;

//连接
-(void)connectToHost:(NSString *)host Port:(NSInteger)port subcriceCMDTopic:(NSString *)cmdTopic withServerId:(NSString *)serverId;

//发送消息
- (void)sendMessage:(NSDictionary *)data withTopic:(NSString *)Topic complete:(void(^)(NSError *error))completeBlock;

//发送指令
- (void)sendCommmand:(NSDictionary *)command withSelfTopic:(NSString *)selfTopic complete:(void(^)(NSError *error))completeBlock;

//订阅客户主题
- (void)subcriceMessageTopic:(NSString *)messageTopic;

//断开连接
- (void)disConnect;

//取消订阅
- (void)unSubcriceMessageTopic:(NSString *)messageTopic;


- (BOOL)isMQTTConnect;
@end




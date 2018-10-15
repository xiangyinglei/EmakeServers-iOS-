//
//  SDChatMessage.m
//  SDChat
//
//  Created by Megatron Joker on 2017/5/19.
//  Copyright © 2017年 SlowDony. All rights reserved.
//

#import "SDChatMessage.h"

@implementation SDChatMessage

-(instancetype)initWithChatMessageDic:(NSDictionary *)dic{
    self =[super init];
    if (self){
        self.msg=dic[@"msg"]; //消息
        self.msgID=dic[@"msgID"]; //消息id
        self.messgaeUUID =dic[@"messgaeUUID"]; //用户类型
        self.sender=dic[@"sender"]; //
        self.sendTime=dic[@"sendTime"];
        self.msgType=dic[@"msgType"] ; //消息类型
        self.staffName =dic[@"staffName"];  //用户名字
        self.staffID =dic[@"staffID"]; //用户id
        self.staffAvata =dic[@"staffAvata"]; //用户头像
        self.staffType =dic[@"staffType"]; //用户类型
        self.phoneNumber =dic[@"phoneNumber"]; //用户手机号
        self.group =dic[@"group"]; //用户类型
    }
    return self;
}
+(instancetype)chatMessageWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithChatMessageDic:dic];
}
@end

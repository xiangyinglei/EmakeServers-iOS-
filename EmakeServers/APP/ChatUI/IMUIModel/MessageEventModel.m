//
//  MessageEventModel.m
//  sampleObjectC
//
//  Created by oshumini on 2017/6/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "MessageEventModel.h"

@interface MessageEventModel ()
@end

@implementation MessageEventModel

- (instancetype _Nonnull )initWithMsgId:(NSString *_Nonnull)msgId eventText:(NSString *_Nonnull)eventText sendTime:(NSString *)sendTime
{
  self = [super init];
  if (self) {
    _msgId = msgId;
    _evenText = eventText;
      _sendTime = sendTime;
  }
  return self;
}


@end

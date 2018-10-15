//
//  UserModel.h
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmakeServers-Swift.h"
#import <UIKit/UIKit.h>

@interface UserModel : NSObject <IMUIUserProtocol>
@property (nonatomic,assign)BOOL isOutgoing;
@property (nonatomic,copy)NSString * _Nullable serversAvata;
@property (nonatomic,copy)NSString * _Nullable displayUserName;
@property (nonatomic,copy)NSString * _Nullable phoneNumber;
@property (nonatomic,copy)NSString * _Nullable clientId;
- (NSString * _Nonnull)userId SWIFT_WARN_UNUSED_RESULT;

- (NSString * _Nonnull)displayName SWIFT_WARN_UNUSED_RESULT;

- (NSString * _Nonnull)Avatar SWIFT_WARN_UNUSED_RESULT;

- (NSString * _Nonnull)ClientID SWIFT_WARN_UNUSED_RESULT;
@end

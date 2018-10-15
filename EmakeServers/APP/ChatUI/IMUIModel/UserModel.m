//
//  UserModel.m
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "UserModel.h"
#import "Header.h"
@implementation UserModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (NSString * _Nonnull)userId SWIFT_WARN_UNUSED_RESULT {
  return @"";
}

- (NSString * _Nonnull)displayName SWIFT_WARN_UNUSED_RESULT {
    if(self.isOutgoing){
        
        return @"";
    }else{
        if(self.phoneNumber.length<=0){
            return  self.displayUserName;
        }
        return [NSString stringWithFormat:@"%@ %@",self.displayUserName,self.phoneNumber];
    }
}

- (NSString * _Nonnull)Avatar SWIFT_WARN_UNUSED_RESULT {

    if(self.isOutgoing){
        UIImage *image = nil;
        NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_USERID];
        NSString *fileName = [NSString stringWithFormat:@"%@user_icon",userId];
        if ([NSData dataWithContentsOfFile:[Tools getPath:fileName]]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[Tools getPath:fileName]]];
            return [Tools getPath:fileName];
        }else{
            return @"kefu_logo";
        }
        
    }else{
        if(self.serversAvata.length>0){
            return self.serversAvata;
        }else{
            return @"kefu_logo";
        }
    }
}
- (NSString * _Nonnull)ClientID SWIFT_WARN_UNUSED_RESULT {
    
    return self.clientId;
}
@end

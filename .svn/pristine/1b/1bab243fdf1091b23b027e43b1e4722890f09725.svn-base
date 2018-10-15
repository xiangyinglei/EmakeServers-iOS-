//
//  chatUserModel.m
//  emake
//
//  Created by 谷伟 on 2017/9/18.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "chatUserModel.h"
#import "Header.h"
@implementation chatUserModel
- (instancetype)initWith:(NSString *)avatar formId:(NSString *)formId displayName:(NSString *)displayName clientID:(NSString *)clientID{
    
    self.Avatar = avatar;
    self.UserId = formId;
    self.DisplayName = displayName;
    self.ClientID = clientID;
    self.Group = @"";
    return self;
}
- (instancetype)getServersUserInfoMyself{
    
    self.Avatar = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_HeadImageUrl];
    self.UserId = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_USERID];
    self.DisplayName = [NSString stringWithFormat:@"客服%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ServiceID]];
    self.ClientID = [NSString stringWithFormat:@"customer/%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ServiceID]];
    self.PhoneNumber = [NSString stringWithFormat:@"customer/%@",[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_MOBILEPHONE]];
    return self;
}
@end

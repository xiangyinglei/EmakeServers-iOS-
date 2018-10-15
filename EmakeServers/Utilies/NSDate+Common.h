//
//  NSDate+Common.h
//  emake
//
//  Created by 袁方 on 2017/7/21.
//  Copyright © 2017年 emake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

/**
 * NSString --> NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateStr;

/**
 * 获取当前时间
 */
+(NSString *)getCurrentTime;
/**
 * 获取时间差并与有效时间做对比 返回YES代表有效，反之无效
 */
+(BOOL)isValideTimeDifferenceWithLastLoginTime:(NSString *)lastLoginTime currentLoginTime:(NSString *)currentLoginTime ValidTime:(NSString *)validTime;
//上次发消息的时间
+(BOOL)isValideTimeDifferenceWithTime:(NSString *)lastTime currentTime:(NSString *)currentTime ValidTime:(NSString *)validTime andValidTimeInterval:(NSInteger)interval;
//年月日 时分秒 转 成 时分
@end
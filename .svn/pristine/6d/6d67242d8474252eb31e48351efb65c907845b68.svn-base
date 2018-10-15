//
//  NSDate+Common.m
//  emake
//
//  Created by 袁方 on 2017/7/21.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

+ (NSDate *)dateFromString:(NSString *)dateStr {
    NSString *day = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d$"];
    NSString *hour = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d$"];
    NSString *minute = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d$"];
    NSString *second = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d$"];
    NSString *millisecond = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d.\\d\\d\\d$"];
    NSString *supermillisecond = [NSString stringWithFormat:@"^\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d.\\d\\d\\d\\d\\d\\d$"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", day] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd";
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", hour] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd HH";
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", minute] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", second] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", millisecond] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", supermillisecond] evaluateWithObject:dateStr]) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
    } else {
        return nil;
    }
    
    return [formatter dateFromString:dateStr];
}

//获得当前时间
+(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
+(BOOL)isValideTimeDifferenceWithTime:(NSString *)lastTime currentTime:(NSString *)currentTime ValidTime:(NSString *)validTime andValidTimeInterval:(NSInteger)interval{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:lastTime];
    NSDate *endD = [date dateFromString:currentTime];
    NSTimeInterval last = [startD timeIntervalSince1970]*1;
    NSTimeInterval current = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = current - last;
    if (value > interval*60) {
        return YES;
    }
    else
        return NO;
}
+(BOOL)isValideTimeDifferenceWithLastLoginTime:(NSString *)lastLoginTime currentLoginTime:(NSString *)currentLoginTime ValidTime:(NSString *)validTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:lastLoginTime];
    NSDate *endD = [date dateFromString:currentLoginTime];
    NSTimeInterval last = [startD timeIntervalSince1970]*1;
    NSTimeInterval current = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = current - last;
    //    int second = (int)value %60;//秒
    //    int minute = (int)value /60%60;
    //    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    
    if (day < 30 ) {
        return YES;
    }
    else return NO;
}


@end

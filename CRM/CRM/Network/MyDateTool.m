//
//  MyDateTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyDateTool.h"

@implementation MyDateTool

+ (NSString *)stringWithDateWithSec:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithDateNoSec:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateWithStringWithSec:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:dateStr];
}

+ (NSDate *)dateWithStringNoSec:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:dateStr];
}


+ (BOOL)timeInStartTime:(NSString *)startTime endTime:(NSString *)endTime targetTime:(NSString *)targetTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    //获取时间
    NSDate *start = [formatter dateFromString:startTime];
    NSDate *end = [formatter dateFromString:endTime];
    NSDate *target = [formatter dateFromString:targetTime];
    //获取当前时间的跨度
    NSTimeInterval startInt = [start timeIntervalSinceNow];
    NSTimeInterval endInt = [end timeIntervalSinceNow];
    NSTimeInterval targetInt = [target timeIntervalSinceNow];
    
    if (targetInt > startInt  && targetInt < endInt) {
        return YES;
    }else{
        return NO;
    }
}

@end

//
//  MyDateTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDateTool : NSObject

+ (NSString *)stringWithDateWithSec:(NSDate *)date;

+ (NSString *)stringWithDateNoSec:(NSDate *)date;

+ (NSDate *)dateWithStringWithSec:(NSString *)dateStr;

+ (NSDate *)dateWithStringNoSec:(NSString *)dateStr;

+ (NSDate *)dateWithStringNoTime:(NSString *)dateStr;

+ (NSString *)stringWithDateNoTime:(NSDate *)date;

+ (NSString *)stringWithDateyyyyMMddHHmmss:(NSDate *)date;

+ (NSDate *)getMondayDateWithCurrentDate:(NSDate *)date;
+ (NSDate *)getSundayDateWithCurrentDate:(NSDate *)date;
+ (NSString *)getDayWeek:(int)dayDelay;

//比较目标时间是否在一个时间段内
+ (BOOL)timeInStartTime:(NSString *)startTime endTime:(NSString *)endTime targetTime:(NSString *)targetTime;
//比较两个日期的大小
+ (NSComparisonResult)compareWithFromDateStr:(NSString *)fromDateStr;

+ (BOOL)earlyThanToday:(NSString *)targetDateStr;

+ (NSString *)getMonthEndWith:(NSString *)dateStr;
+ (NSString *)getMonthBeginWith:(NSDate *)date;

+ (NSUInteger)getMonthDayCountWithDate:(NSString *)dateStr;

@end

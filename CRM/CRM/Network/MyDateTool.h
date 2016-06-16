//
//  MyDateTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDateTool : NSObject

+ (NSString *)stringWithDateFormatterStr:(NSString *)formatterStr dateStr:(NSString *)dateStr;

+ (NSString *)stringWithDateWithSec:(NSDate *)date;

+ (NSString *)stringWithDateNoSec:(NSDate *)date;

+ (NSDate *)dateWithStringWithSec:(NSString *)dateStr;

+ (NSDate *)dateWithStringNoSec:(NSString *)dateStr;

+ (NSDate *)dateWithStringNoTime:(NSString *)dateStr;

+ (NSString *)stringWithDateNoTime:(NSDate *)date;

+ (NSString *)stringWithDateyyyyMMddHHmmss:(NSDate *)date;


//获取当前选择的星期 星期一和星期日的日期
+ (NSDate *)getMondayDateWithCurrentDate:(NSDate *)date;
//获取当前选择的星期 星期一和星期日的日期
+ (NSDate *)getSundayDateWithCurrentDate:(NSDate *)date;
//获取当前时间是周几，返回星期一-星期天
+ (NSString *)getDayWeek:(int)dayDelay;
//获取当前时间是周几，返回1-7
+ (int)getDayIntWeekWithDate:(NSDate *)date;

//比较目标时间是否在一个时间段内
+ (BOOL)timeInStartTime:(NSString *)startTime endTime:(NSString *)endTime targetTime:(NSString *)targetTime;
//比较输入日期与当前日期的大小
+ (NSComparisonResult)compareWithFromDateStr:(NSString *)fromDateStr;
//比较两个输入的日期的大小，格式为yyyy-MM-dd
+ (NSComparisonResult)compareStartDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr;
//判断当前时间是否早于目标时间
+ (BOOL)earlyThanToday:(NSString *)targetDateStr;
//判断当前时间是否晚于目标时间
+ (BOOL)lateThanToday:(NSString *)targetDateStr;
//根据所给时间得到当月的最后一天
+ (NSString *)getMonthEndWith:(NSString *)dateStr;
//根据所给时间获取当月的第一天
+ (NSString *)getMonthBeginWith:(NSDate *)date;
//根据所给时间计算当月的天数
+ (NSUInteger)getMonthDayCountWithDate:(NSString *)dateStr;

@end

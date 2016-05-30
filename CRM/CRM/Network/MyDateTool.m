//
//  MyDateTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyDateTool.h"

@implementation MyDateTool

+ (NSString *)stringWithDateFormatterStr:(NSString *)formatterStr dateStr:(NSString *)dateStr{
    NSDate *dateTmp = [self dateWithStringWithSec:dateStr];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    return [formatter stringFromDate:dateTmp];
}

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

+ (NSDate *)dateWithStringNoTime:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:dateStr];
}

+ (NSString *)stringWithDateNoTime:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithDateyyyyMMddHHmmss:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    return [formatter stringFromDate:date];
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



//获取当前选择的星期星期一和星期日的日期
+ (NSDate *)getMondayDateWithCurrentDate:(NSDate *)date{
    NSString *weekDay = [self getDayWeek:0];
    NSTimeInterval oneDay = 24*60*60*1;  //1天的长度
    if ([weekDay isEqualToString:@"星期一"]) {
        return date;
    }else if ([weekDay isEqualToString:@"星期二"]){
        return [date dateByAddingTimeInterval:-oneDay];
    }else if ([weekDay isEqualToString:@"星期三"]){
        return [date dateByAddingTimeInterval:-oneDay * 2];
    }else if ([weekDay isEqualToString:@"星期四"]){
        return [date dateByAddingTimeInterval:-oneDay * 3];
    }else if ([weekDay isEqualToString:@"星期五"]){
        return [date dateByAddingTimeInterval:-oneDay * 4];
    }else if ([weekDay isEqualToString:@"星期六"]){
        return [date dateByAddingTimeInterval:-oneDay * 5];
    }else{
        return [date dateByAddingTimeInterval:-oneDay * 6];
    }
}
//获取当前选择的星期星期一和星期日的日期
+ (NSDate *)getSundayDateWithCurrentDate:(NSDate *)date{
    NSString *weekDay = [self getDayWeek:0];
    NSTimeInterval oneDay = 24*60*60*1;  //1天的长度
    if ([weekDay isEqualToString:@"星期一"]) {
        return [date dateByAddingTimeInterval:+oneDay * 6];;
    }else if ([weekDay isEqualToString:@"星期二"]){
        return [date dateByAddingTimeInterval:+oneDay * 5];
    }else if ([weekDay isEqualToString:@"星期三"]){
        return [date dateByAddingTimeInterval:+oneDay * 4];
    }else if ([weekDay isEqualToString:@"星期四"]){
        return [date dateByAddingTimeInterval:+oneDay * 3];
    }else if ([weekDay isEqualToString:@"星期五"]){
        return [date dateByAddingTimeInterval:+oneDay * 2];
    }else if ([weekDay isEqualToString:@"星期六"]){
        return [date dateByAddingTimeInterval:+oneDay];
    }else {
        return date;
    }
}

//获取当前时间是星期几
+ (NSString *)getDayWeek:(int)dayDelay{
    NSString *weekDay;
    NSDate *dateNow;
    dateNow=[NSDate dateWithTimeIntervalSinceNow:dayDelay*24*60*60];//dayDelay代表向后推几天，如果是0则代表是今天，如果是1就代表向后推24小时，如果想向后推12小时，就可以改成dayDelay*12*60*60,让dayDelay＝1
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:dateNow];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    //    long day=[comps day];//获取日期对应的长整形字符串
    //    long year=[comps year];//获取年对应的长整形字符串
    //    long month=[comps month];//获取月对应的长整形字符串
    //    long hour=[comps hour];//获取小时对应的长整形字符串
    //    long minute=[comps minute];//获取月对应的长整形字符串
    //    long second=[comps second];//获取秒对应的长整形字符串
    //    NSString *riQi =[NSString stringWithFormat:@"%ld日",day];//把日期长整形转成对应的汉字字符串
    switch (weekNumber) {
        case 1:
            weekDay=@"星期日";
            break;
        case 2:
            weekDay=@"星期一";
            break;
        case 3:
            weekDay=@"星期二";
            break;
        case 4:
            weekDay=@"星期三";
            break;
        case 5:
            weekDay=@"星期四";
            break;
        case 6:
            weekDay=@"星期五";
            break;
        case 7:
            weekDay=@"星期六";
            break;
            
        default:
            break;
    }
    return weekDay;
}

+ (int)getDayIntWeekWithDate:(NSDate *)date{
    int weekDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:date];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    //    long day=[comps day];//获取日期对应的长整形字符串
    //    long year=[comps year];//获取年对应的长整形字符串
    //    long month=[comps month];//获取月对应的长整形字符串
    //    long hour=[comps hour];//获取小时对应的长整形字符串
    //    long minute=[comps minute];//获取月对应的长整形字符串
    //    long second=[comps second];//获取秒对应的长整形字符串
    //    NSString *riQi =[NSString stringWithFormat:@"%ld日",day];//把日期长整形转成对应的汉字字符串
    switch (weekNumber) {
        case 1:
            weekDay= 7;
            break;
        case 2:
            weekDay=1;
            break;
        case 3:
            weekDay=2;
            break;
        case 4:
            weekDay=3;
            break;
        case 5:
            weekDay=4;
            break;
        case 6:
            weekDay=5;
            break;
        case 7:
            weekDay=6;
            break;
            
        default:
            break;
    }
    return weekDay;
}

+ (NSComparisonResult)compareWithFromDateStr:(NSString *)fromDateStr{
    
    NSDate *fromDate = [self dateWithStringWithSec:fromDateStr];
    NSDate *toDate = [NSDate date];
    NSComparisonResult result = [fromDate compare:toDate];
    return result;
}

+ (NSComparisonResult)compareStartDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr{
    NSDate *startDate = [self dateWithStringNoTime:startDateStr];
    NSDate *endDate = [self dateWithStringNoTime:endDateStr];
    return [startDate compare:endDate];
}

+ (BOOL)earlyThanToday:(NSString *)targetDateStr{
    NSDate *targetDate = [self dateWithStringNoSec:targetDateStr];
    NSComparisonResult result = [targetDate compare:[self dateWithStringNoSec:[self stringWithDateNoSec:[NSDate date]]]];
    if (result == NSOrderedAscending) {
        //targetDate < [NSDate date]
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)lateThanToday:(NSString *)targetDateStr{
    NSDate *targetDate = [self dateWithStringNoSec:targetDateStr];
    NSComparisonResult result = [targetDate compare:[self dateWithStringNoSec:[self stringWithDateNoSec:[NSDate date]]]];
    if (result == NSOrderedDescending) {
        //targetDate < [NSDate date]
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)getMonthEndWith:(NSString *)dateStr{
    
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM"];
//    NSDate *newDate=[format dateFromString:dateStr];
//    double interval = 0;
//    NSDate *beginDate = nil;
//    NSDate *endDate = nil;
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    [calendar setFirstWeekday:2];//设定周一为周首日
//    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
//    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
//    if (ok) {
//        endDate = [beginDate dateByAddingTimeInterval:interval-1];
//    }else {
//        return @"";
//    }
//    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
//    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
//    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
//    NSString *endString = [myDateFormatter stringFromDate:endDate];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
//    return s;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[self dateWithStringNoTime:dateStr]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    //获取最后一天的日期
    NSDate *startDate = [self dateWithStringNoTime:dateStr];
    NSDate *endDate = [startDate dateByAddingTimeInterval:60 * 24 * 60 * numberOfDaysInMonth];
    
    return [self stringWithDateNoTime:endDate];
}

+ (NSString *)getMonthBeginWith:(NSDate *)date{
    NSString *currentDateStr = [self stringWithDateNoTime:date];
    NSString *beginStr = [NSString stringWithFormat:@"%@01",[currentDateStr substringToIndex:8]];
    return beginStr;
}

+ (NSUInteger)getMonthDayCountWithDate:(NSString *)dateStr{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[self dateWithStringNoTime:dateStr]];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

@end

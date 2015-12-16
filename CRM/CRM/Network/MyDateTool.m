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

@end

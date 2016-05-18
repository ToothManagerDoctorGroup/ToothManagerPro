//
//  NSDate+Conversion.m
//  PhotoSharer
//
//  Created by TimTiger on 3/18/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "NSDate+Conversion.h"

@implementation NSDate (Conversion)

/**
 *  NSDate 转成字符串
 *
 *  @return 字符串
 */
- (NSString *)dateToNSString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

/**
 *  NSDate 转成字符串
 *
 *  @return 字符串
 */
- (NSString *)dateToNSStringWithoutTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

/**
 *  NSDate 转成 double
 *
 *  @return double
 */
- (NSTimeInterval)dateToNSTimeInterval {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return timeInterval;
}

/**
 *  NSDate 转成 NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber *)dateToNSNumber {
    NSNumber *number = [NSNumber numberWithDouble:[self dateToNSTimeInterval]];
    return number;
}

- (BOOL)isSameDay:(NSDate *)date {
    NSDateComponents    *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents    *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    return ([components1 year] == [components2 year]) &&
    ([components1 month] == [components2 month]) &&
    ([components1 day] == [components2 day]);
}

/**
 *  根据字符串获得NSDate
 *
 *  @param string 格式为  2015-08-12 08:30 格式
 *
 *  @return NSDate
 */
+ (NSDate *)dateWithString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"YYYY-MM-DD HH:MM";
    return [format dateFromString:string];
}

@end

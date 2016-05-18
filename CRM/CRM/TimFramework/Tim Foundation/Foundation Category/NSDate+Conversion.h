//
//  NSDate+Conversion.h
//  PhotoSharer
//
//  Created by TimTiger on 3/18/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Conversion)

/**
 *  NSDate 转成字符串
 *
 *  @return 字符串
 */
- (NSString *)dateToNSString;

- (NSString *)dateToNSStringWithoutTime;

/**
 *  NSDate 转成 double
 *
 *  @return double
 */
- (NSTimeInterval)dateToNSTimeInterval;

/**
 *  NSDate 转成 NSNumber
 *
 *  @return NSNumber
 */
- (NSNumber *)dateToNSNumber;

/**
 *  是否是同一天
 *
 *  @param date 日期
 *
 *  @return YES or NO
 */
- (BOOL)isSameDay:(NSDate *)date;

/**
 *  根据字符串获得NSDate
 *
 *  @param string 格式为  2015-08-12 08:30 格式
 *
 *  @return NSDate
 */
+ (NSDate *)dateWithString:(NSString *)string;

@end

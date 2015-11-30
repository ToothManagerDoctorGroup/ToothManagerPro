//
//  NSString+MyString.m
//  CRM
//
//  Created by Argo Zhang on 15/11/30.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "NSString+MyString.h"
#import "NSDate+MyDate.h"

@implementation NSString (MyString)

- (NSString *)hourMinutesSecondTimeFormat {
    NSUInteger seconds = [self integerValue];
    NSUInteger minutes = seconds / 60;
    
    NSUInteger hours = minutes / 60;
    NSUInteger minute = minutes % 60;
    NSUInteger second = seconds % 60;
    
    NSString *result = [NSString stringWithFormat:@"%@小时%@分%@秒", @(hours), @(minute), @(second)];
    return result;
}

+ (NSString *)stringwithNumber:(NSNumber *)number {
    return [NSString stringWithFormat:@"%@", number];
}

- (NSString *)timeToNow {
    NSDate *startTime = [NSDate fs_dateFromString:self format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time = -[startTime timeIntervalSinceNow]; // 秒级时间差
    return [[NSString stringwithNumber:@(time)] hourMinutesSecondTimeFormat];
}


@end

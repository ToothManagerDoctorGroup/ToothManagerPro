//
//  NSDate+MyDate.m
//  CRM
//
//  Created by Argo Zhang on 15/11/30.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "NSDate+MyDate.h"

@implementation NSDate (MyDate)

+ (instancetype)fs_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

@end

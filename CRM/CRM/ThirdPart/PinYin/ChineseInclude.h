//
//  ChineseInclude.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseInclude : NSObject
+ (BOOL)isIncludeChineseInString:(NSString*)str;
//判断是否是纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;

@end

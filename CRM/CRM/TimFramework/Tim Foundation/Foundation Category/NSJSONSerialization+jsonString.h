//
//  NSJSONSerialization+jsonString.h
//  CRM
//
//  Created by TimTiger on 3/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (jsonString)

//object 转json 字符串
+ (NSString* )jsonStringWithObject:(id)object;

@end

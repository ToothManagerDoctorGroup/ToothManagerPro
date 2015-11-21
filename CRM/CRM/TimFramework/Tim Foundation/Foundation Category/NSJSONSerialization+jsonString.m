//
//  NSJSONSerialization+jsonString.m
//  CRM
//
//  Created by TimTiger on 3/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "NSJSONSerialization+jsonString.h"

@implementation NSJSONSerialization (jsonString)

+ (NSString* )jsonStringWithObject:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        //hand error
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

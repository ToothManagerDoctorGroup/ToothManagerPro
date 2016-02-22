//
//  AreaObject.m
//
//  Created by zhengzeqin on 15/5/28.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.

#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    if ([self.province isEqualToString:@"北京"] ||
        [self.province isEqualToString:@"上海"] ||
        [self.province isEqualToString:@"重庆"] ||
        [self.province isEqualToString:@"天津"] ||
        [self.province isEqualToString:@"香港特别行政区"] ||
        [self.province isEqualToString:@"澳门特别行政区"] ||
        [self.province isEqualToString:@"台湾"]) {
        return [NSString stringWithFormat:@"%@%@",self.city,self.area];
    }
    return [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.area];
}

@end
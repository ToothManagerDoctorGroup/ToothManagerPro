//
//  TimRequest.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimRequest.h"

@implementation TimRequest

+(id)deafalutRequest {
    static TimRequest *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TimRequest alloc]init];
    });
    return _instance;
}

@end

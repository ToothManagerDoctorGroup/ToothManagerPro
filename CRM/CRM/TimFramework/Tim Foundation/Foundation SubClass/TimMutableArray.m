//
//  TimMutableArray.m
//  CRM
//
//  Created by TimTiger on 6/1/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimMutableArray.h"

@implementation TimMutableArray

- (void)addObject:(id)anObject {
    if (anObject == nil) {
        return;
    } else {
        [super addObject:anObject];
    }
}

@end

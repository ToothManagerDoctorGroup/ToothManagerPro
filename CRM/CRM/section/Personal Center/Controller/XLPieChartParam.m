//
//  XLPieChartParam.m
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPieChartParam.h"

@implementation XLPieChartParam

- (instancetype)initWithColor:(UIColor *)color scale:(double)scale status:(NSString *)status count:(double)count{
    if (self = [super init]) {
        
        self.color = color;
        self.scale = scale;
        self.status = status;
        self.count = count;
    }
    return self;
}

@end

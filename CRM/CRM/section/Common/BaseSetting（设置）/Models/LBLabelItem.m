//
//  LBLabelItem.m
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBLabelItem.h"

@implementation LBLabelItem

+ (instancetype)itemWithText:(NSString *)text{
    LBLabelItem *item = [[self alloc] init];
    item.text = text;
    return item;
}

@end

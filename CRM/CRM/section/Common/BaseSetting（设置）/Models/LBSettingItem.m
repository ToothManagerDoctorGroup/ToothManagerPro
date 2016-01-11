//
//  LBSettingItem.m
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBSettingItem.h"

@implementation LBSettingItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image{
    LBSettingItem *item = [[self alloc] init];
    item.title = title;
    item.image = image;
    item.subTitle = subTitle;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithTitle:title subTitle:nil image:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image{
    return [self itemWithTitle:title subTitle:nil image:image];
}

@end

//
//  LBLabelItem.h
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBSettingItem.h"

@interface LBLabelItem : LBSettingItem

@property (nonatomic, copy)NSString *text;

+ (instancetype)itemWithText:(NSString *)text;

@end

//
//  LBSettingGroup.h
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSettingGroup : NSObject

/**
 *  每组有几行（LBSettingItem）
 */
@property (nonatomic, strong)NSArray *items;
/**
 *  每组头视图
 */
@property (nonatomic, copy)NSString *headTitle;
/**
 *  每组尾视图
 */
@property (nonatomic, copy)NSString *footTitle;

@end

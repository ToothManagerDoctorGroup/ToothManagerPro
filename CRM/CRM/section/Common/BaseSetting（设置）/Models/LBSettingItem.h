//
//  LBSettingItem.h
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LBSettingItem;

typedef void(^LBSettingItemOption)(LBSettingItem *item);

@interface LBSettingItem : NSObject

/**
 *  对应cell的imageView
 */
@property (nonatomic, strong)UIImage *image;
/**
 *  对应cell的textLabel
 */
@property (nonatomic, copy)NSString *title;
/**
 *  对应cell的detailTextLabel
 */
@property (nonatomic, copy)NSString *subTitle;
/**
 *  需要跳转的目标控制器
 */
@property (nonatomic, assign)Class targetVc;

@property (nonatomic, copy)LBSettingItemOption option;


+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;
+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;

@end

//
//  MBProgressHUD+THCAddtion.h
//  MerchantClient
//
//  Created by thc on 15/4/20.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (THCAddtion)

/*!
 @method
 @abstract 在某个view显示一段文字
 @discussion 在某个view显示一段文字
 
 @param view 显示的视图
 @param text 显示的文字
 */
+ (instancetype)showToastWithView:(UIView *)view text:(NSString *)text;

/*!
 @method
 @abstract 显示带文字的HUD
 @discussion 显示带文字的HUD
 
 @param text 显示的文字
 */
+ (instancetype)showToastWithText:(NSString *)text;


/*!
 @method
 @abstract 显示进度的HUD
 @discussion 显示进度的HUD
 
 @param view HUD加在的View，项目中用self.navigationController.view
 @param text 显示的文字
 */
+ (instancetype)showHUDWithView:(UIView *)view text:(NSString *)text;

/*!
 @method
 @abstract 隐藏进度的HUD
 @discussion 隐藏进度的HUD
 
 @param view HUD加在的View，项目中用self.navigationController.view
 */
+ (void)hideHUDWithView:(UIView *)view;

/**
 *  显示加载视图
 *
 *  @return 视图
 */
+ (instancetype)showLoading;

@end

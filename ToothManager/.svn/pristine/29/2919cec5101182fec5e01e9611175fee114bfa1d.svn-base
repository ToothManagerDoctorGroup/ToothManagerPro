//
//  MBProgressHUD+THCAddtion.m
//  MerchantClient
//
//  Created by thc on 15/4/20.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import "MBProgressHUD+THCAddtion.h"
#define kShowTime 1.f

@implementation MBProgressHUD (THCAddtion)

+ (instancetype)showToastWithView:(UIView *)view text:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:kShowTime];
    return hud;
}

+ (instancetype)showToastWithText:(NSString *)text {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    return [self showToastWithView:window text:text];
}

+ (instancetype)showHUDWithView:(UIView *)view text:(NSString *)text {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

+ (void)hideHUDWithView:(UIView *)view {
    [self hideHUDForView:view animated:YES];
}

+ (instancetype)showLoading {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

@end

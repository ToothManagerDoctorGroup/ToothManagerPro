//
//  MBProgressHUD+XLHUD.h
//  CRM
//
//  Created by Argo Zhang on 16/3/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XLHUD)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end

//
//  XLGuideImageView.h
//  CRM
//
//  Created by Argo Zhang on 16/2/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)();

@interface XLGuideImageView : UIImageView

- (void)showInView:(UIView *)view dismissBlock:(DismissBlock)dismissBlock;

- (void)showInView:(UIView *)view autoDismiss:(BOOL)autoDismiss dismissBlock:(DismissBlock)dismissBlock;


@end

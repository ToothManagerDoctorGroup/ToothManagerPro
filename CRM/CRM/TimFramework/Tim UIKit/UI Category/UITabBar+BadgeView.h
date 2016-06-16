//
//  UITabBar+BadgeView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (BadgeView)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end

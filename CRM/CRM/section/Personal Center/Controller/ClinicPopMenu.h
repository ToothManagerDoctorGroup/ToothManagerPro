//
//  ClinicPopMenu.h
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClinicPopMenu : UIImageView

//显示菜单视图
+ (instancetype)showInRect:(CGRect)rect;

//隐藏菜单视图
+ (void)hide;

//菜单视图的内容
@property (nonatomic, weak)UIView *contentView;

@end

//
//  UISearchBar+XLMoveBgView.h
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (XLMoveBgView)
//去除背景色
- (void)moveBackgroundView;

//修改cancelBtn的文字内容
- (void)changeCancelButtonTitle:(NSString *)title;

//获取cancelBtn的文字内容
- (NSString *)currentTitle;

@end

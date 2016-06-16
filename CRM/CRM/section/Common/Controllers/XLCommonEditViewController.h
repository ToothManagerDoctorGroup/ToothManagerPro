//
//  XLCommonEditViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/2/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  公用的信息编辑页面
 */
@class XLCommonEditViewController;
@protocol XLCommonEditViewControllerDelegate <NSObject>

@optional
- (void)commonEditViewController:(XLCommonEditViewController *)editVc content:(NSString *)content title:(NSString *)title;

@end

@interface XLCommonEditViewController : TimViewController

@property (nonatomic, assign)BOOL showBtn;//是否显示按钮

@property (nonatomic, copy)NSString *placeHolder;//提示语

@property (nonatomic, copy)NSString *content;//内容

@property (nonatomic, assign)UIKeyboardType keyboardType;//键盘类型

@property (nonatomic, copy)NSString *rightButtonTitle;//右侧按钮文字

@property (nonatomic, weak)id<XLCommonEditViewControllerDelegate> delegate;

@end

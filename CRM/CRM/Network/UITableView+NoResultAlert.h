//
//  UITableView+NoResultAlert.h
//  CRM
//
//  Created by Argo Zhang on 16/4/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)();

@interface UITableView (NoResultAlert)
/**
 *  未使用AutoLayout,[UITableView addSubview:]不能使用布局
 *
 *  @param imageName  图片名称
 *  @param showButton 是否显示按钮
 */
- (UIView *)createNoSearchResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton;

- (void)createNoResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton ifNecessaryForRowCount:(NSUInteger)rowCount;

- (void)createNoResultAlertHeaderViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton ifNecessaryForRowCount:(NSUInteger)rowCount;
@end

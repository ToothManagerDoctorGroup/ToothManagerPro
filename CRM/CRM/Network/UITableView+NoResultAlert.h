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
//- (UIView *)createNoSearchResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton;

- (void)createNoResultAlertViewWithImageName:(NSString *)imageName showButton:(BOOL)showButton ifNecessaryForRowCount:(NSUInteger)rowCount;


/**
 *  创建无数据提示视图（含button）
 *
 *  @param imageName     图片名称
 *  @param rowCount      数据个数
 *  @param buttonTitle   按钮标题
 *  @param target        target
 *  @param action        按钮点击方法
 *  @param controlEvents 按钮点击属性
 */
- (void)createNoResultWithButtonWithImageName:(NSString *)imageName
                       ifNecessaryForRowCount:(NSUInteger)rowCount
                                  buttonTitle:(NSString *)buttonTitle
                                       target:(id)target
                                       action:(SEL)action
                             forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建无数据提示视图（无button,图片无点击事件）
 *
 *  @param imageName 图片名称
 *  @param rowCount  数据个数
 */
- (void)createNoResultWithImageName:(NSString *)imageName
             ifNecessaryForRowCount:(NSUInteger)rowCount;
/**
 *  创建无数据时的提示视图（无button,图片有点击事件）
 *
 *  @param imageName 图片名称
 *  @param rowCount  数据个数
 *  @param target    target
 *  @param action    tapAction
 */
- (void)createNoResultWithImageName:(NSString *)imageName
             ifNecessaryForRowCount:(NSUInteger)rowCount
                             target:(id)target
                             action:(SEL)action;

@end

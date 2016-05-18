//
//  XLCustomAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//


typedef NS_ENUM(NSInteger,CustonAlertViewType){
    CustonAlertViewTypeNormal,//普通样式
    CustonAlertViewTypeSwitch,//开关样式
    CustonAlertViewTypeCheck   //选择按钮样式
};
/**
 *  自定义弹出框
 */
@class XLAlertView,XLCustomAlertView;

typedef void(^CustomCancelHandler)();
typedef void(^CustomCertainHandler)(NSString *content);
typedef void(^CustomCertainSwitchHandler)(NSString *content,BOOL wenxinSend,BOOL messageSend);

@interface XLCustomAlertView : UIView
/**
 *  初始化，不带switch按钮
 *
 *  @param title          标题
 *  @param message        提醒内容
 *  @param cancel         删除按钮标题
 *  @param certain        确定按钮内容
 *  @param canEdit        是否可编辑
 *  @param canDismiss     是否带手动隐藏按钮
 *  @param cancelHandler  取消按钮点击回调
 *  @param certainHandler 确定按钮点击回调
 *
 *  @return XLCustomAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        Cancel:(NSString *)cancel
                       certain:(NSString *)certain
                      canEdit:(BOOL)canEdit
                      canDismiss:(BOOL)canDismiss
                  cancelHandler:(CustomCancelHandler)cancelHandler
                 certainHandler:(CustomCertainHandler)certainHandler;
/**
 *  初始化，带button按钮
 *
 *  @param title          标题
 *  @param message        提醒内容
 *  @param cancel         取消按钮标题
 *  @param certain        确定按钮标题
 *  @param weixinCanCheck 微信按钮是否可编辑
 *  @param cancelHandler  取消按钮点击回调
 *  @param certainHandler 确定按钮点击回调
 *
 *  @return XLCustomAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                       Cancel:(NSString *)cancel
                      certain:(NSString *)certain
                 weixinEnalbe:(BOOL)weixinEnalbe
                         type:(CustonAlertViewType)type
                cancelHandler:(CustomCancelHandler)cancelHandler
               certainHandler:(CustomCertainSwitchHandler)certainHandler;

- (void)show;

- (void)dismiss;


@end

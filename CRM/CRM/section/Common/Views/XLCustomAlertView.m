//
//  XLCustomAlertView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCustomAlertView.h"
#import "CustomIOS7AlertView.h"
#import "UIColor+Extension.h"
#import "XLAlertView.h"
#import "NSString+TTMAddtion.h"
#import "XLSwitchAlertView.h"
#import "XLCheckAlertView.h"

#define TitleFont [UIFont boldSystemFontOfSize:20]
#define ContentFont [UIFont systemFontOfSize:15]
#define MAXWIDTH 320;


@interface XLCustomAlertView ()<CustomIOS7AlertViewDelegate,XLCheckAlertViewDelegate>{
    CustomCancelHandler _cancelHandler;
    CustomCertainHandler _certainHandler;
    CustomCertainSwitchHandler _switchHandler;
}

@property (nonatomic, copy)NSString *cancelTitle;

@property (nonatomic, copy)NSString *certainTitle;

@property (nonatomic, assign)BOOL canDismiss;

@property (nonatomic, weak)CustomIOS7AlertView *alertView;

@property (nonatomic, weak)XLAlertBaseView *textView;

@property (nonatomic, assign)CustonAlertViewType type;

@end

@implementation XLCustomAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                       Cancel:(NSString *)cancel
                      certain:(NSString *)certain
                      canEdit:(BOOL)canEdit
                   canDismiss:(BOOL)canDismiss
                cancelHandler:(CustomCancelHandler)cancelHandler
               certainHandler:(CustomCertainHandler)certainHandler{
    
    CGRect frame = [self consulationFrame:title content:message showSwitch:NO type:CustonAlertViewTypeNormal];
    if (self = [super initWithFrame:frame]) {
        
        XLAlertBaseView *textView = [[XLAlertBaseView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
        
        self.textView = textView;
        self.textView.titleLabel.text = title;
        self.textView.contentTextView.text = message;
        self.textView.contentTextView.editable = canEdit;
        [self addSubview:textView];
        
        self.cancelTitle = cancel;
        self.certainTitle = certain;
        self.canDismiss = canDismiss;
        
        _cancelHandler = cancelHandler;
        _certainHandler = certainHandler;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                       Cancel:(NSString *)cancel
                      certain:(NSString *)certain
                 weixinEnalbe:(BOOL)weixinEnalbe
                         type:(CustonAlertViewType)type
                cancelHandler:(CustomCancelHandler)cancelHandler
               certainHandler:(CustomCertainSwitchHandler)certainHandler{
    CGRect frame = [self consulationFrame:title content:message showSwitch:YES type:type];
    if (self = [super initWithFrame:frame]) {
        switch (type) {
            case CustonAlertViewTypeNormal:
                
                break;
            case CustonAlertViewTypeSwitch:
            {
                XLAlertBaseView *switchView = [[XLSwitchAlertView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
                XLSwitchAlertView *switchAlert = (XLSwitchAlertView *)switchView;
                switchAlert.titleLabel.text = title;
                switchAlert.contentTextView.text = message;
                switchAlert.weiXinEnable = weixinEnalbe;
                switchAlert.showSwitch = YES;
                self.textView = switchView;
                
                [self addSubview:switchView];
            
            }
                break;
            case CustonAlertViewTypeCheck:
            {
                XLAlertBaseView *switchView = [[XLCheckAlertView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
                XLCheckAlertView *switchAlert = (XLCheckAlertView *)switchView;
                switchAlert.titleLabel.text = title;
                switchAlert.contentTextView.text = message;
                switchAlert.weiXinCheckEnable = weixinEnalbe;
                switchAlert.showCheck = YES;
                switchAlert.delegate = self;
                self.textView = switchView;
                [self addSubview:switchView];
                
            }
                
                break;
            default:
                break;
        }
        
        self.cancelTitle = cancel;
        self.certainTitle = certain;
        self.type = type;
        
        _cancelHandler = cancelHandler;
        _switchHandler = certainHandler;
    }
    return self;
}

- (void)show{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:self];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:self.cancelTitle, self.certainTitle, nil]];
    alertView.delegate = self;
    [alertView setUseDismissButton:self.canDismiss];
    [alertView setUseMotionEffects:true];
    self.alertView = alertView;
    [alertView show];
}

#pragma mark - XLCheckAlertViewDelegate
- (void)checkAlertView:(XLCheckAlertView *)alertView didSelect:(BOOL)select{
    self.alertView.certainBtnEnable = select;
}

#pragma mark - 计算frame大小
- (CGRect)consulationFrame:(NSString *)title content:(NSString *)content showSwitch:(BOOL)showSwitch type:(CustonAlertViewType)type{
    //判断当前屏幕的大小
    CGFloat viewW = 0;
    if (kScreenWidth > 375) {
        viewW = MAXWIDTH;
    }else{
        viewW = kScreenWidth - 60;
    }
    //判断按钮所在高度
    CGFloat buttonH = 0;
    if (type == CustonAlertViewTypeSwitch) {
        buttonH = 60;
    }else if (type == CustonAlertViewTypeCheck){
        buttonH = 30;
    }
    
    //计算内容的高度
    CGSize titleSize = [title measureFrameWithFont:TitleFont size:CGSizeMake(viewW - 20, MAXFLOAT)].size;
    CGSize contentSize = [content measureFrameWithFont:ContentFont size:CGSizeMake(viewW - 20, MAXFLOAT)].size;
    CGFloat titleH = 30;
    CGFloat contentH = contentSize.height;
    if (titleSize.height > 30) {
        titleH = titleSize.height;
    }
    
    CGFloat viewH = 0;
    CGRect frame = CGRectZero;
    if (showSwitch) {
        viewH = titleH + 10 * 2 + contentH + buttonH + 10;
    }else{
        viewH = titleH + 10 * 2 + contentH + 10;
    }
    if (viewH > 250) {
        viewH = 250;
    }
    
    frame = CGRectMake(0, 0, viewW, viewH);
    
    return frame;
}

- (void)dismiss{
    [self.alertView close];
}


#pragma mark - CustomIOS7AlertViewDelegate
- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismiss];
    
    if (buttonIndex == 0) {
        //取消
        if (_cancelHandler) {
            _cancelHandler();
        }
    }else{
        if (_certainHandler) {
            _certainHandler(self.textView.contentTextView.text);
        }else if (_switchHandler){
            if (self.type == CustonAlertViewTypeSwitch) {
                XLSwitchAlertView *switchAlert = (XLSwitchAlertView *)self.textView;
                _switchHandler(switchAlert.contentTextView.text,switchAlert.weixinIsOn,switchAlert.messageIsOn);
            }else if (self.type == CustonAlertViewTypeCheck){
                XLCheckAlertView *checkAlert = (XLCheckAlertView *)self.textView;
                _switchHandler(checkAlert.contentTextView.text,checkAlert.weixinIsCheck,checkAlert.messageIsCheck);
            }
        }
    }
}

@end

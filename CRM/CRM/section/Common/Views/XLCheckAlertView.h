//
//  XLCheckAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAlertBaseView.h"

@class XLCheckAlertView;
@protocol XLCheckAlertViewDelegate <NSObject>

@optional
- (void)checkAlertView:(XLCheckAlertView *)alertView didSelect:(BOOL)select;

@end

@interface XLCheckAlertView : XLAlertBaseView

@property (nonatomic, assign)BOOL showCheck;//是否显示check
@property (nonatomic, assign)BOOL weiXinCheckEnable;//微信的check是否可点

@property (nonatomic, assign,getter=weixinIsCheck)BOOL weixinCheck;//微信是否打开
@property (nonatomic, assign,getter=messageIsCheck)BOOL messageCheck;//短信是否打开

@property (nonatomic, weak)id<XLCheckAlertViewDelegate> delegate;

@end

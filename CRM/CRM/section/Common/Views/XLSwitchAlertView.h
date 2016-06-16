//
//  XLSwitchAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAlertBaseView.h"

@interface XLSwitchAlertView : XLAlertBaseView

@property (nonatomic, assign)BOOL showSwitch;//是否显示switch
@property (nonatomic, assign)BOOL weiXinEnable;//微信的switch是否可点

@property (nonatomic, assign,getter=weixinIsOn)BOOL weixinOn;//微信是否打开
@property (nonatomic, assign,getter=messageIsOn)BOOL messageOn;//短信是否打开

@end

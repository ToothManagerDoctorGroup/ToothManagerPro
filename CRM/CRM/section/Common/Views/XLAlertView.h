//
//  XLAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/15.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAlertView : UIView

@property (nonatomic, weak)UILabel *titleLabel;//标题
@property (nonatomic, weak)UITextView *contentTextView;//内容

@property (nonatomic, assign)BOOL showSwitch;//是否显示switch
@property (nonatomic, assign)BOOL weiXinEnable;//微信的switch是否可点

@property (nonatomic, assign,getter=weixinIsOn)BOOL weixinOn;//微信是否打开
@property (nonatomic, assign,getter=messageIsOn)BOOL messageOn;//短信是否打开

@end

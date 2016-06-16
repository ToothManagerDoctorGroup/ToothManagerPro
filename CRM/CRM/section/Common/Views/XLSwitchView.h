//
//  XLSwitchView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLSwitchView : UIView

@property (nonatomic, assign, getter=isOn)BOOL on;

@property (nonatomic, assign)BOOL enable;

@property (nonatomic, copy)NSString *title;

@end

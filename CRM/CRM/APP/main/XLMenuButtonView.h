//
//  XLMenuButtonView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLMenuButtonView : UIView

- (void)show;
- (void)dismiss;

@property (nonatomic, weak)UINavigationController *viewController;

@end

//
//  CRMViewAppearance.m
//  CRM
//
//  Created by TimTiger on 5/23/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMViewAppearance.h"
#import "TimFramework.h"
#import "CRMMacro.h"

@implementation CRMViewAppearance

+ (void)setCRMAppearance {
    
    //设置搜索条 cancel按钮颜色
    [[UIBarButtonItem appearanceWhenContainedIn:[TimSearchBar class], nil] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    //设置导航条 标题颜色
    [[TimNavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor whiteColor], UITextAttributeTextColor,nil]];
    
    //设置导航条 背景色
    if (IOS_7_OR_LATER) {
        [[TimNavigationBar appearance] setBarTintColor:[UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR]];
    } else if(IOS_5_OR_LATER) {
        [[TimNavigationBar appearance] setTintColor:[UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR]];
    }
    
    //设置搜索条 背景色
    if (IOS_7_OR_LATER) {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR],
                                                                                                      UITextAttributeTextColor,
                                                                                                       [UIColor colorWithHex:SEARCH_BAR_BACKGROUNDCOLOR],
                                                                                                      UITextAttributeTextShadowColor,
                                                                                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                                                                      UITextAttributeTextShadowOffset,
                                                                                                      nil]
                                                                                            forState:UIControlStateNormal];

    }
    UIImage *image =  [[UIImage imageNamed:@"searchbar_bg"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5];
    [[UISearchBar appearance] setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

@end

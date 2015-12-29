//
//  UISearchBar+XLMoveBgView.m
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UISearchBar+XLMoveBgView.h"
#import "CommonMacro.h"

@implementation UISearchBar (XLMoveBgView)
- (void)moveBackgroundView{
    self.backgroundColor = MyColor(187, 187, 187);
    for (UIView *view in self.subviews) {
        if (IOS_7_OR_LATER) {
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }else{
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
        }
    }
}
@end

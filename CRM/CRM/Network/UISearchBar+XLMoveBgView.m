//
//  UISearchBar+XLMoveBgView.m
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "UISearchBar+XLMoveBgView.h"
#import "CommonMacro.h"
#import "UIColor+Extension.h"

@implementation UISearchBar (XLMoveBgView)
- (void)moveBackgroundView{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor colorWithHex:0xdddddd] CGColor];
    self.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    for (UIView *view in self.subviews) {
        if (IOS_7_OR_LATER) {
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//                UIView *viewTmp = [view.subviews objectAtIndex:0];
//                [viewTmp setValue:[UIColor colorWithHex:0xEEEEEE] forKey:@"backgroundColor"];
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }else{
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                [view setValue:[UIColor colorWithHex:0xEEEEEE] forKey:@"backgroundColor"];
                [view removeFromSuperview];
                break;
            }
        }
    }
}

- (void)changeCancelButtonTitle:(NSString *)title{
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:title forState:UIControlStateNormal];
        }
    }
}

- (NSString *)currentTitle{
    NSString *title;
    for (UIView *view in [[self.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            title = cancelBtn.currentTitle;
        }
    }
    return title;
}
@end

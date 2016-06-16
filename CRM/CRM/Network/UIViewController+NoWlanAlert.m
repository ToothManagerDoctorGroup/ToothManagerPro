//
//  UIViewController+NoWlanAlert.m
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "UIViewController+NoWlanAlert.h"
#import "UIColor+Extension.h"

@implementation UIViewController (NoWlanAlert)

- (UIView *)createNoWlanAlertViewWithTitle:(NSString *)title{
    UILabel *tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, kScreenWidth, 30)];
    tintLabel.font = [UIFont systemFontOfSize:13];
    tintLabel.textColor = [UIColor colorWithHex:0xf27e00];
    tintLabel.backgroundColor = [UIColor colorWithHex:0xfff2b7];
    tintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tintLabel];
    
    return tintLabel;
}

@end

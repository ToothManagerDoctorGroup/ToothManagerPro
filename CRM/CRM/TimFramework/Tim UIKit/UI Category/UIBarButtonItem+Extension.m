//
//  UIBarButtonItem+Extension.m
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "CommonMacro.h"
#import "NSString+TTMAddtion.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImage:(UIImage*)image target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString*)title target:(id)target action:(SEL)action {
//    CGSize titleSize = [title measureFrameWithFont:[UIFont systemFontOfSize:15] size:CGSizeMake(MAXFLOAT, MAXFLOAT)]
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    [button.titleLabel.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    red += 0.1;
    green += 0.1;
    blue += 0.1;
    [button setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0,50, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [item setStyle:UIBarButtonItemStylePlain];
    return item;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    UIButton *button = (UIButton *)self.customView;
    [button setTitleColor:color forState:state];
    if (state == UIControlStateNormal) {
        CGFloat red = 0;
        CGFloat green = 0;
        CGFloat blue = 0;
        CGFloat alpha = 0;
        [button.titleLabel.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
        red += 0.2;
        green += 0.2;
        blue += 0.2;
        [button setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:alpha] forState:UIControlStateHighlighted];
    }
}


@end

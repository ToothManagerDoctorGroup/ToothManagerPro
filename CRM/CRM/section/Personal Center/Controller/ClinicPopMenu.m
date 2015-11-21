//
//  ClinicPopMenu.m
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicPopMenu.h"
#import "UIImage+LBImage.h"

@implementation ClinicPopMenu

//显示菜单视图
+ (instancetype)showInRect:(CGRect)rect{
    
    //遍历window的子控件
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ClinicPopMenu *menu = [[ClinicPopMenu alloc] initWithFrame:rect];
    menu.userInteractionEnabled = YES;
    menu.image = [UIImage imageWithStretchableName:@"popover_background"];
    //将弹出菜单添加到window上
    [keyWindow addSubview:menu];
    
    return menu;
}

//隐藏弹出菜单
+ (void)hide{
    //遍历window的子控件
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in keyWindow.subviews) {
        if ([view isKindOfClass:self]) {
            [view removeFromSuperview];
        }
    }
}

- (void)setContentView:(UIView *)contentView{
    //先移除之前的contentView
    [_contentView removeFromSuperview];
    //重新设置内容视图
    _contentView = contentView;
    
    //设置内容视图的颜色
    _contentView.backgroundColor = [UIColor clearColor];
    
    //添加到主视图
    [self addSubview:_contentView];
    
}

//设置子控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 5;
    CGFloat contentX = margin * 2;
    CGFloat contentY = margin * 4;
    CGFloat contentW = self.width - contentY;
    CGFloat contentH = self.height - contentX * 3;
    
    self.contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
}


@end

//
//  ClinicCover.m
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicCover.h"

@implementation ClinicCover


#pragma mark - 重写setDimBackground方法，设置浅灰蒙板或者透明蒙板
- (void)setDimBackground:(BOOL)dimBackground{
    _dimBackground = dimBackground;
    
    if (_dimBackground) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
    }
}

//显示蒙板(蒙板一般都是添加到window上)
+ (instancetype)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ClinicCover *cover = [[ClinicCover alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor clearColor];
    [keyWindow addSubview:cover];
    return cover;
}

//点击蒙板，移除蒙板，同时通知代理隐藏菜单
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //移除蒙板
    [self removeFromSuperview];
    
    //判断代理是否实现了协议
    if ([self.delegate respondsToSelector:@selector(coverDidClickCover:)]) {
        //通知代理隐藏菜单
        [self.delegate coverDidClickCover:self];
    }
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end

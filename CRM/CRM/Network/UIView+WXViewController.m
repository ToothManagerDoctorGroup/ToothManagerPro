//
//  UIView+WXViewController.m
//
//  Created by apple on 14/9/2.
//  Copyright (c) 2014年 徐晓龙. All rights reserved.
//

#import "UIView+WXViewController.h"

@implementation UIView (WXViewController)

- (UIViewController *)viewController{
    //从响应者链中获取当前视图的下一响应者
    UIResponder *responder = self.nextResponder;
    
    //判断当前获取到的响应者的类型
    while (YES) {
        //如果是视图控制器
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }else{
            //循环获取下一个响应者
            responder = responder.nextResponder;
            //判断响应者是否为空
            if (responder == nil) {
                return nil;
            }
        }
    }
}

@end

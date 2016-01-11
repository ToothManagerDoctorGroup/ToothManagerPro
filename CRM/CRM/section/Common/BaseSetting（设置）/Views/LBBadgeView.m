//
//  LBBadgeView.m
//  LBWeiBo
//
//  Created by apple on 15/9/19.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBBadgeView.h"

#define BadgeViewFont [UIFont systemFontOfSize:11]

@implementation LBBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        //设置字体大小
        self.titleLabel.font = BadgeViewFont;
        
        //设置不可点击
        self.userInteractionEnabled = NO;
        
        //设置按钮大小自适应
        [self sizeToFit];
    }
    return self;
}

#pragma mark - 重写badgeValue的set方法，设置显示或者隐藏
- (void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    
    
    //判断当前传递过来的badgeValue是否为空
    if (badgeValue == nil || [badgeValue isEqualToString:@"0"]) {
        //如果为空或者为0隐藏视图
        self.hidden = YES;
    }else{
        //否则显示视图
        self.hidden = NO;
    }
    
    //计算文字的长度
    CGFloat badgeValueWidth = [badgeValue sizeWithFont:BadgeViewFont].width;
    
    //判断文字的长度是否超过了按钮的长度
    if (badgeValueWidth > self.width) {
        //如果超过了按钮的长度，就显示红点
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        //如果没有超出按钮的长度，就显示数字
        [self setImage:nil forState:UIControlStateNormal];
        [self setTitle:self.badgeValue forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    }
}

@end

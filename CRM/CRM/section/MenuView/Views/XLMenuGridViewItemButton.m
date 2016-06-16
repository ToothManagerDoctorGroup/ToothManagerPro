//
//  XLMenuGridViewItemButton.m
//  CRM
//
//  Created by Argo Zhang on 16/5/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMenuGridViewItemButton.h"
#import "UIColor+Extension.h"

@implementation XLMenuGridViewItemButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

//调整图片的位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageH = self.frame.size.height * 0.3;
    CGFloat imageW = imageH;
    CGFloat imageX = (self.frame.size.width - imageW) * 0.5;
    CGFloat imageY = self.frame.size.height * 0.3;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//调整标题的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = self.frame.size.height * 0.6;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * 0.3;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end

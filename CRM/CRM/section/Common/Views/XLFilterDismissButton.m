//
//  XLFilterDismissButton.m
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilterDismissButton.h"
#import "UIImage+TTMAddtion.h"
#import "UIColor+Extension.h"

#define SuperHeight 25

@interface XLFilterDismissButton (){
    UIImageView *_imageView;
    
    CGFloat xDistance; //触摸点和中心点x方向移动的距离
    CGFloat yDistance; //触摸点和中心点y方向移动的距离
    CGPoint beginPoint;//第一次的点
}

@end

@implementation XLFilterDismissButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor colorWithHex:0xeaeaea];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithFileName:@"filter_dismiss"]];
    [self addSubview:_imageView];
    
    [self setUpFrame];
}

- (void)setUpFrame{
    CGFloat imageW = 19;
    CGFloat imageH = 9;
    CGFloat imageX = (kScreenWidth - imageW) / 2;
    CGFloat imageY = (SuperHeight - imageH) / 2;
    
    _imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGFloat)fixHeight{
    return SuperHeight;
}
@end

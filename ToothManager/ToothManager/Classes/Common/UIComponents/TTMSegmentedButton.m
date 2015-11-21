//
//  MCSegmentedButton.m
//  MerchantClient
//
//  Created by Jeffery He on 15/4/20.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import "TTMSegmentedButton.h"
#import "UIImage+TTMAddtion.h"
#define kRadio 0.95f
#define kImageX 10.f
#define kImageH 0.5f

@interface TTMSegmentedButton ()

@property (nonatomic, weak) UIView *dividingView;

@end

@implementation TTMSegmentedButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *dividingView = [[UIView alloc] init];
    dividingView.backgroundColor = [UIColor lightGrayColor];
    dividingView.alpha = 0.7f;
    [self addSubview:dividingView];
    self.dividingView = dividingView;
    
    [self setImage:nil forState:UIControlStateNormal];
    [self setImage:[UIImage resizedImageWithName:@"navigation_bg"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat dividingW = 0.8f;
    CGFloat dividingX = self.width - dividingW;
    CGFloat dividingY = 10.0f;
    CGFloat dividingH = self.frame.size.height - dividingY * 2;
    self.dividingView.frame = CGRectMake(dividingX, dividingY, dividingW, dividingH);
}

- (void)setIsShowDividing:(BOOL)isShowDividing {
    _isShowDividing = isShowDividing;
    self.dividingView.hidden = isShowDividing;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0.0f;
    CGFloat titleY = 0.0f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * kRadio;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

// 底部图片
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = kImageX;
    CGFloat imageY = contentRect.size.height - kImageH;
    CGFloat imageW = contentRect.size.width - imageX * 2;
    CGFloat imageH = kImageH;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end

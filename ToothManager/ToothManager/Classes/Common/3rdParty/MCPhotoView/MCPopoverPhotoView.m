//
//  MCPopoverPhotoView.m
//  MerchantClient
//
//  Created by thc on 15/4/27.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import "MCPopoverPhotoView.h"

#define kArrowHeight 10.f
#define kRowHeight 44.f
#define kTitleFontSize 16.f

@interface MCPopoverPhotoView ()

@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIButton *handerView;

@end

@implementation MCPopoverPhotoView

- (instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles {
    if (self = [super init]) {
        self.showPoint = point;
        self.titleArray = titles;
        self.frame = [self viewFrame];
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bgImageView.image = [UIImage imageNamed:@"schedule_take_photo_bg"];
    [self addSubview:bgImageView];
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0 , i * kRowHeight + kArrowHeight,
                                                                           self.width, kRowHeight)];
        [titleButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
    }
}

- (void)buttonAction:(UIButton *)button {
    [self dismiss:YES];
    self.selectRowAtIndex(button.tag);
}

- (void)show {
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    self.layer.anchorPoint = CGPointMake(self.frame.size.width / self.frame.size.width,
                                         arrowPoint.y / self.frame.size.height);
    self.frame = [self viewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
}

- (CGRect)viewFrame
{
    CGRect frame = CGRectZero;
    frame.origin = self.showPoint;
    
    for (NSString *title in self.titleArray) {
        NSDictionary *attriDic = @{NSFontAttributeName : [UIFont systemFontOfSize:kTitleFontSize]};
        CGRect strRect = [title boundingRectWithSize:CGSizeMake(300, 100)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attriDic
                                             context:nil];
        CGFloat width = strRect.size.width + 30;
        frame.size.width = MAX(width, frame.size.width);
    }
    frame.size.height = kRowHeight * self.titleArray.count + kArrowHeight;
    return frame;
}

@end

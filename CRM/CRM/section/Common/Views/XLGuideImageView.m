//
//  XLGuideImageView.m
//  CRM
//
//  Created by Argo Zhang on 16/2/24.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLGuideImageView.h"

@interface XLGuideImageView ()

@property (nonatomic, copy)DismissBlock dismissBlock;

@end

@implementation XLGuideImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super initWithImage:image]) {
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

- (void)showInView:(UIView *)view dismissBlock:(DismissBlock)dismissBlock{
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.frame = view.bounds;
    self.dismissBlock = dismissBlock;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)showInView:(UIView *)view autoDismiss:(BOOL)autoDismiss dismissBlock:(DismissBlock)dismissBlock{
    self.userInteractionEnabled = NO;
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.frame = view.bounds;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.35 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (dismissBlock) {
                dismissBlock();
            }
        }];
    }];
}



@end

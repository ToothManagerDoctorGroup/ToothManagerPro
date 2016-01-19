//
//  XLGuideView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLGuideView.h"
#import "UIImage+TTMAddtion.h"

@interface XLGuideView ()

@property (nonatomic, weak)UIView *parentView;

@property (nonatomic, strong)UIImageView *superMaskView;
/**
 *  填充视图
 */
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *rightMaskView;
//高亮显示的frame
@property (nonatomic, assign)CGRect maskViewFrame;
//步骤一所需的子视图
@property (nonatomic, strong)UIImageView *stepOne_text;//内容
@property (nonatomic, strong)UIImageView *stepOne_arrow;//箭头

@end

@implementation XLGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.superMaskView];
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        [self addSubview:self.leftMaskView];
        [self addSubview:self.rightMaskView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.frame = _parentView.bounds;

    _superMaskView.frame = self.maskViewFrame;
    
    _topMaskView.left = 0;
    _topMaskView.top = 0;
    _topMaskView.height = _superMaskView.top;
    _topMaskView.width = self.width;
    
    _bottomMaskView.left = 0;
    _bottomMaskView.top = _superMaskView.bottom;
    _bottomMaskView.width = self.width;
    _bottomMaskView.height = self.height - _bottomMaskView.top;
    
    _leftMaskView.left = 0;
    _leftMaskView.top = _superMaskView.top;
    _leftMaskView.width = _superMaskView.left;
    _leftMaskView.height = _superMaskView.height;
    
    _rightMaskView.left = _superMaskView.right;
    _rightMaskView.top = _superMaskView.top;
    _rightMaskView.width = self.width - _rightMaskView.left;
    _rightMaskView.height = _superMaskView.height;
    
    if (self.step == XLGuideViewStepOne) {
        _stepOne_arrow.right = self.maskViewFrame.origin.x - 5;
        _stepOne_arrow.bottom = self.maskViewFrame.origin.y + 20;
        _stepOne_text.bottom = _stepOne_arrow.top - 10;
        _stepOne_text.left = 10;
    }
}

- (void)showInView:(UIView *)view maskViewFrame:(CGRect)maskViewFrame {
    self.parentView = view;
    self.maskViewFrame = maskViewFrame;
    
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    //判断点击的位置是否是当前突出显示的位置
    if (touchPoint.x >= self.maskViewFrame.origin.x && touchPoint.x <= self.maskViewFrame.origin.x + self.maskViewFrame.size.width && touchPoint.y >= self.maskViewFrame.origin.y && touchPoint.y) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(guideView:didClickView:step:)]) {
            [self.delegate guideView:self didClickView:self.superview step:self.step];
        }
        [self dismiss];
    }
}

#pragma mark - 设置执行步骤
- (void)setStep:(XLGuideViewStep)step{
    _step = step;
    
    if (step == XLGuideViewStepOne) {
        [self addSubview:self.stepOne_text];
        [self addSubview:self.stepOne_arrow];
    }
}

#pragma mark - 懒加载数据
- (UIView *)topMaskView {
    if (!_topMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _topMaskView = view;
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _bottomMaskView = view;
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _leftMaskView = view;
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _rightMaskView = view;
    }
    return _rightMaskView;
}

- (UIImageView *)superMaskView {
    if (!_superMaskView) {
        UIImage *image = [UIImage imageNamed:@"guide_circle"];
        image = [image maskImage:[[UIColor blackColor] colorWithAlphaComponent:0.71]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _superMaskView = imageView;
    }
    return _superMaskView;
}
#pragma mark - 第一步所需的子视图
- (UIImageView *)stepOne_text{
    if (!_stepOne_text) {
        UIImage *image = [UIImage imageNamed:@"guide_text"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepOne_text = imageView;
    }
    return _stepOne_text;
}

- (UIImageView *)stepOne_arrow{
    if (!_stepOne_arrow) {
        UIImage *image = [UIImage imageNamed:@"guide_arrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepOne_arrow = imageView;
    }
    return _stepOne_arrow;
}

#pragma mark - 第二步所需的子视图
#pragma mark - 第三步所需的子视图
#pragma mark - 第四步所需的子视图

@end

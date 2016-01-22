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
//步骤二所需的子视图
@property (nonatomic, strong)UIImageView *stepTwo_arrow;
//步骤三所需的子视图
@property (nonatomic, strong)UIImageView *stepThree_glass1;
@property (nonatomic, strong)UIImageView *stepThree_glass2;
@property (nonatomic, strong)UIImageView *stepThree_glass3;
@property (nonatomic, strong)UIImageView *stepThree_text1;
@property (nonatomic, strong)UIImageView *stepThree_text2;
@property (nonatomic, strong)UIImageView *stepThree_text3;
//步骤四所需的子视图
@property (nonatomic, strong)UIImageView *stepFour_text;
@property (nonatomic, strong)UIImageView *stepFour_arrow;

@end

@implementation XLGuideView

- (void)removeAllView{
    self.superMaskView = nil;
    self.topMaskView = nil;
    self.bottomMaskView = nil;
    self.leftMaskView = nil;
    self.rightMaskView = nil;
    self.stepOne_text = nil;
    self.stepOne_arrow = nil;
    //步骤二所需的子视图
    self.stepTwo_arrow = nil;
    //步骤三所需的子视图
    self.stepThree_glass1 = nil;
    self.stepThree_glass2 = nil;
    self.stepThree_glass3 = nil;
    self.stepThree_text1 = nil;
    self.stepThree_text2 = nil;
    self.stepThree_text3 = nil;
    //步骤四所需的子视图
    self.stepFour_text = nil;
    self.stepFour_arrow = nil;
}

- (void)dealloc{
    [self removeAllView];
}

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
    if (self.step == XLGuideViewStepThree) {
        _superMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
    }
    
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
    
    if (self.type == XLGuideViewTypePatient) {
        UIImage *image = nil;
        if (self.step == XLGuideViewStepOne) {
            image = [UIImage imageNamed:@"guide_circle"];
            
            _stepOne_arrow.right = self.maskViewFrame.origin.x - 5;
            _stepOne_arrow.bottom = self.maskViewFrame.origin.y + 20;
            _stepOne_text.bottom = _stepOne_arrow.top - 10;
            _stepOne_text.left = 10;
        }else if (self.step == XLGuideViewStepTwo){
            image = [UIImage imageNamed:@"guide_click2"];
            //获取第一步的frame
            CGRect stepOneFrame = CGRectMake((kScreenWidth - 49) / 2, kScreenHeight - 49, kScreenWidth / 5 - 15, 49);
            
            _stepOne_arrow.right = stepOneFrame.origin.x - 5;
            _stepOne_arrow.bottom = stepOneFrame.origin.y + 20;
            _stepOne_text.bottom = _stepOne_arrow.top - 10;
            _stepOne_text.left = 10;
            _stepTwo_arrow.left = stepOneFrame.origin.x + stepOneFrame.size.width;
            _stepTwo_arrow.bottom = stepOneFrame.origin.y + 35;
        }else if (self.step == XLGuideViewStepThree){
            
            CGFloat navHeight = 64;
            _stepThree_glass1.left = 60 - 15 + kScreenWidth;
            _stepThree_glass1.top = 80 + navHeight - 14;
            _stepThree_glass2.left = 2 + kScreenWidth;
            _stepThree_glass2.top = 350 + navHeight + 3;
            _stepThree_glass3.left = 2 + kScreenWidth;
            _stepThree_glass3.top = 395 + navHeight + 3;
            _stepThree_text1.top = _stepThree_glass1.bottom + 10;
            _stepThree_text1.left = _stepThree_glass1.left + 30 + kScreenWidth;
            _stepThree_text2.top = _stepThree_glass2.top + 10;
            _stepThree_text2.left = _stepThree_glass2.right + 5 + kScreenWidth;
            _stepThree_text3.top = _stepThree_glass3.bottom - 10;
            _stepThree_text3.left = _stepThree_glass3.right + 5 + kScreenWidth;
            
            _stepFour_arrow.left = self.maskViewFrame.size.width - 20;
            _stepFour_arrow.bottom = self.maskViewFrame.origin.y - 3;
            _stepFour_text.left = _stepFour_arrow.left - 20;
            _stepFour_text.bottom = _stepFour_arrow.top - 5;
            
            [UIView animateWithDuration:.5 animations:^{
                _stepThree_glass1.left = 60 - 15;
                _stepThree_text1.left = _stepThree_glass1.left + 30;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 animations:^{
                    _stepThree_glass2.left = 2;
                    _stepThree_text2.left = _stepThree_glass2.right + 5;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.5 animations:^{
                        _stepThree_glass3.left = 2;
                        _stepThree_text3.left = _stepThree_glass3.right + 5;
                    } completion:^(BOOL finished) {
//                        //添加点击事件
//                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//                        [self addGestureRecognizer:tap];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self addAnimationWithImage:image];
                        });
                    }];
                }];
            }];
        }else if (self.step == XLGuideViewStepFour){
            
            _stepFour_arrow.left = self.maskViewFrame.size.width - 20;
            _stepFour_arrow.bottom = self.maskViewFrame.origin.y - 3;
            _stepFour_text.left = _stepFour_arrow.left - 20;
            _stepFour_text.bottom = _stepFour_arrow.top - 5;
        }
    
        if (!CGRectIsEmpty(self.maskViewFrame)) {
            image = [image maskImage:[[UIColor blackColor] colorWithAlphaComponent:0.71]];
            _superMaskView.image = image;
        }
    }
}

#pragma mark - 添加移出动画
- (void)addAnimationWithImage:(UIImage *)image{
    [UIView animateWithDuration:.5 animations:^{
        _stepThree_glass1.left = 60 - 15 - kScreenWidth;
        _stepThree_text1.left = _stepThree_glass1.left + 30 - kScreenWidth;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            _stepThree_glass2.left = 2 - kScreenWidth;
            _stepThree_text2.left = _stepThree_glass2.right + 5 - kScreenWidth;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 animations:^{
                _stepThree_glass3.left = 2 - kScreenWidth;
                _stepThree_text3.left = _stepThree_glass3.right + 5 - kScreenWidth;
            } completion:^(BOOL finished) {
                self.superMaskView.hidden = YES;
                    //显示第四步引导页
                    [_stepThree_glass1 removeFromSuperview];
                    [_stepThree_glass2 removeFromSuperview];
                    [_stepThree_glass3 removeFromSuperview];
                    [_stepThree_text1 removeFromSuperview];
                    [_stepThree_text2 removeFromSuperview];
                    [_stepThree_text3 removeFromSuperview];
                    
                    self.stepFour_arrow.hidden = NO;
                    self.stepFour_text.hidden = NO;
            }];
        }];
    }];
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
    if (touchPoint.x >= self.maskViewFrame.origin.x && touchPoint.x <= self.maskViewFrame.origin.x + self.maskViewFrame.size.width && touchPoint.y >= self.maskViewFrame.origin.y && touchPoint.y <= self.maskViewFrame.origin.y + self.maskViewFrame.size.height) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(guideView:didClickView:step:)]) {
            [self.delegate guideView:self didClickView:self.superMaskView step:self.step];
        }
        [self dismiss];
    }
}

#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guideView:didClickView:step:)]) {
        [self.delegate guideView:self didClickView:self.superMaskView step:self.step];
    }
    [self dismiss];
}

#pragma mark - 设置执行步骤
- (void)setStep:(XLGuideViewStep)step{
    _step = step;
    
    if (self.type == XLGuideViewTypePatient) {
        if (step == XLGuideViewStepOne) {
            [self addSubview:self.stepOne_text];
            [self addSubview:self.stepOne_arrow];
        }else if(step == XLGuideViewStepTwo){
            [self addSubview:self.stepOne_text];
            [self addSubview:self.stepOne_arrow];
            [self addSubview:self.stepTwo_arrow];
        }else if (step == XLGuideViewStepThree){
            [self addSubview:self.stepThree_glass1];
            [self addSubview:self.stepThree_glass2];
            [self addSubview:self.stepThree_glass3];
            [self addSubview:self.stepThree_text1];
            [self addSubview:self.stepThree_text2];
            [self addSubview:self.stepThree_text3];
            
            [self addSubview:self.stepFour_arrow];
            [self addSubview:self.stepFour_text];
            
            //隐藏
            self.stepFour_arrow.hidden = YES;
            self.stepFour_text.hidden = YES;
            
        }else if (step == XLGuideViewStepFour){
            [self addSubview:self.stepFour_arrow];
            [self addSubview:self.stepFour_text];
        }
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
        UIImageView *imageView = [[UIImageView alloc] init];
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
- (UIImageView *)stepTwo_arrow{
    if (!_stepTwo_arrow) {
        UIImage *image = [UIImage imageNamed:@"guide_arrow2"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepTwo_arrow = imageView;
    }
    return _stepTwo_arrow;
}

#pragma mark - 第三步所需的子视图
- (UIImageView *)stepThree_glass1{
    if (!_stepThree_glass1) {
        UIImage *image = [UIImage imageNamed:@"guide_kuang1"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_glass1 = imageView;
    }
    return _stepThree_glass1;
}
- (UIImageView *)stepThree_glass2{
    if (!_stepThree_glass2) {
        UIImage *image = [UIImage imageNamed:@"guide_kuang2"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_glass2 = imageView;
    }
    return _stepThree_glass2;
}
- (UIImageView *)stepThree_glass3{
    if (!_stepThree_glass3) {
        UIImage *image = [UIImage imageNamed:@"guide_kuang3"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_glass3 = imageView;
    }
    return _stepThree_glass3;
}

- (UIImageView *)stepThree_text1{
    if (!_stepThree_text1) {
        UIImage *image = [UIImage imageNamed:@"guide_text1"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_text1 = imageView;
    }
    return _stepThree_text1;
}

- (UIImageView *)stepThree_text2{
    if (!_stepThree_text2) {
        UIImage *image = [UIImage imageNamed:@"guide_text2"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_text2 = imageView;
    }
    return _stepThree_text2;
}

- (UIImageView *)stepThree_text3{
    if (!_stepThree_text3) {
        UIImage *image = [UIImage imageNamed:@"guide_text3"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepThree_text3 = imageView;
    }
    return _stepThree_text3;
}
#pragma mark - 第四步所需的子视图
- (UIImageView *)stepFour_arrow{
    if (!_stepFour_arrow) {
        UIImage *image = [UIImage imageNamed:@"guide_arrow4"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepFour_arrow = imageView;
    }
    return _stepFour_arrow;
}

- (UIImageView *)stepFour_text{
    if (!_stepFour_text) {
        UIImage *image = [UIImage imageNamed:@"guide_text4"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _stepFour_text = imageView;
    }
    return _stepFour_text;
}


@end

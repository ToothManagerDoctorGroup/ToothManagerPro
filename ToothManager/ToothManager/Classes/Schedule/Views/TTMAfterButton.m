//
//  TTMAfterButton.m
//  ToothManager
//

#import "TTMAfterButton.h"

#define kSemicircleW 110.f //半圆的宽度
#define kImageW 17.f
#define kImageH kImageW
#define kMargin 10.f
#define kButtonW ((ScreenWidth - kSemicircleW - 4 * kMargin) / 2)
#define kButtonH 30.f
#define kTitleW (kButtonW - kImageW - kMargin)

@implementation TTMAfterButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    [self setTitleColor:MainColor forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self setTitle:@"后一天" forState:UIControlStateNormal];
    
    UIImage *arrowImage = [UIImage imageNamed:@"schedule_right_arrow"];
    [self setImage:arrowImage forState:UIControlStateNormal];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 0, kTitleW, kButtonH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(kTitleW + kMargin, (kButtonH - kImageH) / 2, kImageW, kImageH);
}

@end

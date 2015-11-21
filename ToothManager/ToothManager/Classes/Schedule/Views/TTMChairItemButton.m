//
//  TTMChairItemButton.m
//  ToothManager
//

#import "TTMChairItemButton.h"

#define kFontSize 15
#define kTitlenW 44.f
#define kTitleH kTitlenW

@interface TTMChairItemButton ()

@property (nonatomic, weak)   UIView *hSeparatorView;

@end

@implementation TTMChairItemButton

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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:MainColor forState:UIControlStateHighlighted];
    [self setTitleColor:MainColor forState:UIControlStateSelected];
    
    // 水平分隔线
    UIView *hSeparatorView = [[UIView alloc] init];
    hSeparatorView.backgroundColor = TableViewCellSeparatorColor;
    hSeparatorView.alpha = TableViewCellSeparatorAlpha;
    [self addSubview:hSeparatorView];
    self.hSeparatorView = hSeparatorView;
}

- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(0, 0, kTitlenW, kTitleH);
    self.hSeparatorView.frame = CGRectMake(self.width - TableViewCellSeparatorHeight, 0,
                                           TableViewCellSeparatorHeight, self.height);
}

@end

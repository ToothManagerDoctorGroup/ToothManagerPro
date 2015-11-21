//
//  TTMChairNoScrollView.m
//  ToothManager
//

#import "TTMChairNoScrollView.h"
#import "TTMChairItemButton.h"
#import "TTMChairModel.h"

#define kItemH self.height
#define kItemW kItemH

@interface TTMChairNoScrollView ()

@property (nonatomic, weak)   TTMChairItemButton *chairNoButton; // 椅号
@property (nonatomic, weak)   UIScrollView *scrollView;
@property (nonatomic, weak)   UIView *hSeparatorView; // 水平分隔线
@property (nonatomic, weak)   UIButton *rightButton; // 向右滚动按钮

@end

@implementation TTMChairNoScrollView

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
    self.backgroundColor = [UIColor whiteColor];
    
    TTMChairItemButton *chairNoButton = [[TTMChairItemButton alloc] init];
    [chairNoButton setTitle:@"椅位" forState:UIControlStateNormal];
    [chairNoButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self addSubview:chairNoButton];
    self.chairNoButton = chairNoButton;
    
    UIView *hSeparatorView = [[UIView alloc] init];
    hSeparatorView.backgroundColor = TableViewCellSeparatorColor;
    hSeparatorView.alpha = TableViewCellSeparatorAlpha;
    [self addSubview:hSeparatorView];
    self.hSeparatorView = hSeparatorView;
    
    UIScrollView *scrollView =[[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"schedule_scroll_right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    self.rightButton = rightButton;
}
/**
 *  设置椅位数据
 *
 *  @param chairNoArray 椅位数据
 */
- (void)setChairNoArray:(NSArray *)chairNoArray {
    _chairNoArray = chairNoArray;
    for (NSUInteger i = 0; i < chairNoArray.count; i ++) {
        TTMChairModel *model = chairNoArray[i];
        
        TTMChairItemButton *item = [[TTMChairItemButton alloc] init];
        item.chairInfo = model;
        [item setTitle:model.seat_name forState:UIControlStateNormal];
        item.frame = CGRectMake(i * kItemW, 0, kItemW, kItemH);
        [item addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:item];
        
        if (i == 0) {
            item.selected = YES;
        }
    }
    self.scrollView.contentSize = CGSizeMake(chairNoArray.count * kItemW, kItemH);
}

- (void)layoutSubviews {
    self.chairNoButton.frame = CGRectMake(0, 0, kItemW, kItemH);
    self.hSeparatorView.frame = CGRectMake(0, kItemH - TableViewCellSeparatorHeight,
                                           ScreenWidth, TableViewCellSeparatorHeight);
    self.scrollView.frame = CGRectMake(self.chairNoButton.right, 0, ScreenWidth - 2 * kItemW, kItemH);
    self.rightButton.frame = CGRectMake(self.scrollView.right, 0, kItemW, kItemH);
}
/**
 *  点击椅位号事件
 *
 *  @param button button description
 */
- (void)buttonAction:(TTMChairItemButton *)button {
    for (TTMChairItemButton *item in self.scrollView.subviews) {
        if (button == item) {
            item.selected = YES;
        } else {
            item.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(chairNoScrollView:clickedItem:)]) {
        [self.delegate chairNoScrollView:self clickedItem:button];
    }
}

/**
 *  向右滚动按钮事件
 *
 */
- (void)rightButtonAction:(UIButton *)button {
    CGFloat x = self.scrollView.contentOffset.x;
    CGFloat maxX = self.scrollView.contentSize.width - self.scrollView.width; // 最大x
    if (x < maxX) {
        [self.scrollView setContentOffset:CGPointMake(x + kItemW, 0) animated:YES];
    }
}
@end

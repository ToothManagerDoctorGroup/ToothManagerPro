//
//  THCTabBarButtonItem.m
//  THCFramework
//

#import "TTMTabBarButtonItem.h"
#import "TTMTabBarCommon.h"

@interface TTMTabBarButtonItem ()

@property (nonatomic, weak) UILabel *badgeLabel;

@end

@implementation TTMTabBarButtonItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 设置imageView的对齐方式
    self.imageView.contentMode = UIViewContentModeCenter;
    // 设置titleLabel的对齐方式
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置titleLabel的字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:kTabBarButtonItemFontSize];
    // 设置文字的颜色
    [self setTitleColor:kTabBarButtonItemTitleColor forState:UIControlStateNormal];
    [self setTitleColor:kTabBarButtonItemTitleSelectedColor forState:UIControlStateSelected];
    
    // 初始化数字提醒
    [self setupBadgeLabel];
}

- (void)setupBadgeLabel {
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.hidden = YES;
    badgeLabel.layer.cornerRadius = 20 * 0.5;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.adjustsFontSizeToFitWidth = YES;
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.font = [UIFont systemFontOfSize:kTabBarBadgeViewFont];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = kTabBarBadgeViewColor;
    [self addSubview:badgeLabel];
    self.badgeLabel = badgeLabel;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * kTabBarButtonItemRadio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * (1.0 - kTabBarButtonItemRadio);
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * kTabBarButtonItemRadio;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setHighlighted:(BOOL)highlighted {
    // DO Nothing
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    _tabBarItem = tabBarItem;
    [_tabBarItem addObserver:self forKeyPath:@"badgeValue"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (self.tabBarItem.badgeValue.length) {
        self.badgeLabel.hidden = NO;
        CGFloat badgeLabelX = (self.bounds.size.width - kTabBarBadgeViewWH) * 0.5 + kTabBarBadgeViewWH * 0.75;
        self.badgeLabel.frame = CGRectMake(badgeLabelX, kTabBarBadgeViewY, kTabBarBadgeViewWH, kTabBarBadgeViewWH);
        NSInteger number = [self.tabBarItem.badgeValue integerValue];
        if (number > kTabBarBadgeViewMaxNumber) {
            self.badgeLabel.text = kTabBarBadgeViewMaxNumberShow;
        } else {
            self.badgeLabel.text = self.tabBarItem.badgeValue;
        }
        
    } else {
        self.badgeLabel.hidden = YES;
        self.badgeLabel.frame = CGRectZero;
    }
}

- (void)dealloc {
    [self.tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
}

@end

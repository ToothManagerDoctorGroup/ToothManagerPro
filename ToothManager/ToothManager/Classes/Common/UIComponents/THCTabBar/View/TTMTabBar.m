//
//  THCTabBar.m
//  THCFramework
//

#import "TTMTabBar.h"
#import "TTMTabBarButtonItem.h"
#import "TTMTabBarCommon.h"

@interface TTMTabBar ()

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation TTMTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置TabBar的背景
        self.backgroundColor = kTabBarBackgroundColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / count;
    CGFloat buttonH = self.frame.size.height;
    for (int i = 0; i < count; i++) {
        TTMTabBarButtonItem *button = self.subviews[i];
        button.tag = i;
        button.frame = CGRectMake(i * buttonW, buttonY, buttonW, buttonH);
    }
}

- (void)addButtonWithTabBarItem:(UITabBarItem *)tabBarItem {
    TTMTabBarButtonItem *button = [[TTMTabBarButtonItem alloc] init];
    [button setTitle:tabBarItem.title forState:UIControlStateNormal];
    [button setImage:tabBarItem.image forState:UIControlStateNormal];
    [button setImage:tabBarItem.selectedImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    button.tabBarItem = tabBarItem;
    
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabBar:fromIndex:toIndex:)]) {
        [self.delegate tabBar:self fromIndex:self.selectedButton.tag toIndex:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end

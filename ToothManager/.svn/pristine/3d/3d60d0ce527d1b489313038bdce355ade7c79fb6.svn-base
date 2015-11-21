//
//  MCSegmentedView.m
//  MerchantClient
//
//  Created by Jeffery He on 15/4/20.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import "TTMSegmentedView.h"
#import "TTMSegmentedButton.h"

#define kSegmentViewH 44.0f
#define kMaxShowCount 4 // 最大显示数
#define kMaxItemWidth (ScreenWidth / kMaxShowCount) // item最大宽度

#define kBottomLineColor MainColor
#define kFontSize 15

@interface TTMSegmentedView ()

@property (nonatomic, strong) TTMSegmentedButton *selectedButton;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation TTMSegmentedView

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

- (void)setFrame:(CGRect)frame {
    frame.size.height = kSegmentViewH;
//    frame.size.width = ScreenWidth;
    [super setFrame:frame];
}

- (void)setup {
    
    self.backgroundColor = RGBColor(254.0f, 254.0f, 254.0f);
    
    // 底部的横线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat lineHeight = 1.0f;
    bottomLine.frame = CGRectMake(0.0f, kSegmentViewH - lineHeight, ScreenWidth, lineHeight);
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, kSegmentViewH);
}

- (void)setSegmentedTitles:(NSArray *)segmentedTitles {
    _segmentedTitles = segmentedTitles;
    [self setupTitlesWithDataArray:segmentedTitles];
}

- (void)setSegmentControllers:(NSArray *)segmentControllers {
    _segmentControllers = segmentControllers;
    [self setupTitlesWithDataArray:segmentControllers];
}

- (void)setupTitlesWithDataArray:(NSArray *)array {
    NSUInteger count = array.count;
    CGFloat viewWidth = 0;
    if (count > kMaxShowCount) {
        viewWidth = kMaxItemWidth;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(count * kMaxItemWidth, kSegmentViewH);
    } else {
        viewWidth = self.frame.size.width / count;
    }
    
    for (NSUInteger i = 0; i < count; i++) {
        id object = array[i];
        NSString *title = nil;
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController *controller = object;
            title = controller.title;
        } else if ([object isKindOfClass:[NSString class]]) {
            title = object;
        }
        TTMSegmentedButton *button = [TTMSegmentedButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        CGFloat buttonX = i * viewWidth;
        CGFloat buttonY = 0.0f;
        CGFloat buttonH = kSegmentViewH;
        button.frame = CGRectMake(buttonX, buttonY, viewWidth, buttonH);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:MainColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            self.selectedButton = button;
            [self buttonClick:button];
        }
        
        if (i < count) {
            button.isShowDividing = YES;
        }
        [self.scrollView addSubview:button];
    }
    
}

- (void)buttonClick:(TTMSegmentedButton *)button {
    if ([self.delegate respondsToSelector:@selector(segmentedViewDidSelected:fromIndex:toIndex:)]) {
        [self.delegate segmentedViewDidSelected:self fromIndex:self.selectedButton.tag toIndex:button.tag];
        self.selectedIndex = button.tag;
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end

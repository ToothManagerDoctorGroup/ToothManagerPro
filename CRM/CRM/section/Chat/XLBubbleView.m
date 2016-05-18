//
//  XLBubbleView.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBubbleView.h"

#import <Masonry.h>

@implementation XLBubbleView

@synthesize backgroundImageView = _backgroundImageView;

- (instancetype)initWithMargin:(UIEdgeInsets)margin{
    if (self = [super init]) {
        _margin = margin;
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundImageView];
        
        //设置约束
        WS(weakSelf);
        [_backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
    return _backgroundImageView;
}

@end

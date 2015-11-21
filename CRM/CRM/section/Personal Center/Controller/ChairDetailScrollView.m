//
//  ChairDetailScrollView.m
//  CRM
//
//  Created by Argo Zhang on 15/11/12.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ChairDetailScrollView.h"
#import "ChairDetailView.h"

@interface ChairDetailScrollView ()<UIScrollViewDelegate>

@end

@implementation ChairDetailScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}
#pragma mark -初始化方法
- (void)setUpSubViews{
    //设置当前scrollView的基本属性
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
}


#pragma mark -数据加载时，设置子控件
- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    
    //设置偏移量
    self.contentSize = CGSizeMake(self.frame.size.width * self.dataList.count, self.frame.size.height);
    
    for (int i = 0; i < self.dataList.count; i++) {
        ChairDetailView *view = [ChairDetailView instanceView];
        view.frame = CGRectMake(i * kScreenWidth, 0, self.frame.size.width, self.frame.size.height);
        view.model = self.dataList[i];
        [self addSubview:view];
    }
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger index = (offset + kScreenWidth * 0.5) / kScreenWidth;
    if ([self.chairDelegate respondsToSelector:@selector(chairDetailScrollView:didSelectedIndex:)]) {
        [self.chairDelegate chairDetailScrollView:self didSelectedIndex:index];
    }
}

@end

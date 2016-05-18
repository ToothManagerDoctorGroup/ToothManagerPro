//
//  XLFilterStateView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/6.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLFilterStateView;
@protocol XLFilterStateViewDelegate <NSObject>

@optional
- (void)filterStateView:(XLFilterStateView *)stateView didChooseState:(NSInteger)state;

@end

@interface XLFilterStateView : UIView

@property (nonatomic, weak)id<XLFilterStateViewDelegate> delegate;

- (instancetype)initWithSourceArray:(NSArray *)sourceArray;

- (CGFloat)fixHeight;

- (void)reset;

@end

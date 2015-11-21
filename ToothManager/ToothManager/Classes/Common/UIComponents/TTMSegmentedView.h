//
//  MCSegmentedView.h
//  MerchantClient
//
//  Created by Jeffery He on 15/4/20.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TTMSegmentedViewDelegate;

@interface TTMSegmentedView : UIView

@property (nonatomic, strong) NSArray *segmentedTitles;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, weak) id<TTMSegmentedViewDelegate> delegate;

@property (nonatomic, strong) NSArray *segmentControllers;

@property (nonatomic, weak) UIView *bottomLine;

@end

@protocol TTMSegmentedViewDelegate <NSObject>

@required
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end

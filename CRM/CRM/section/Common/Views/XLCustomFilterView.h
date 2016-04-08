//
//  XLCustomFilterView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLCustomFilterViewDelegate;
@protocol XLCustomFilterViewDataSource;

@interface XLCustomFilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<XLCustomFilterViewDataSource>)dataSource delegate:(id<XLCustomFilterViewDelegate>)delegate;

- (void)reloadData;

@property (nonatomic, weak)id<XLCustomFilterViewDelegate> delegate;
@property (nonatomic, weak)id<XLCustomFilterViewDataSource> dataSource;

@end


@protocol XLCustomFilterViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInCustomFilterView:(XLCustomFilterView *)filterView;

- (NSString *)customFilterView:(XLCustomFilterView *)filterView titleForItemAtIndex:(NSUInteger)index;

- (UIView *)customFilterView:(XLCustomFilterView *)filterView viewForItemAtIndex:(NSUInteger)index;

@end

@protocol XLCustomFilterViewDelegate <NSObject>

@optional
- (void)customFilterView:(XLCustomFilterView *)filterView didSelectItem:(NSInteger)index;

@end
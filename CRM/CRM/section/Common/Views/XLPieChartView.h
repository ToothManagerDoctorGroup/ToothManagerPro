//
//  XLPieChartView.h
//  CRM
//
//  Created by Argo Zhang on 16/1/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLPieChartViewDelegate;
@protocol XLPieChartViewDataSource;

@interface XLPieChartView : UIView

@property (nonatomic, assign) id <XLPieChartViewDataSource> datasource;
@property (nonatomic, assign) id <XLPieChartViewDelegate> delegate;

-(void)reloadData;
@end

@protocol XLPieChartViewDelegate <NSObject>

- (CGFloat)centerCircleRadius;

@end

@protocol XLPieChartViewDataSource <NSObject>

@required
- (int)numberOfSlicesInPieChartView:(XLPieChartView *)pieChartView;
- (double)pieChartView:(XLPieChartView *)pieChartView valueForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChartView:(XLPieChartView *)pieChartView colorForSliceAtIndex:(NSUInteger)index;

@optional
- (NSString*)pieChartView:(XLPieChartView *)pieChartView titleForSliceAtIndex:(NSUInteger)index;

@end

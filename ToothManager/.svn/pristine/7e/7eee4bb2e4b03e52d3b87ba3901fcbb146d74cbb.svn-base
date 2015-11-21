//
//  TTMScheduleHeaderView.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMChairModel;
@protocol TTMScheduleHeaderViewDelegate;

/**
 *  日程表headerView
 */
@interface TTMScheduleHeaderView : UIView
/**
 *  代理
 */
@property (nonatomic, assign) id <TTMScheduleHeaderViewDelegate> delegate;
/**
 *  当前日期
 */
@property (nonatomic, strong) NSDate *currentDate;

@end

@protocol TTMScheduleHeaderViewDelegate <NSObject>
/**
 *  返回改变到的日期
 *
 *  @param headerView
 *  @param date       
 */
- (void)headerView:(TTMScheduleHeaderView *)headerView changeToDate:(NSDate *)date;
/**
 *  返回改变到的椅位
 *
 *  @param headerView
 *  @param chair
 */
- (void)headerView:(TTMScheduleHeaderView *)headerView changeToChair:(TTMChairModel *)chair;
/**
 *  点击半圆日期
 *
 *  @param headerView
 */
- (void)clickSemicircleWithHeaderView:(TTMScheduleHeaderView *)headerView;
@end
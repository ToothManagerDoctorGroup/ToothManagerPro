//
//  TTMCalendarController.h
//  ToothManager
//

#import "TTMBaseColorController.h"

@protocol TTMCalendarControllerDelegate;
/**
 *  日程表视图
 */
@interface TTMCalendarController : TTMBaseColorController
/**
 *  代理
 */
@property (nonatomic, weak)   id<TTMCalendarControllerDelegate> delegate;

@end

@protocol TTMCalendarControllerDelegate <NSObject>
/**
 *  返回选中日期
 */
- (void)calendarController:(TTMCalendarController *)calendarController selectedDate:(NSDate *)selectedDate;

@end
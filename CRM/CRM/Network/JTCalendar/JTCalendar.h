//
//  JTCalendar.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendarViewDataSource.h"
#import "JTCalendarAppearance.h"

#import "JTCalendarMenuView.h"
#import "JTCalendarContentView.h"

@protocol JTCalendarDelegate <NSObject>

@optional
- (void)calendar:(JTCalendar *)calendar startDate:(NSDate *)startDate endDate:(NSDate *)endDate currentDate:(NSDate *)currentDate isWeekMode:(BOOL)isWeekMode;

@end

@interface JTCalendar : NSObject<UIScrollViewDelegate>

@property (weak, nonatomic) JTCalendarMenuView *menuMonthsView;
@property (weak, nonatomic) JTCalendarContentView *contentView;

@property (weak, nonatomic) id<JTCalendarDataSource> dataSource;
@property (nonatomic, weak)id<JTCalendarDelegate> dateDelegate;

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *currentDateSelected;

- (JTCalendarAppearance *)calendarAppearance;

- (void)reloadData;
- (void)reloadAppearance;

- (void)loadPreviousMonth;
- (void)loadNextMonth;

@end

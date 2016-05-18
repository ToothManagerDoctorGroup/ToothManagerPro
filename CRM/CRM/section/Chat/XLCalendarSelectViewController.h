//
//  XLCalendarSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

/**
 *  日期选择
 */
@class XLCalendarSelectViewController,Patient;
@protocol XLCalendarSelectViewControllerDelegate <NSObject>

@optional
- (void)calendarSelectVC:(XLCalendarSelectViewController *)calendarSelectVC didSelectDate:(NSDate *)date;

@end
@interface XLCalendarSelectViewController : TimViewController

@property (nonatomic, strong)Patient *patient;

@property (nonatomic, weak)id<XLCalendarSelectViewControllerDelegate> delegate;

@end

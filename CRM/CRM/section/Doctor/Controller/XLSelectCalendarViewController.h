//
//  XLSelectCalendarViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

typedef NS_ENUM(NSInteger, XLSelectCalendarViewControllerType) {
    XLSelectCalendarViewControllerTypePlant,//种植时间选择
    XLSelectCalendarViewControllerTypeRepair,//修复时间选择
};
/**
 *  选择时间
 */
@class XLSelectCalendarViewController;
@protocol XLSelectCalendarViewControllerDelegate <NSObject>

@optional
- (void)selectCalendarViewController:(XLSelectCalendarViewController *)calendarVc didSelectDateStr:(NSString *)dateStr type:(XLSelectCalendarViewControllerType)type;

@end
@interface XLSelectCalendarViewController : TimViewController

@property (nonatomic, weak)id<XLSelectCalendarViewControllerDelegate> delegate;
@property (nonatomic, assign)XLSelectCalendarViewControllerType type;

@end

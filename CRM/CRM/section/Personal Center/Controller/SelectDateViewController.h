//
//  SelectDateViewController.h
//  CRM
//
//  Created by doctor on 15/3/11.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "VRGCalendarView.h"

@protocol SelectDateViewControllerDelegate;
@interface SelectDateViewController : TimViewController<VRGCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    VRGCalendarView *m_calendar;
    UITableView *m_tableView;
    CGFloat headerHeight;
    NSMutableArray *timeArray;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic,copy) NSString *from;
@property (nonatomic,assign) id <SelectDateViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *reservedPatientId;
@end

@protocol SelectDateViewControllerDelegate <NSObject>

- (void)didSelectTime:(NSString *)time from:(NSString *)from;

@end

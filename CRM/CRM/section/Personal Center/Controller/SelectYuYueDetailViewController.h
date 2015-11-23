//
//  SelectYuYueDetailViewController.h
//  CRM
//
//  Created by lsz on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "VRGCalendarView.h"
#import "TimPickerTextField.h"

@interface SelectYuYueDetailViewController : TimViewController<VRGCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    VRGCalendarView *m_calendar;
    UITableView *m_tableView;
    CGFloat headerHeight;
    NSMutableArray *timeArray;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic,strong) NSArray *clinicNameArray;
@property (nonatomic,strong) NSArray *clinicIdArray;


@end

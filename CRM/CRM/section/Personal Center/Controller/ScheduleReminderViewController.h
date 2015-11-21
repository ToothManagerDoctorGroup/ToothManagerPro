//
//  ScheduleReminderViewController.h
//  CRM
//
//  Created by doctor on 14/10/23.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@interface ScheduleReminderViewController : TimViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *dayLabel;
    UILabel *weekLabel;
    UITableView *m_tableView;
    NSDateFormatter *dateFormatter;
}
@end

//
//  MyScheduleReminderViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@interface MyScheduleReminderViewController : TimViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *m_tableView;
    NSDateFormatter *dateFormatter;
}

@end

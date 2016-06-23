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
@property (nonatomic, strong)UILabel *messageCountLabel;//消息提示框

@property (nonatomic, assign)BOOL executeSyncAction;//是否执行同步操作
@end

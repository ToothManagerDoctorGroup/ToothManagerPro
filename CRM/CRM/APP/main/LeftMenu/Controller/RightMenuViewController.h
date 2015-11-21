//
//  RightMenuViewController.h
//  CRM
//
//  Created by TimTiger on 9/9/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

@class TimNavigationViewController;
@interface RightMenuViewController : TimTableViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_tableView;
    NSArray *menuArray;
    NSArray *menuImageArray;
}
@property (strong, nonatomic) TimNavigationViewController *personalCenterNav;

@end

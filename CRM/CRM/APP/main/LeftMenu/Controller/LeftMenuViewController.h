//
//  LeftMenuViewController.h
//  CRM
//
//  Created by doctor on 14-6-26.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "TimNavigationViewController.h"

@interface LeftMenuViewController : TimViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_tableView;
    NSArray *menuArray;
    NSArray *menuImageArray;
}
@property (strong, nonatomic) TimNavigationViewController *personalCenterNav;
@end

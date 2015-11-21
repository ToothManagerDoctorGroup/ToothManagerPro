//
//  PersonalCenterViewController.h
//  CRM
//
//  Created by TimTiger on 5/12/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimViewController.h"

#import <UIKit/UIKit.h>

@interface PersonalCenterViewController : TimViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * perCenTableView;
    NSArray * titleArray;
}
@property (nonatomic, copy)NSString * version;
@end

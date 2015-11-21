//
//  DoctorInfoViewController.h
//  CRM
//
//  Created by TimTiger on 5/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@interface DoctorInfoViewController : TimViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    UIView * detailInfoView;
}

@property (nonatomic,copy) NSString *repairDoctorID;
@property (nonatomic,assign) BOOL ifDoctorInfo;
@end

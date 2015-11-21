//
//  RepairDoctorDetailViewController.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@interface RepairDoctorDetailViewController : TimViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    UIView * detailInfoView;
}

@property (nonatomic,copy) NSString *repairDoctorID;

@end

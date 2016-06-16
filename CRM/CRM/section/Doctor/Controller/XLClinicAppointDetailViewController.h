//
//  XLClinicAppointDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

/**
 *  诊所预约详情
 */
@class LocalNotification;
@interface XLClinicAppointDetailViewController : TimTableViewController

@property (nonatomic, strong)LocalNotification *localNoti;

@end

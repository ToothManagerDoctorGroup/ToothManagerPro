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

@property (nonatomic, assign)BOOL hideCancelButton;//是否隐藏取消预约按钮

@end

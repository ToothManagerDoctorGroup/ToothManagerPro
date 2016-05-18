//
//  XLAddClinicReminderViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/17.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  添加诊所预约
 */
@class Patient,XLClinicModel,XLClinicAppointmentModel;
@interface XLAddClinicReminderViewController : TimTableViewController

@property (nonatomic, strong)XLClinicAppointmentModel *appointModel;
@property (nonatomic, strong)Patient *patient;

@end

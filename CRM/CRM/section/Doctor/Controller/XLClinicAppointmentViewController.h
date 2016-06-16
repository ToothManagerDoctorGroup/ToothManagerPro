//
//  XLClinicAppointmentViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/13.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  诊所预约视图
 */
@class XLClinicModel,Patient;
@interface XLClinicAppointmentViewController : TimViewController

@property (nonatomic, strong)XLClinicModel *clinicModel;

@property (nonatomic, strong)Patient *patient;

@end

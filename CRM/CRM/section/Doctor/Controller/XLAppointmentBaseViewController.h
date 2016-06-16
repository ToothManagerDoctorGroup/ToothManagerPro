//
//  XLAppointmentBaseViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/5/16.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  预约基本视图
 */
@class Patient;
@interface XLAppointmentBaseViewController : TimViewController

@property (nonatomic, strong)Patient *patient;

@end

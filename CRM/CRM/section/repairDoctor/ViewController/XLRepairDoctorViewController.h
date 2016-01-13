//
//  XLRepairDoctorViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 @brief 修复医生页面.
 */
@class RepairDoctor;
@protocol XLRepairDoctorViewControllerDelegate <NSObject>

@optional
- (void)didSelectedRepairDoctor:(RepairDoctor *)doctor;
@end

@interface XLRepairDoctorViewController : TimViewController

@property (weak,nonatomic) id <XLRepairDoctorViewControllerDelegate> delegate;


@end

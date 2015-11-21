//
//  RepairDoctorViewController.h
//  CRM
//
//  Created by ANine on 4/21/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
/**
 @brief 修复医生页面.
 
 @discussion <#some notes or alert with this class#>
 */
@class RepairDoctor;
@protocol RepairDoctorViewControllerDelegate;
@interface RepairDoctorViewController : TimDisplayViewController

@property (weak,nonatomic) id <RepairDoctorViewControllerDelegate> delegate;

@end

@protocol RepairDoctorViewControllerDelegate <NSObject>

- (void)didSelectedRepairDoctor:(RepairDoctor *)doctor;

@end

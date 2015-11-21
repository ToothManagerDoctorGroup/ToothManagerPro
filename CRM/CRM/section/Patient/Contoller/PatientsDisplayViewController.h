//
//  PatientsDisplayViewController.h
//  CRM
//
//  Created by TimTiger on 9/25/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
#import "DBManager.h"

@interface PatientsDisplayViewController : TimDisplayViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;
@property (nonatomic, assign) BOOL isScheduleReminderPush;
@property (nonatomic, assign) BOOL isYuYuePush;

@property (nonatomic,assign) BOOL isTabbarVc;

@end

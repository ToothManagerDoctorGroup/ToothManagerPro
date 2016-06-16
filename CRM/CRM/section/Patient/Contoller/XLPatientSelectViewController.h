//
//  XLPatientSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "DBManager.h"

@interface XLPatientSelectViewController : TimViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;
@property (nonatomic, assign) BOOL isYuYuePush;
@property (nonatomic,assign) BOOL isTabbarVc;

@end

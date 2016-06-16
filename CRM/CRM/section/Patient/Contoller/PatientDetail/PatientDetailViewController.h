//
//  PatientDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@interface PatientDetailViewController : TimViewController

@property (nonatomic,retain) PatientsCellMode *patientsCellMode;

@property (nonatomic, assign)BOOL isNewPatient;//从新增患者跳转


@end


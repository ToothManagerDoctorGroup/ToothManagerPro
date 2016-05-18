//
//  XLGroupPatientDisplayViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/12.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "DBManager.h"
#import "DoctorGroupModel.h"


@interface XLGroupPatientDisplayViewController : TimViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;

@property (nonatomic, strong)DoctorGroupModel *group;
/**
 *  组员数组
 */
//@property (nonatomic, strong)NSArray *GroupMembers;

@end

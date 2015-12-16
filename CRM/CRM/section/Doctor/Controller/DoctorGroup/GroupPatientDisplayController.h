//
//  GroupPatientDisplayController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
#import "DBManager.h"
#import "DoctorGroupModel.h"

@interface GroupPatientDisplayController : TimDisplayViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;

@property (nonatomic, strong)DoctorGroupModel *group;
/**
 *  组员数组
 */
@property (nonatomic, strong)NSArray *GroupMembers;


@end

//
//  XLPatientDisplayViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface XLPatientDisplayViewController : EaseConversationListViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;


/**
 *  查询患者
 *
 *  @param status      患者状态
 *  @param startTime   开始时间
 *  @param endTime     结束时间
 *  @param cureDoctors 治疗医生数组
 */
- (void)requestPatientsWithPatientStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime cureDoctors:(NSArray *)cureDoctors;

@end

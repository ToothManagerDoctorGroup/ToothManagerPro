//
//  XLAutoGetSyncTool.h
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimFramework.h"

@interface XLAutoGetSyncTool : NSObject
Declare_ShareInstance(XLAutoGetSyncTool);

- (void)getDoctorTable;//同步医生信息
- (void)getMaterialTable;//同步耗材信息
- (void)getIntroducerTable;//同步介绍人信息
- (void)getPatientTable;//同步患者信息
- (void)getReserverecordTable;//同步预约信息
- (void)getPatIntrMapTable;//同步患者介绍人信息
- (void)getRepairDoctorTable;//同步修复医生信息
- (void)getCTLibTable; //需要重复下载
- (void)getMedicalCaseTable; //需要重复下载
- (void)getMedicalExpenseTable;//需要重复下载
- (void)getMedicalRecordTable; //需要重复下载
- (void)getPatientConsulationTable;//获取会诊信息
@end

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

- (void)getAllDataShowSuccess:(BOOL)showSuccess;

- (void)getDoctorTable;//同步医生信息
- (void)getMaterialTable;//同步材料信息
- (void)getIntroducerTableHasNext:(BOOL)hasNext;//同步介绍人信息
- (void)getPatientTable;//同步患者信息
- (void)getReserverecordTableHasNext:(BOOL)hasNext;//同步预约信息
- (void)getPatIntrMapTable;//同步患者介绍人信息
- (void)getRepairDoctorTable;//同步修复医生信息

- (void)getCTLibTable; //同步CT信息
- (void)getMedicalCaseTable;   //同步病历信息
- (void)getMedicalExpenseTable; //同步耗材信息
- (void)getMedicalRecordTable;  //同步病历记录信息
- (void)getPatientConsulationTable; //同步会诊信息
@end

//
//  AutoSyncManager.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AutoSyncManager.h"
#import "DBManager+AutoSync.h"
#import "AFNetworkReachabilityManager.h"
#import "CRMHttpRequest+Sync.h"
#import "DBTableMode.h"
#import "CRMHttpRequest+Sync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "XLAutoSyncTool.h"
#import "XLAutoSyncTool+XLInsert.h"
#import "XLAutoSyncTool+XLDelete.h"
#import "CRMHttpRespondModel.h"
#import "DoctorGroupTool.h"

#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "DBManager+RepairDoctor.h"
#import "DBManager+LocalNotification.h"
#import "LocalNotificationCenter.h"
#import "DoctorTool.h"
#import "XLBehaviourModel.h"

@implementation AutoSyncManager
Realize_ShareInstance(AutoSyncManager);

/**
 *  开始自动同步
 */
- (BOOL)startAutoSync{
    [self autoSyncUpdate];
    [self autoSyncInsert];
    [self autoSyncDelete];
    //查询数据库中是否有超过上传次数的数据
    [self postErrorData];
    
    return YES;
}
#pragma mark - 将json字符串转换为字典
- (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

#pragma mark - 开始update类型的数据上传
- (void)autoSyncUpdate{
    //上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败 4:异常数据）
    //查询所有update类型和同步状态为0和3并且上传次数小于50次的数据
    NSArray *syncArray = [[DBManager shareInstance] getInfoListWithPostType:Update syncStatus:@"0,3"];
    if (syncArray.count > 0) {
        for (InfoAutoSync *info in syncArray) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"1" byInfoId:info.info_id];
            
#pragma mark -上传更新后的患者信息
            if ([info.data_type isEqualToString:AutoSync_Patient]) {
                //上传需要更新的患者信息
                Patient *patient = [Patient objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                 [[XLAutoSyncTool shareInstance] editAllNeedSyncPatient:patient success:^(CRMHttpRespondModel *respond) {
                     //上传成功
                     [self updateSuccessWithRespondModel:respond infoModel:info];
                 } failure:^(NSError *error) {
                     //上传失败
                     [self updateFailWithError:error infoModel:info];
                 }];
#pragma mark -上传更新后的材料信息
            }else if ([info.data_type isEqualToString:AutoSync_Material]){
                Material *material = [Material objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncMaterial:material success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的介绍人信息
            }else if ([info.data_type isEqualToString:AutoSync_Introducer]){
                Introducer *introducer = [Introducer objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncIntroducer:introducer success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                   //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的病历信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalCase]){
                MedicalCase *medicalCase = [MedicalCase objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncMedical_case:medicalCase success:^(CRMHttpRespondModel *respond) {
                   //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的ct片信息
            }else if ([info.data_type isEqualToString:AutoSync_CtLib]){
                CTLib *ctLib = [CTLib objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncCt_lib:ctLib success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的耗材信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalExpense]){
                MedicalExpense *medicalExpense = [MedicalExpense objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncMedical_expense:medicalExpense success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的病历记录的信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalRecord]){
                MedicalRecord *medicalRecord = [MedicalRecord objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncMedical_record:medicalRecord success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的预约信息
            }else if ([info.data_type isEqualToString:AutoSync_ReserveRecord]){
                LocalNotification *localNoti = [LocalNotification objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncReserve_record:localNoti success:^(CRMHttpRespondModel *respond) {
                   //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的修复医生信息
            }else if ([info.data_type isEqualToString:AutoSync_RepairDoctor]){
                RepairDoctor *repairDoctor = [RepairDoctor objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncRepair_Doctor:repairDoctor success:^(CRMHttpRespondModel *respond) {
                   //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传更新后的会诊信息
            }else if ([info.data_type isEqualToString:AutoSync_PatientConsultation]){
                PatientConsultation *patientConsulation = [PatientConsultation objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] editAllNeedSyncPatient_consultation:patientConsulation success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
            }
        }
    }
}

#pragma mark - 开始Insert类型的数据上传
- (void)autoSyncInsert{
    //上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
    //查询所有insert类型和同步状态为0和3并且上传次数小于50次的数据
    NSArray *syncArray = [[DBManager shareInstance] getInfoListWithPostType:Insert syncStatus:@"0,3"];
    if (syncArray.count > 0) {
        for (InfoAutoSync *info in syncArray) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"1" byInfoId:info.info_id];
            
#pragma mark -上传新增的患者信息
            if ([info.data_type isEqualToString:AutoSync_Patient]) {
                //上传需要更新的患者信息
                Patient *patient = [Patient objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncPatient:patient success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
//                        patient.sync_time = [NSString currentDateString];
//                        [[DBManager shareInstance] updatePatientBySync:patient];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的材料信息
            }else if ([info.data_type isEqualToString:AutoSync_Material]){
                Material *material = [Material objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncMaterial:material success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的介绍人信息
            }else if ([info.data_type isEqualToString:AutoSync_Introducer]){
                Introducer *introducer = [Introducer objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncIntroducer:introducer success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的病历信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalCase]){
                MedicalCase *medicalCase = [MedicalCase objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncMedical_case:medicalCase success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的ct片信息
            }else if ([info.data_type isEqualToString:AutoSync_CtLib]){
                CTLib *ctLib = [CTLib objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncCt_lib:ctLib success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的耗材信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalExpense]){
                MedicalExpense *medicalExpense = [MedicalExpense objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncMedical_expense:medicalExpense success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的病历记录的信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalRecord]){
                MedicalRecord *medicalRecord = [MedicalRecord objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncMedical_record:medicalRecord success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的预约信息
            }else if ([info.data_type isEqualToString:AutoSync_ReserveRecord]){
                LocalNotification *localNoti = [LocalNotification objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncReserve_record:localNoti success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的修复医生信息
            }else if ([info.data_type isEqualToString:AutoSync_RepairDoctor]){
                RepairDoctor *repairDoctor = [RepairDoctor objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncRepair_doctor:repairDoctor success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的会诊信息
            }else if ([info.data_type isEqualToString:AutoSync_PatientConsultation]){
                PatientConsultation *patientConsulation = [PatientConsultation objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncPatient_consultation:patientConsulation success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的患者介绍人关系表（只有新增的功能）
            }else if ([info.data_type isEqualToString:AutoSync_PatientIntroducerMap]){
                PatientIntroducerMap *map = [PatientIntroducerMap objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] postAllNeedSyncPatientIntroducerMap:map success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传新增的微信信息（只有新增的功能）
            }else if ([info.data_type isEqualToString:AutoSync_WeiXinMessageSend]){
                
#pragma mark -上传新增的患者分组信息(只有新增和删除功能)
            }else if ([info.data_type isEqualToString:AutoSync_AddPatientToGroups]){
                [DoctorGroupTool addPateintToGroupsWithGroupMemberEntity:info.dataEntity success:^(CRMHttpRespondModel *respondModel) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respondModel infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
            }
        }
    }
}

#pragma mark - 开始delete类型的数据上传
- (void)autoSyncDelete{
    //上传状态（0：未上传 1：上传中 2：上传成功 3：上传失败）
    //查询所有delete类型和同步状态为0和3并且上传次数小于50次的数据
    NSArray *syncArray = [[DBManager shareInstance] getInfoListWithPostType:Delete syncStatus:@"0,3"];
    if (syncArray.count > 0) {
        for (InfoAutoSync *info in syncArray) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"1" byInfoId:info.info_id];
            
#pragma mark -上传删除的患者信息
            if ([info.data_type isEqualToString:AutoSync_Patient]) {
                //上传需要更新的患者信息
                Patient *patient = [Patient objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncPatient:patient success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        //删除患者信息
                        [[DBManager shareInstance] deletePatientByPatientID_sync:patient.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的材料信息
            }else if ([info.data_type isEqualToString:AutoSync_Material]){
                Material *material = [Material objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncMaterial:material success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteMaterialWithId_sync:material.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的介绍人信息
            }else if ([info.data_type isEqualToString:AutoSync_Introducer]){
                Introducer *introducer = [Introducer objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncIntroducer:introducer success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteIntroducerWithId_sync:introducer.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的病历信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalCase]){
                MedicalCase *medicalCase = [MedicalCase objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncMedical_case:medicalCase success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteMedicalCaseWithCase_AutoSync:medicalCase];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的ct片信息
            }else if ([info.data_type isEqualToString:AutoSync_CtLib]){
                CTLib *ctLib = [CTLib objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncCt_lib:ctLib success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteCTlibWithLibId_sync:ctLib.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的耗材信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalExpense]){
                MedicalExpense *medicalExpense = [MedicalExpense objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncMedical_expense:medicalExpense success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteMedicalExpenseWithId_sync:medicalExpense.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的病历记录的信息
            }else if ([info.data_type isEqualToString:AutoSync_MedicalRecord]){
                MedicalRecord *medicalRecord = [MedicalRecord objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncMedical_record:medicalRecord success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteMedicalRecordWithId_Sync:medicalRecord.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的预约信息
            }else if ([info.data_type isEqualToString:AutoSync_ReserveRecord]){
                LocalNotification *localNoti = [LocalNotification objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncReserve_record:localNoti success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        //删除提醒
                        [[LocalNotificationCenter shareInstance] cancelNotification:localNoti];
                        [[DBManager shareInstance] deleteLocalNotification_Sync:localNoti];
                        
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的修复医生信息
            }else if ([info.data_type isEqualToString:AutoSync_RepairDoctor]){
                RepairDoctor *repairDoctor = [RepairDoctor objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncRepair_doctor:repairDoctor success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    if([self updateSuccessWithRespondModel:respond infoModel:info]){
                        [[DBManager shareInstance] deleteRepairDoctorWithCkeyId_sync:repairDoctor.ckeyid];
                    }
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的会诊信息
            }else if ([info.data_type isEqualToString:AutoSync_PatientConsultation]){
                PatientConsultation *patientConsulation = [PatientConsultation objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [[XLAutoSyncTool shareInstance] deleteAllNeedSyncPatient_consultation:patientConsulation success:^(CRMHttpRespondModel *respond) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respond infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
#pragma mark -上传删除的分组信息（只有新增和删除功能）
            }else if ([info.data_type isEqualToString:AutoSync_AddPatientToGroups]){
                GroupAndPatientParam *param = [GroupAndPatientParam objectWithKeyValues:[self dicFromJsonStr:info.dataEntity]];
                [DoctorGroupTool deleteGroupMemberWithModel:param success:^(CRMHttpRespondModel *respondModel) {
                    //上传成功
                    [self updateSuccessWithRespondModel:respondModel infoModel:info];
                } failure:^(NSError *error) {
                    //上传失败
                    [self updateFailWithError:error infoModel:info];
                }];
            }
        }
    }
}
#pragma mark - 更新成功后的方法
- (BOOL)updateSuccessWithRespondModel:(CRMHttpRespondModel *)respond infoModel:(InfoAutoSync *)info{
    if ([respond.code integerValue] == 200) {
        NSLog(@"上传成功");
        //上传成功,删除当前的同步信息
        if([[DBManager shareInstance] updateInfoWithSyncStatus:@"2" byInfoId:info.info_id]){
            [[DBManager shareInstance] deleteInfoWithInfoAutoSync:info];
        };
        
        return YES;
    }else{
        NSLog(@"上传失败");
        //上传失败
        info.syncCount = info.syncCount + 1;
        [[DBManager shareInstance] updateInfoWithSyncStatus:@"3" byInfo:info];
        
        return NO;
    }
}
#pragma mark - 更新失败后的方法
- (void)updateFailWithError:(NSError *)error infoModel:(InfoAutoSync *)info{
    NSLog(@"上传次数:%d",info.syncCount);
    //上传失败
    info.syncCount = info.syncCount + 1;
    NSLog(@"上传次数:%d",info.syncCount);
    [[DBManager shareInstance] updateInfoWithSyncStatus:@"3" byInfo:info];
    if (error) {
        NSLog(@"error:%@",error);
    }
}

#pragma mark - 上传异常数据给服务器
- (BOOL)postErrorData{
    //获取所有状态为3的并且超过上传次数的异常数据
    NSArray *array = [[DBManager shareInstance] getInfoListBySyncCountWithStatus:@"3"];
    if (array.count > 0) {
        for (InfoAutoSync *info in array) {
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"4" byInfoId:info.info_id];
            NSString *content = [NSString stringWithFormat:@"DeviceType:iOS,DataType:%@,PostType:%@,DataEntity:%@",info.data_type,info.post_type,info.dataEntity];
            [DoctorTool sendAdviceWithDoctorId:[AccountManager currentUserid] content:content success:^(CRMHttpRespondModel *respond) {
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
        return YES;
    }
    return NO;
}

@end

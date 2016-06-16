//
//  AutoSyncManager+Behaviour.m
//  CRM
//
//  Created by Argo Zhang on 16/6/2.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "AutoSyncManager+Behaviour.h"
#import "XLBehaviourTool.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "XLBehaviourModel.h"
#import "MyDateTool.h"
#import "AutoSync.h"
#import "JSONKit.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "DBManager+LocalNotification.h"
#import "LocalNotificationCenter.h"
#import "PatientManager.h"
#import "DBManager+Doctor.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "XLPatientTotalInfoModel.h"

@implementation AutoSyncManager (Behaviour)

- (void)startBehaviour{
    NSString *syncTime = [CRMUserDefalut objectForKey:AutoSync_Behaviour_SyncTime];
    if (syncTime == nil) {
        return;
    }
    WS(weakSelf);
    [XLBehaviourTool queryNewBehavioursWithDoctorId:[AccountManager currentUserid] syncTime:syncTime success:^(NSArray *result) {
        //处理获取到的同步数据
        if (result.count > 0) {
            //更新同步时间
            [CRMUserDefalut setObject:[MyDateTool stringWithDateWithSec:[NSDate date]] forKey:AutoSync_Behaviour_SyncTime];
            [weakSelf handleBehaviourDataWithArray:result];
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark - 处理所有行为数据
- (void)handleBehaviourDataWithArray:(NSArray *)sourceArray{
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [sourceArray enumerateObjectsUsingBlock:^(XLBehaviourModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.action_type isEqualToString:Delete]){
                [weakSelf handleDeleteBehaviourWithModel:model];
            }else if([model.action_type isEqualToString:UpdateReserveStatus]){
                [weakSelf handleUpdateReserveStatusWithModel:model];
            }else{
                [weakSelf handleNewBehaviourWithModel:model];
            }
        }];
    });
}

#pragma mark - 处理修改预约时的操作
- (void)handleUpdateReserveStatusWithModel:(XLBehaviourModel *)model{
    if ([model.data_type isEqualToString:AutoSync_ReserveRecord]) {
        NSDictionary *dic = model.json_str.objectFromJSONString;
        NSString *reserve_id = dic[@"reserve_id"];
        LocalNotification *localNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:reserve_id];
        if (localNoti) {
            //修改状态
            localNoti.reserve_status = @"1";
            //移除本地的通知
            if([[LocalNotificationCenter shareInstance] removeLocalNotification:localNoti]){
                //删除成功后发送通知
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOtificationUpdated object:nil];
                });
            }
        }
    }
}

#pragma mark - 处理删除的行为数据
- (void)handleDeleteBehaviourWithModel:(XLBehaviourModel *)model{
    if ([model.data_type isEqualToString:AutoSync_Patient]) {
        //患者
        Patient *patient = [Patient PatientFromPatientResult:[model.json_str objectFromJSONString]];
        //判断本地是否有此患者
        Patient *localP = [[DBManager shareInstance] getPatientCkeyid:patient.ckeyid];
        if (localP) {
            [[DBManager shareInstance] deletePatientByPatientID_sync:localP.ckeyid];
            //获取所有的ct数据进行删除
            NSArray *mCases = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:localP.ckeyid];
            for (MedicalCase *temp in mCases) {
                //删除所有病例记录信息
                [[DBManager shareInstance] deleteMedicalRecordWithCaseId_sync:temp.ckeyid];
                //删除病历下的所有ct数据
                NSArray *ctLibs = [[DBManager shareInstance] getCTLibArrayWithCaseId:temp.ckeyid isAsc:YES];
                for (CTLib *ct in ctLibs) {
                    //删除本地缓存的图片
                    [[SDImageCache sharedImageCache] removeImageForKey:ct.ct_image];
                    //删除CT片
                    [[DBManager shareInstance] deleteCTlibWithLibId_sync:ct.ckeyid];
                }
            }
            //获取所有的病历进行删除
            if (mCases.count > 0) {
                [[DBManager shareInstance] deleteMedicalCaseWithPatientId_sync:localP.ckeyid];
            }
            
            //获取所有的耗材信息进行删除
            [[DBManager shareInstance] deleteMedicalExpenseWithPatientId_sync:localP.ckeyid];
            
            //获取所有的会诊记录进行删除
            [[DBManager shareInstance] deletePatientConsultationWithPatientId_sync:localP.ckeyid];
            
            //获取所有的预约数据进行删除
            [[DBManager shareInstance] deleteLocalNotificationWithPatientId_sync:localP.ckeyid];
            
            //删除本地的患者介绍人关系表的数据
            [[DBManager shareInstance] deletePatientIntroducerMap:localP.ckeyid];
            
            //删除成功后发送通知
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PatientDeleteNotification object:nil];
            });
        }
        
    }else if ([model.data_type isEqualToString:AutoSync_Material]){
        //材料
        Material *material = [Material MaterialFromMaterialResult:[model.json_str objectFromJSONString]];
        Material *localM = [[DBManager shareInstance] getMaterialWithId:material.ckeyid];
        if (localM) {
            [[DBManager shareInstance] deleteMaterialWithId_sync:localM.ckeyid];
        }
        
    }else if ([model.data_type isEqualToString:AutoSync_Introducer]){
        //介绍人
        Introducer *intr = [Introducer IntroducerFromIntroducerResult:[model.json_str objectFromJSONString]];
        Introducer *localIntr = [[DBManager shareInstance] getIntroducerByCkeyId:intr.ckeyid];
        if (localIntr) {
            [[DBManager shareInstance] deleteIntroducerWithId_sync:localIntr.ckeyid];
            //删除成功后发送通知
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerEditedNotification object:nil];
            });
        }
        
    }else if ([model.data_type isEqualToString:AutoSync_MedicalCase]){
        //病历
        MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:[model.json_str objectFromJSONString]];
        MedicalCase *localMC = [[DBManager shareInstance] getMedicalCaseWithCaseId:medicalCase.ckeyid];
        if (localMC) {
            if([[DBManager shareInstance] deleteMedicalCaseWithCase_AutoSync:localMC]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MedicalCaseEditedNotification object:nil];
                });
            }
        }
        
    }else if ([model.data_type isEqualToString:AutoSync_CtLib]){
        //CT
        CTLib *ctLib = [CTLib CTLibFromCTLibResult:model.json_str.objectFromJSONString];
        CTLib *localCT = [[DBManager shareInstance] getCTLibWithCKeyId:ctLib.ckeyid];
        if (localCT) {
            [[DBManager shareInstance] deleteCTlibWithLibId_sync:localCT.ckeyid];
        }
    }else if ([model.data_type isEqualToString:AutoSync_MedicalExpense]){
        //耗材
        MedicalExpense *expense = [MedicalExpense MEFromMEResult:model.json_str.objectFromJSONString];
        MedicalExpense *localEP = [[DBManager shareInstance] getMedicalExpenseWithCkeyId:expense.ckeyid];
        if (localEP) {
            [[DBManager shareInstance] deleteMedicalExpenseWithId_sync:localEP.ckeyid];
        }
    }else if ([model.data_type isEqualToString:AutoSync_MedicalRecord]){
        //病情描述
        MedicalRecord *record = [MedicalRecord MRFromMRResult:model.json_str.objectFromJSONString];
        MedicalRecord *localR = [[DBManager shareInstance] getMedicalRecordWithCkeyId:record.ckeyid];
        if (localR) {
            [[DBManager shareInstance] deleteMedicalRecordWithId_Sync:localR.ckeyid];
        }
    }else if ([model.data_type isEqualToString:AutoSync_ReserveRecord]){
        //预约
        LocalNotification *noti = [LocalNotification LNFromLNFResult:model.json_str.objectFromJSONString];
        LocalNotification *localNoti = [[DBManager shareInstance] getLocalNotificationWithCkeyId:noti.ckeyid];
        if (localNoti) {
            [[DBManager shareInstance] deleteLocalNotification_Sync:localNoti];
            //删除成功后发送通知
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleted object:nil];
            });
        }
    }else if ([model.data_type isEqualToString:AutoSync_PatientConsultation]){
        //会诊信息
        PatientConsultation *conSul = [PatientConsultation PCFromPCResult:model.json_str.objectFromJSONString];
        PatientConsultation *localConsul = [[DBManager shareInstance] getPatientConsultationWithCkeyId:conSul.ckeyid];
        if (localConsul) {
            [[DBManager shareInstance] deletePatientConsultationWithCkeyId_sync:localConsul.ckeyid];
        }
    }else if ([model.data_type isEqualToString:AutoSync_PatientIntroducerMap]){
        //关系表
        PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:model.json_str.objectFromJSONString];
        PatientIntroducerMap *localMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:map.patient_id doctorId:map.doctor_id intrId:map.intr_id];
        if (localMap) {
            [[DBManager shareInstance] deletePatientIntroducerMapWithMap:localMap];
        }
    }else if ([model.data_type isEqualToString:AutoSync_Friend]){
        //好友
        Doctor *doc = [Doctor DoctorFromDoctorResult:model.json_str.objectFromJSONString];
        Doctor *localDoc = [[DBManager shareInstance] getDoctorWithCkeyId:doc.ckeyid];
        if (localDoc) {
            [[DBManager shareInstance] deleteDoctorWithUserObject:localDoc];
        }
    }
}

#pragma mark - 处理新增或更新的行为数据
- (void)handleNewBehaviourWithModel:(XLBehaviourModel *)model{
    if ([model.data_type isEqualToString:AutoSync_Patient]) {
        //患者
        Patient *patient = [Patient PatientFromPatientResult:[model.json_str objectFromJSONString]];
        patient.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        //判断本地是否有此患者
        if([[DBManager shareInstance] insertPatientBySync:patient]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
            });
        }
    }else if ([model.data_type isEqualToString:AutoSync_Material]){
        //材料
        Material *material = [Material MaterialFromMaterialResult:[model.json_str objectFromJSONString]];
        material.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertMaterial:material];
        
    }else if ([model.data_type isEqualToString:AutoSync_Introducer]){
        //介绍人
        Introducer *intr = [Introducer IntroducerFromIntroducerResult:[model.json_str objectFromJSONString]];
        intr.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        if([[DBManager shareInstance] insertIntroducer:intr]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerCreatedNotification object:nil];
            });
        }
        
        
    }else if ([model.data_type isEqualToString:AutoSync_MedicalCase]){
        //病历
        MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:[model.json_str objectFromJSONString]];
        medicalCase.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        if([[DBManager shareInstance] insertMedicalCase:medicalCase]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MedicalCaseEditedNotification object:nil];
            });
        }
    }else if ([model.data_type isEqualToString:AutoSync_CtLib]){
        //CT
        CTLib *ctLib = [CTLib CTLibFromCTLibResult:model.json_str.objectFromJSONString];
        ctLib.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertCTLib:ctLib];
        //判断前的ct片是否存在
        if (![PatientManager IsImageExisting:ctLib.ct_image]) {
            @autoreleasepool {
                //下载CT片
                UIImage *image = [self getImageFromURL:ImageFilePath(ctLib.ckeyid, ctLib.ct_image)];
                if (nil != image) {
                    [PatientManager pathImageSaveToDisk:image withKey:ctLib.ct_image];
                }
            }
        }
    }else if ([model.data_type isEqualToString:AutoSync_MedicalExpense]){
        //耗材
        MedicalExpense *expense = [MedicalExpense MEFromMEResult:model.json_str.objectFromJSONString];
        expense.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertMedicalExpenseWith:expense];
    }else if ([model.data_type isEqualToString:AutoSync_MedicalRecord]){
        //病情描述
        MedicalRecord *record = [MedicalRecord MRFromMRResult:model.json_str.objectFromJSONString];
        record.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertMedicalRecord:record];
    }else if ([model.data_type isEqualToString:AutoSync_ReserveRecord]){
        //预约
        LocalNotification *noti = [LocalNotification LNFromLNFResult:model.json_str.objectFromJSONString];
        noti.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        if([[DBManager shareInstance] insertLocalNotification:noti]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
            });
        }
    }else if ([model.data_type isEqualToString:AutoSync_PatientConsultation]){
        //会诊信息
        PatientConsultation *conSul = [PatientConsultation PCFromPCResult:model.json_str.objectFromJSONString];
        conSul.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertPatientConsultation:conSul];
    }else if ([model.data_type isEqualToString:AutoSync_PatientIntroducerMap]){
        //关系表
        PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:model.json_str.objectFromJSONString];
        map.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        if([[DBManager shareInstance] insertPatientIntroducerMap_Sync:map]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PatientEditedNotification object:nil];
            });
        }
    }else if ([model.data_type isEqualToString:AutoSync_Friend]){
        Doctor *doc = [Doctor DoctorFromDoctorResult:model.json_str.objectFromJSONString];
        doc.update_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        [[DBManager shareInstance] insertDoctorWithDoctor:doc];
    }else if ([model.data_type isEqualToString:AutoSync_Transfer]){
        //判断本地是否有此患者
        NSDictionary *dic = model.json_str.objectFromJSONString;
        NSString *patientId = dic[@"patient_id"];
        Patient *patient = [[DBManager shareInstance] getPatientCkeyid:patientId];
        if (patient == nil) {
            //如果患者不存在
            [MyPatientTool getPatientAllInfosWithPatientId:patientId doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
                if ([respond.code integerValue] == 200) {
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (NSDictionary *dic in respond.result) {
                        XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                        [arrayM addObject:model];
                    }
                    //保存数据到数据库
                    [self savePatientDataWithModel:[arrayM lastObject]];
                }
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }else{
            //添加map表的信息
            PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
            map.intr_id = dic[@"intr_id"];
            map.intr_source = dic[@"intr_source"];
            map.patient_id = patientId;
            map.doctor_id = dic[@"doctor_id"];
            map.intr_time = dic[@"intr_time"];
            if([[DBManager shareInstance] insertPatientIntroducerMap_Sync:map]){
                //保存成功，更新患者列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
                });
            }
        }
    }
}

//获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

#pragma mark - 保存所有的患者数据到数据库
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model{
    
    BOOL ret = [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:model];
    if (ret) {
        //保存成功，更新患者列表
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PatientCreatedNotification object:nil];
        });
    }
}

@end

//
//  XLAutoGetSyncTool.m
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAutoGetSyncTool.h"
#import "CRMUserDefalut.h"
#import "AccountManager.h"
#import "DBManager.h"
#import "CRMHttpTool.h"
#import "DBManager+Doctor.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "LocalNotificationCenter.h"
#import "DBManager+LocalNotification.h"
#import "DBManager+Patients.h"
#import "DBManager+RepairDoctor.h"
#import "PatientManager.h"
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "CRMHttpRespondModel.h"

#define Sync_Get_Doctor_Url [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx?action=getdoctor",DomainName,Method_His_Crm]
#define Sync_Get_Material_Url [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=material",DomainName,Method_His_Crm]
#define Sync_Get_Introducer_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=introducer",DomainName,Method_His_Crm])
#define Sync_Get_Patient_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=patient",DomainName,Method_His_Crm])
#define Sync_Get_ReserveRecord_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=reserverecord",DomainName,Method_His_Crm])
#define Sync_Get_PatientIntroMap_Url ([NSString stringWithFormat:@"%@%@/ashx/PatientIntroducerMapHandler.ashx?action=getdoctor",DomainName,Method_His_Crm])
#define Sync_Get_RepairDoctor_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=repairdoctor",DomainName,Method_His_Crm])
#define Sync_Get_CTLib_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=ctlib",DomainName,Method_His_Crm])
#define Sync_Get_MedicalExpense_Url ([NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=medicalcase",DomainName,Method_His_Crm])
#define Sync_Get_MedicalCase_Url [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=medicalcase",DomainName,Method_His_Crm]

#define Sync_Get_MedicalRecord_Url [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=medicalrecord",DomainName,Method_His_Crm]
#define Sync_Get_PatientConsultation_Url [NSString stringWithFormat:@"%@%@/ashx/SyncGet.ashx?table=patientconsultation",DomainName,Method_His_Crm]
#define Sync_Get_ImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]


@implementation XLAutoGetSyncTool
Realize_ShareInstance(XLAutoGetSyncTool)

NSMutableArray* downloadPatients01 = nil;
NSMutableArray* downloadMedicalCasesCT01 = nil;
NSMutableArray* downloadMedicalCasesME01 = nil;
NSMutableArray* downloadMedicalCasesMR01 = nil;
NSMutableArray* downloadMedicalCasesRS01 = nil;

//对于medical case的分批处理
//每次下载病例最大患者数
NSInteger const curPatientsNum01 = 40;

//临时的数组，用来保存当前需要梳理的patient
NSMutableArray* curPatients01 = nil;
//本次同步的患者数，用于校验是不是同步引进成功
NSInteger curTimePatientsNum01 = 0;

//临时的数组，用来保存当前需要梳理的病例 ct_lib
NSMutableArray* curMC_ct01 = nil;
//本次同步的病例数，用于校验是不是同步引进成功 ct_lib
NSInteger curTimeMCNum_ct01 = 0;

//临时的数组，用来保存当前需要梳理的病例 medical_expense
NSMutableArray* curMC_me01 = nil;
//本次同步的病例数，用于校验是不是同步引进成功 medical_expense
NSInteger curTimeMCNum_me01 = 0;

//临时的数组，用来保存当前需要梳理的病例 medical_record
NSMutableArray* curMC_mr01 = nil;
//本次同步的病例数，用于校验是不是同步引进成功 medical_record
NSInteger curTimeMCNum_mr01 = 0;

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (void)getDoctorTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *docServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", DoctorTableName, [AccountManager currentUserid]];
    NSString *docServLastSyncDate = [userDefalut stringForKey:docServLastSynKey];
    
    if (nil == docServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        docServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"uid"];
    [paramDic setObject:docServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_Doctor_Url parameters:paramDic success:^(id responseObject) {
        
        NSArray *docArray = [responseObject objectForKey:@"Result"];
        NSLog(@"当前获取到的好友医生的个数:%ld",(unsigned long)docArray.count);
        
        for (int i=0; i<[docArray count]; i++) {
            
            NSDictionary *dic =docArray[i];
            
            Doctor *doctor = nil;
            
            if (0 != [dic count] ) {
                doctor = [Doctor DoctorFromDoctorResult:dic];
                [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
            }
        }
        NSString *docLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", DoctorTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        [CRMUserDefalut setObject:curDate forKey:docLastSynKey];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"Doctor信息获取失败:%@",error);
        }
    }];
    
}

- (void)getMaterialTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *matServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MaterialTableName, [AccountManager currentUserid]];
    NSString *matServLastSyncDate = [userDefalut stringForKey:matServLastSynKey];
    
    if (nil == matServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        matServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:matServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_Material_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *matArray = [responseObject objectForKey:@"Result"];
            for (int i=0; i<[matArray count]; i++) {
                NSDictionary *mat =matArray[i];
                Material *material = nil;
                if (0 != [matArray count] ) {
                    material = [Material MaterialFromMaterialResult:mat];
                    [[DBManager shareInstance] insertMaterial:material];
                }
            }
        });
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *matLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MaterialTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:matLastSynKey];
        [userDefalut synchronize];
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"Material信息获取失败:%@",error);
        }
    }];
}

- (void)getIntroducerTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *intServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", IntroducerTableName, [AccountManager currentUserid]];
    NSString *intServLastSyncDate = [userDefalut stringForKey:intServLastSynKey];
    
    if (nil == intServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        intServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:intServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_Introducer_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *inteArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[inteArray count]; i++) {
                
                NSDictionary *inte =inteArray[i];
                
                Introducer *introducer = nil;
                
                if (0 != [inteArray count] ) {
                    introducer = [Introducer IntroducerFromIntroducerResult:inte];
                    [[DBManager shareInstance] insertIntroducer:introducer];
                    //稍后条件判断是否成功的代码
                }
            }
        });
        
        NSString *intLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", IntroducerTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        [CRMUserDefalut setObject:curDate forKey:intLastSynKey];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"Introducer信息获取失败:%@",error);
        }
    }];
}

- (void)getPatientTable{
    
    NSLog(@"下载患者数据");
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]];
    NSString *patServLastSyncDate = [userDefalut stringForKey:patServLastSynKey];
    
    if (nil == patServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:patServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_Patient_Url parameters:paramDic success:^(id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (nil == downloadPatients01) {
                downloadPatients01 = [[NSMutableArray alloc] init];
            }
            
            NSArray *patientArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[patientArray count]; i++) {
                
                NSDictionary *pat =patientArray[i];
                
                Patient *patient = nil;
                
                if (0 != [pat count] ) {
                    patient = [Patient PatientFromPatientResult:pat];
                    //将获得的患者id保存下来，后续下载病例时使用
                    if (NSNotFound == [downloadPatients01 indexOfObject:patient.ckeyid]) {
                        [downloadPatients01 addObject:patient.ckeyid];
                    }
                    //稍后条件判断是否成功的代码
                    // [[DBManager shareInstance] insertPatientBySync:patient];
                }
            }
        });
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        [userDefalut setObject:curDate forKey:patServLastSynKey];
        [userDefalut synchronize];
        
        if (0 != [downloadPatients01 count]) {
            
            if (nil == curPatients01) {
                curPatients01 = [[NSMutableArray alloc] init];
            }
            
            if ([downloadPatients01 count] <= curPatientsNum01) {
                for (int i=0; i < [downloadPatients01 count]; i++) {
                    [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                }
            } else {
                for (int i=0; i < curPatientsNum01; i++) {
                    [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                }
            }
            
            [self getPatientAllInfo];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"同步完成"];
            [NSThread sleepForTimeInterval:1.0];
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
        }
        
        
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"Patient信息获取失败:%@",error);
        }
    }];
}
#pragma mark - 获取患者的所有信息
- (void)getPatientAllInfo{
    NSString *strPatientId = nil;
    for (int i = 0 ; i < curPatients01.count; i++) {
        if (nil == strPatientId) {
            strPatientId = [NSString stringWithString:curPatients01[i]];
        } else {
            strPatientId = [strPatientId stringByAppendingString:@","];
            strPatientId = [strPatientId stringByAppendingString:curPatients01[i]];
        }
    }
    //请求网络数据
    [MyPatientTool getPatientAllInfosWithPatientId:strPatientId doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
        if ([respond.code integerValue] == 200) {
            NSMutableArray *results = [NSMutableArray array];
            for (NSDictionary *dic in respond.result) {
                XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                [results addObject:model];
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (XLPatientTotalInfoModel *infoModel in results) {
                    if([self savePatientDataWithModel:infoModel]){
                        //单条数据请求成功
                        NSString *patientId = infoModel.baseInfo[@"ckeyid"];
                        if ([curPatients01 containsObject:patientId]) {
                            [curPatients01 removeObject:patientId];
                            [downloadPatients01 removeObject:patientId];
                        }
                    }
                }
                if (curPatients01.count == 0) {
                    if (downloadPatients01.count > 0) {
                        if ([downloadPatients01 count] <= curPatientsNum01) {
                            for (int i=0; i < [downloadPatients01 count]; i++) {
                                [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                            }
                        } else {
                            for (int i=0; i < curPatientsNum01; i++) {
                                [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                            }
                        }
                        [self getPatientAllInfo];
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"同步完成"];
                        [NSThread sleepForTimeInterval:1.0];
                        [SVProgressHUD dismiss];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
                    }
                }
            });
        
        }
        
    } failure:^(NSError *error) {
        //请求失败，重新请求
        [self getPatientAllInfo];
        if (error) {
            NSLog(@"error:%@",error);
        }
        
    }];
}

#pragma mark - 缓存患者信息
- (BOOL)savePatientDataWithModel:(XLPatientTotalInfoModel *)model{
    
    NSInteger total = 1 + model.medicalCase.count + model.medicalCourse.count + model.cT.count + model.consultation.count + model.expense.count + model.introducerMap.count;
    NSInteger current = 0;
    //保存患者消息
    Patient *patient = [Patient PatientFromPatientResult:model.baseInfo];
    [[DBManager shareInstance] insertPatient:patient];
    //稍后条件判断是否成功的代码
    if([[DBManager shareInstance] insertPatientBySync:patient]){
        current++;
    };
    
    //判断medicalCase数据是否存在
    if (model.medicalCase.count > 0) {
        //保存病历数据
        for (NSDictionary *dic in model.medicalCase) {
            MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:dic];
            if([[DBManager shareInstance] insertMedicalCase:medicalCase]){
                current++;
            };
        }
        
    }
    //判断medicalCourse数据是否存在
    if (model.medicalCourse.count > 0) {
        for (NSDictionary *dic in model.medicalCourse) {
            MedicalRecord *medicalrecord = [MedicalRecord MRFromMRResult:dic];
            if([[DBManager shareInstance] insertMedicalRecord:medicalrecord]){
                current++;
            }
        }
    }
    
    //判断CT数据是否存在
    if (model.cT.count > 0) {
        for (NSDictionary *dic in model.cT) {
            CTLib *ctlib = [CTLib CTLibFromCTLibResult:dic];
            if([[DBManager shareInstance] insertCTLib:ctlib]){
                current++;
            }
            if ([ctlib.ct_image isNotEmpty]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", Sync_Get_ImageDown, ctlib.ckeyid, ctlib.ct_image];
                    UIImage *image = [self getImageFromURL:urlImage];
                    
                    if (nil != image) {
                        [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                    }
                });
            }
        }
    }
    
    //判断consultation数据是否存在
    if (model.consultation.count > 0) {
        for (NSDictionary *dic in model.consultation) {
            PatientConsultation *patientC = [PatientConsultation PCFromPCResult:dic];
            if([[DBManager shareInstance] insertPatientConsultation:patientC]){
                current++;
            }
        }
    }
    
    //判断expense数据是否存在
    if (model.expense.count > 0) {
        for (NSDictionary *dic in model.expense) {
            MedicalExpense *medicalexpense = [MedicalExpense MEFromMEResult:dic];
            if([[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense]){
                current++;
            }
        }
    }
    
    //判断introducerMap数据是否存在
    if (model.introducerMap.count > 0) {
        for (NSDictionary *dic in model.introducerMap) {
            PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:dic];
            if ([[DBManager shareInstance] insertPatientIntroducerMap:map]) {
                current++;
            }
        }
    }
    if (total == current) {
        //同步数据成功,跳转到患者详情页面
        NSLog(@"同步数据成功");
        return YES;
    }else{
        NSLog(@"同步数据失败");
        return NO;
    }
}



- (void)getReserverecordTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *rcServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
    NSString *rcServLastSyncDate = [userDefalut stringForKey:rcServLastSynKey];
    
    if (nil == rcServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        rcServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:rcServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_ReserveRecord_Url parameters:paramDic success:^(id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *reserveRecordArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[reserveRecordArray count]; i++) {
                
                NSDictionary *resR =reserveRecordArray[i];
                
                LocalNotification *local = nil;
                
                if (0 != [resR count] ) {
                    local = [LocalNotification LNFromLNFResult:resR];
                    [[DBManager shareInstance] insertLocalNotification:local];
                }
            }
            
        });
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *ctServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", LocalNotificationTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        [userDefalut setObject:curDate forKey:ctServLastSynKey];
        [userDefalut synchronize];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"LocalNotification信息获取失败:%@",error);
        }
    }];
}

- (void)getPatIntrMapTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *patInServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
    NSString *patInServLastSyncDate = [userDefalut stringForKey:patInServLastSynKey];
    
    if (nil == patInServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        patInServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"uid"];
    [paramDic setObject:patInServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_PatientIntroMap_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *patientIntroducerArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[patientIntroducerArray count]; i++) {
                NSDictionary *resPI =patientIntroducerArray[i];
                PatientIntroducerMap *pI = nil;
                if (0 != [resPI count] ) {
                    pI = [PatientIntroducerMap PIFromMIResult:resPI];
                    [[DBManager shareInstance] insertPatientIntroducerMap:pI];
                }
            }
            
        });
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *piServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatIntrMapTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:piServLastSynKey];
        [userDefalut synchronize];
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"PatientIntroMap信息获取失败:%@",error);
        }
    }];
}

- (void)getRepairDoctorTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *reDocServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", RepairDocTableName, [AccountManager currentUserid]];
    NSString *reDocInServLastSyncDate = [userDefalut stringForKey:reDocServLastSynKey];
    
    if (nil == reDocInServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        reDocInServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    [paramDic setObject:[CRMUserDefalut latestUserId] forKey:@"doctor_id"];
    [paramDic setObject:reDocInServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_RepairDoctor_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *repairDoctorArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[repairDoctorArray count]; i++) {
                
                NSDictionary *resRD =repairDoctorArray[i];
                
                RepairDoctor *rD = nil;
                
                if (0 != [resRD count] ) {
                    rD = [RepairDoctor  repairDoctorFromDoctorResult:resRD];
                    
                    [[DBManager shareInstance] insertRepairDoctor:rD];
                }
            }
            
        });
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *rDServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", RepairDocTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        
        [userDefalut setObject:curDate forKey:rDServLastSynKey];
        [userDefalut synchronize];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"PatientIntroMap信息获取失败:%@",error);
        }
    }];
}

- (void)getCTLibTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *libServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", CTLibTableName, [AccountManager currentUserid]];
    NSString *libServLastSyncDate = [userDefalut stringForKey:libServLastSynKey];
    
    if (nil == libServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        libServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strCaseId = nil;
    
    if ((nil == curMC_ct01) || (0 == [curMC_ct01 count])) {
        return;
    } else {
        for (int i = 0; i < [curMC_ct01 count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:curMC_ct01[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:curMC_ct01[i]];
            }
        }
    }
    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:libServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_CTLib_Url parameters:paramDic success:^(id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray *medicalCTArray = [responseObject objectForKey:@"Result"];
            for (int i=0; i<[medicalCTArray count]; i++) {
                NSDictionary *medCT =medicalCTArray[i];
                CTLib *ctlib = nil;
                if (0 != [medCT count] ) {
                    ctlib = [CTLib CTLibFromCTLibResult:medCT];
                    [[DBManager shareInstance] insertCTLib:ctlib];
                    
                    if ([ctlib.ct_image isNotEmpty]) {
                        
                        NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", Sync_Get_ImageDown, ctlib.ckeyid, ctlib.ct_image];
                        
                        UIImage *image = [self getImageFromURL:urlImage];
                        
                        if (nil != image) {
                            [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                        }
                        
                    }
                    //稍后条件判断是否成功的代码
                    if (nil != downloadMedicalCasesCT01) {
                        NSInteger index = [downloadMedicalCasesCT01 indexOfObject:ctlib.case_id];
                        if (NSNotFound != index) {
                            [downloadMedicalCasesCT01 removeObjectAtIndex:index];
                        }
                    }
                }
            }
            
            for (int i=0; i<[curMC_ct01 count]; i++) {
                [downloadMedicalCasesCT01 removeObject:[curMC_ct01 objectAtIndex:i]];
            }
            
            [curMC_ct01 removeAllObjects];
            
            if ([downloadMedicalCasesCT01 count] != 0) {
                if ([downloadMedicalCasesCT01 count] <= curPatientsNum01) {
                    for (int i=0; i < [downloadMedicalCasesCT01 count]; i++) {
                        [curMC_ct01 addObject:[downloadMedicalCasesCT01 objectAtIndex:i]];
                    }
                } else {
                    for (int i=0; i < curPatientsNum01; i++) {
                        [curMC_ct01 addObject:[downloadMedicalCasesCT01 objectAtIndex:i]];
                    }
                }
                
                [self getCTLibTable];
                
            } else {
                
                NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
                NSString *ctServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", CTLibTableName, [AccountManager currentUserid]];
                [userDefalut setObject:[NSString currentDateTenMinuteString] forKey:ctServLastSynKey];
                [userDefalut synchronize];
                
                return;
            }
        });
    } failure:^(NSError *error) {
        //重新请求
        [self getCTLibTable];
    }];
}

- (void)getMedicalExpenseTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *caseServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    NSString *caseServLastSyncDate = [userDefalut stringForKey:caseServLastSynKey];
    
    if (nil == caseServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        caseServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strPatientId = nil;
    
    curTimePatientsNum01 = [curPatients01 count];
    
    if ((nil == curPatients01) || (0 == [curPatients01 count])) {
        return;
    } else {
        for (int i = 0; i < [curPatients01 count]; i++) {
            if (nil == strPatientId) {
                strPatientId = [NSString stringWithString:curPatients01[i]];
            } else {
                strPatientId = [strPatientId stringByAppendingString:@","];
                strPatientId = [strPatientId stringByAppendingString:curPatients01[i]];
            }
        }
    }
    [paramDic setObject:strPatientId forKey:@"patient_id"];
    [paramDic setObject:caseServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_MedicalExpense_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray *medicalExArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[medicalExArray count]; i++) {
                
                NSDictionary *medEx =medicalExArray[i];
                
                MedicalExpense *medicalexpense = nil;
                
                if (0 != [medEx count] ) {
                    medicalexpense = [MedicalExpense MEFromMEResult:medEx];
                    
                    [[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense];
                    //稍后条件判断是否成功的代码
                    if (nil != downloadMedicalCasesME01) {
                        NSInteger index = [downloadMedicalCasesME01 indexOfObject:medicalexpense.case_id];
                        if (NSNotFound != index) {
                            [downloadMedicalCasesME01 removeObjectAtIndex:index];
                        }
                    }
                }
            }
            for (int i=0; i<[curMC_me01 count]; i++) {
                [downloadMedicalCasesME01 removeObject:[curMC_me01 objectAtIndex:i]];
            }
            
            [curMC_me01 removeAllObjects];
            
            if ([downloadMedicalCasesME01 count] != 0) {
                if ([downloadMedicalCasesME01 count] <= curPatientsNum01) {
                    for (int i=0; i < [downloadMedicalCasesME01 count]; i++) {
                        [curMC_me01 addObject:[downloadMedicalCasesME01 objectAtIndex:i]];
                    }
                } else {
                    for (int i=0; i < curPatientsNum01; i++) {
                        [curMC_me01 addObject:[downloadMedicalCasesME01 objectAtIndex:i]];
                    }
                }
                
                [self getMedicalExpenseTable];
            } else {
                
                NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
                NSString *meServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalExpenseTableName, [AccountManager currentUserid]];
                NSString *curDate = [NSString currentDateTenMinuteString];
                
                [userDefalut setObject:curDate forKey:meServLastSynKey];
                [userDefalut synchronize];
                
                if (0 != [downloadMedicalCasesMR01 count]) {
                    
                    if (nil == curMC_mr01) {
                        curMC_mr01 = [[NSMutableArray alloc] init];
                    }
                    
                    if ([downloadMedicalCasesMR01 count] <= curPatientsNum01) {
                        for (int i=0; i < [downloadMedicalCasesMR01 count]; i++) {
                            [curMC_mr01 addObject:[downloadMedicalCasesMR01 objectAtIndex:i]];
                        }
                    } else {
                        for (int i=0; i < curPatientsNum01; i++) {
                            [curMC_mr01 addObject:[downloadMedicalCasesMR01 objectAtIndex:i]];
                        }
                    }
                    
                    [self getMedicalRecordTable];
                }
            }
        });
    } failure:^(NSError *error) {
        [self getMedicalExpenseTable];
    }];
}

- (void)getMedicalCaseTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *caseServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
    NSString *caseServLastSyncDate = [userDefalut stringForKey:caseServLastSynKey];
    
    if (nil == caseServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        caseServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strPatientId = nil;
    
    curTimePatientsNum01 = [curPatients01 count];
    
    if ((nil == curPatients01) || (0 == [curPatients01 count])) {
        return;
    } else {
        for (int i = 0; i < [curPatients01 count]; i++) {
            if (nil == strPatientId) {
                strPatientId = [NSString stringWithString:curPatients01[i]];
            } else {
                strPatientId = [strPatientId stringByAppendingString:@","];
                strPatientId = [strPatientId stringByAppendingString:curPatients01[i]];
            }
        }
    }
    [paramDic setObject:strPatientId forKey:@"patient_id"];
    [paramDic setObject:caseServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_MedicalCase_Url parameters:paramDic success:^(id responseObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if (nil == downloadMedicalCasesCT01) {
                downloadMedicalCasesCT01 = [[NSMutableArray alloc] init];
            }
            
            if (nil == downloadMedicalCasesME01) {
                downloadMedicalCasesME01 = [[NSMutableArray alloc] init];
            }
            
            if (nil == downloadMedicalCasesMR01) {
                downloadMedicalCasesMR01 = [[NSMutableArray alloc] init];
            }
            
            if (nil == downloadMedicalCasesRS01) {
                downloadMedicalCasesRS01 = [[NSMutableArray alloc] init];
            }
            NSArray *medicalCaseArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[medicalCaseArray count]; i++) {
                
                NSDictionary *medcas = medicalCaseArray[i];
                
                MedicalCase *medicalCase = nil;
                
                if (0 != [medcas count] ) {
                    medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:medcas];
                    
                    [[DBManager shareInstance] insertMedicalCase:medicalCase];
                    //稍后条件判断是否成功的代码
                    
                    
                    if (NSNotFound == [downloadMedicalCasesCT01 indexOfObject:medicalCase.ckeyid]) {
                        [downloadMedicalCasesCT01 addObject:medicalCase.ckeyid];
                    }
                    
                    if (NSNotFound == [downloadMedicalCasesME01 indexOfObject:medicalCase.ckeyid]) {
                        [downloadMedicalCasesME01 addObject:medicalCase.ckeyid];
                    }
                    
                    if (NSNotFound == [downloadMedicalCasesMR01 indexOfObject:medicalCase.ckeyid]) {
                        [downloadMedicalCasesMR01 addObject:medicalCase.ckeyid];
                    }
                    
                    if (NSNotFound == [downloadMedicalCasesRS01 indexOfObject:medicalCase.ckeyid]) {
                        [downloadMedicalCasesRS01 addObject:medicalCase.ckeyid];
                    }
                    
                    if (nil != downloadPatients01) {
                        NSInteger index = [downloadMedicalCasesCT01 indexOfObject:medicalCase.patient_id];
                        if (NSNotFound != index) {
                            [downloadPatients01 removeObjectAtIndex:index];
                        }
                        
                    }
                    
                }
            }
            
            for (int i=0; i<[curPatients01 count]; i++) {
                [downloadPatients01 removeObject:[curPatients01 objectAtIndex:i]];
            }
            
            [curPatients01 removeAllObjects];
            
            if ([downloadPatients01 count] > 0) {
                if ([downloadPatients01 count] <= curPatientsNum01) {
                    for (int i=0; i < [downloadPatients01 count]; i++) {
                        [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                    }
                } else {
                    for (int i=0; i < curPatientsNum01; i++) {
                        [curPatients01 addObject:[downloadPatients01 objectAtIndex:i]];
                    }
                }
                
                [self getMedicalCaseTable];
                
            } else {
                
                if (0 != [downloadMedicalCasesME01 count]) {
                    
                    if (nil == curMC_me01) {
                        curMC_me01 = [[NSMutableArray alloc] init];
                    }
                    
                    if ([downloadMedicalCasesME01 count] <= curPatientsNum01) {
                        for (int i=0; i < [downloadMedicalCasesME01 count]; i++) {
                            [curMC_me01 addObject:[downloadMedicalCasesME01 objectAtIndex:i]];
                        }
                    } else {
                        for (int i=0; i < curPatientsNum01; i++) {
                            [curMC_me01 addObject:[downloadMedicalCasesME01 objectAtIndex:i]];
                        }
                    }
                    
                    [self getMedicalExpenseTable];
                }
                
                NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
                NSString *patServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalCaseTableName, [AccountManager currentUserid]];
                NSString *curDate = [NSString currentDateTenMinuteString];
                
                [userDefalut setObject:curDate forKey:patServLastSynKey];
                [userDefalut synchronize];
            }
        });
    } failure:^(NSError *error) {
        [self getMedicalCaseTable];
    }];
}

- (void)getMedicalRecordTable{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *recServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalRecordableName, [AccountManager currentUserid]];
    NSString *recServLastSyncDate = [userDefalut stringForKey:recServLastSynKey];
    
    if (nil == recServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        recServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strCaseId = nil;
    
    if ((nil == curMC_mr01) || (0 == [curMC_mr01 count])) {
        return;
    } else {
        for (int i = 0; i < [curMC_mr01 count]; i++) {
            if (nil == strCaseId) {
                strCaseId = [NSString stringWithString:curMC_mr01[i]];
            } else {
                strCaseId = [strCaseId stringByAppendingString:@","];
                strCaseId = [strCaseId stringByAppendingString:curMC_mr01[i]];
            }
        }
    }
    
    [paramDic setObject:strCaseId forKey:@"case_id"];
    [paramDic setObject:recServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_MedicalRecord_Url parameters:paramDic success:^(id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray *medicalReArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[medicalReArray count]; i++) {
                
                NSDictionary *medRe = medicalReArray[i];
                
                MedicalRecord *medicalrecord = nil;
                
                if (0 != [medRe count] ) {
                    medicalrecord = [MedicalRecord MRFromMRResult:medRe];
                    
                    [[DBManager shareInstance] insertMedicalRecord:medicalrecord];
                    //稍后条件判断是否成功的代码
                    if (nil != downloadMedicalCasesMR01) {
                        NSInteger index = [downloadMedicalCasesMR01 indexOfObject:medicalrecord.case_id];
                        if (NSNotFound != index) {
                            [downloadMedicalCasesMR01 removeObjectAtIndex:index];
                        }
                    }
                }
            }
            
            
            for (int i=0; i<[curMC_mr01 count]; i++) {
                [downloadMedicalCasesMR01 removeObject:[curMC_mr01 objectAtIndex:i]];
            }
            
            [curMC_mr01 removeAllObjects];
            
            if ([downloadMedicalCasesMR01 count] != 0) {
                if ([downloadMedicalCasesMR01 count] <= curPatientsNum01) {
                    for (int i=0; i < [downloadMedicalCasesMR01 count]; i++) {
                        [curMC_mr01 addObject:[downloadMedicalCasesMR01 objectAtIndex:i]];
                    }
                } else {
                    for (int i=0; i < curPatientsNum01; i++) {
                        [curMC_mr01 addObject:[downloadMedicalCasesMR01 objectAtIndex:i]];
                    }
                }
                
                [self getMedicalRecordTable];
            } else {
                
                NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
                NSString *mrServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", MedicalRecordableName, [AccountManager currentUserid]];
                NSString *curDate = [NSString currentDateTenMinuteString];
                
                [userDefalut setObject:curDate forKey:mrServLastSynKey];
                [userDefalut synchronize];
                NSLog(@"当前下载的病历数组0:%ld",[downloadMedicalCasesCT01 count]);
                if (0 != [downloadMedicalCasesCT01 count]) {
                    NSLog(@"当前下载的病历数组1:%ld",[downloadMedicalCasesCT01 count]);
                    if (nil == curMC_ct01) {
                        curMC_ct01 = [[NSMutableArray alloc] init];
                    }
                    
                    if ([downloadMedicalCasesCT01 count] <= curPatientsNum01) {
                        for (int i=0; i < [downloadMedicalCasesCT01 count]; i++) {
                            [curMC_ct01 addObject:[downloadMedicalCasesCT01 objectAtIndex:i]];
                        }
                    } else {
                        for (int i=0; i < curPatientsNum01; i++) {
                            [curMC_ct01 addObject:[downloadMedicalCasesCT01 objectAtIndex:i]];
                        }
                    }
                    
                    [self getCTLibTable];
                    
                }
            }
        });
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"MedicalRecord信息获取失败:%@",error);
        }
    }];
}

- (void)getPatientConsulationTable{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *caseServLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
    NSString *caseServLastSyncDate = [userDefalut stringForKey:caseServLastSynKey];
    
    if (nil == caseServLastSyncDate) {
        NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        caseServLastSyncDate = [dateFormatter stringFromDate:def];
    }
    
    NSString *strPatientId = nil;
    
    curTimePatientsNum01 = [curPatients01 count];
    
    if ((nil == curPatients01) || (0 == [curPatients01 count])) {
        return;
    } else {
        for (int i = 0; i < [curPatients01 count]; i++) {
            if (nil == strPatientId) {
                strPatientId = [NSString stringWithString:curPatients01[i]];
            } else {
                strPatientId = [strPatientId stringByAppendingString:@","];
                strPatientId = [strPatientId stringByAppendingString:curPatients01[i]];
            }
        }
    }
    
    [paramDic setObject:strPatientId forKey:@"patient_id"];
    [paramDic setObject:caseServLastSyncDate forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] GET:Sync_Get_PatientConsultation_Url parameters:paramDic success:^(id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray *patientConsultationArray = [responseObject objectForKey:@"Result"];
            
            for (int i=0; i<[patientConsultationArray count]; i++) {
                
                NSDictionary *dic =patientConsultationArray[i];
                
                PatientConsultation *patientC = nil;
                
                if (0 != [dic count] ) {
                    patientC = [PatientConsultation PCFromPCResult:dic];
                    
                    [[DBManager shareInstance]insertPatientConsultation:patientC];
                }
            }
        });
        
        NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
        NSString *docLastSynKey = [NSString stringWithFormat:@"syncDataGet%@%@", PatientConsultationTableName, [AccountManager currentUserid]];
        NSString *curDate = [NSString currentDateTenMinuteString];
        [userDefalut setObject:curDate forKey:docLastSynKey];
        [userDefalut synchronize];
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"PatientConsultation信息获取失败:%@",error);
        }
    }];
}
@end

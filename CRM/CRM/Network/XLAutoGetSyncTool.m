//
//  XLAutoGetSyncTool.m
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLAutoGetSyncTool.h"
#import "AccountManager.h"
#import "DBManager.h"
#import "CRMUserDefalut.h"
#import "NSString+TTMAddtion.h"
#import "CRMHttpTool.h"
#import "NSString+Conversion.h"
#import "CRMHttpRespondModel.h"
#import "DBManager+Doctor.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "LocalNotificationCenter.h"
#import "DBManager+LocalNotification.h"
#import "DBManager+RepairDoctor.h"
#import "PatientManager.h"
#import "UIImage+TTMAddtion.h"

//好友信息Url
#define SYNC_GET_DOCTOR_URL [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]
#define SYNC_GET_COMMON_URL [NSString stringWithFormat:@"%@%@/%@/SyncGet.ashx",DomainName,Method_His_Crm,Method_Ashx]
#define SYNC_GET_PATIENT_INTRODUCER_MAP_URL [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]
#define SYNC_IMAGEDOWN [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]

#define MaxDownLoadCount 50

@interface XLAutoGetSyncTool ()

@property (nonatomic, strong)NSMutableArray *downloadMedicalCasesCTImages;//当前所有需要下载的图片
@property (nonatomic, strong)NSMutableArray *curDownLoadMc;//当前正在下载的图片
@property (nonatomic, assign)BOOL showSuccess;//是否发送同步完成通知
@end

@implementation XLAutoGetSyncTool
Realize_ShareInstance(XLAutoGetSyncTool)

- (NSMutableArray *)downloadMedicalCasesCTImages{
    if (!_downloadMedicalCasesCTImages) {
        _downloadMedicalCasesCTImages = [NSMutableArray array];
    }
    return _downloadMedicalCasesCTImages;
}

- (NSMutableArray *)curDownLoadMc{
    if (!_curDownLoadMc) {
        _curDownLoadMc = [NSMutableArray array];
    }
    return _curDownLoadMc;
}

#pragma mark - Private Method
#pragma mark -下载图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
#pragma mark -获取默认的系统时间
- (NSString *)getDefaultTime{
    NSDate *def = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:def];
}

#pragma mark -获取同步的key
- (NSString *)getSyncKeyWithTableName:(NSString *)tableName{
    NSString *lastSyncKey = [NSString stringWithFormat:@"syncDataGet%@%@", tableName, [AccountManager currentUserid]];
    return lastSyncKey;
}

#pragma mark -获取同步时间的key，返回同步时间
- (NSString *)getCurrentSyncTimeWithTableName:(NSString *)tableName{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSString *lastSyncKey = [self getSyncKeyWithTableName:tableName];
    return [userDefalut stringForKey:lastSyncKey];
}
#pragma mark -设置当前同步时间，默认前移5分钟
- (void)setLastSyncTimeWithTableName:(NSString *)tableName{
    [CRMUserDefalut setObject:[NSString currentDateFiveMinuteString] forKey:[self getSyncKeyWithTableName:tableName]];
}

#pragma mark - SyncGet
- (void)getAllDataShowSuccess:(BOOL)showSuccess{
    self.showSuccess = showSuccess;
    [self getDoctorTable];
}

#pragma mark -获取医生信息
- (void)getDoctorTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *docServLastSyncDate = [self getCurrentSyncTimeWithTableName:DoctorTableName];
    if (nil == docServLastSyncDate) {
        docServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"getdoctor" TripleDESIsEncrypt:YES] forKey:@"action"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"uid"];
    [params setObject:[docServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    NSLog(@"sync time %@", docServLastSyncDate);
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_DOCTOR_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                for (NSDictionary *dic in respond.result) {
                    Doctor *doctor = nil;
                    if (0 != [dic count] ) {
                        doctor = [Doctor DoctorFromDoctorResult:dic];
                        [[DBManager shareInstance] insertDoctorWithDoctor:doctor];
                    }
                }
                //设置最后一次同步时间
                [weakSelf setLastSyncTimeWithTableName:DoctorTableName];
                //设置行为表的同步时间
                [CRMUserDefalut setObject:[weakSelf getCurrentSyncTimeWithTableName:DoctorTableName] forKey:AutoSync_Behaviour_SyncTime];
                //获取介绍人信息
                [weakSelf getIntroducerTableHasNext:YES];
                
            }else{
                NSLog(@"获取医生好友数据异常code:%ld",(long)[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"DoctorTable_Error:%@",error);
    }];
}
#pragma mark -获取介绍人信息
- (void)getIntroducerTableHasNext:(BOOL)hasNext{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *intServLastSyncDate = [self getCurrentSyncTimeWithTableName:IntroducerTableName];
    if (nil == intServLastSyncDate) {
        intServLastSyncDate = [self getDefaultTime];
    }
    [params setObject:[@"introducer" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[intServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                    NSArray *datas = respond.result;
                    for (NSDictionary *dic in datas) {
                        Introducer *introducer = nil;
                        if (0 != [dic count] ) {
                            introducer = [Introducer IntroducerFromIntroducerResult:dic];
                            [[DBManager shareInstance] insertIntroducer:introducer];
                        }
                    }
                    [weakSelf setLastSyncTimeWithTableName:IntroducerTableName];
                if (hasNext) {
                    //获取患者信息
                    [weakSelf getPatientTable];
                }else{
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerCreatedNotification object:nil];
                }
                
            }else{
                if (!hasNext) {
                    //发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerCreatedNotification object:nil];
                }
                NSLog(@"获取介绍人数据异常code:%ld",[respond.code integerValue]);
            }
       });
    } failure:^(NSError *error) {
        if (!hasNext) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerCreatedNotification object:nil];
        }
        NSLog(@"IntroducerTable_Error:%@",error);
    }];
}

#pragma mark -获取患者数据
- (void)getPatientTable{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *patServLastSyncDate = [self getCurrentSyncTimeWithTableName:PatientTableName];
    
    if (nil == patServLastSyncDate) {
        patServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"patient" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[patServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    Patient *patient = nil;
                    if (0 != [dic count] ) {
                        patient = [Patient PatientFromPatientResult:dic];
                        [[DBManager shareInstance] insertPatientBySync:patient];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:PatientTableName];
                //获取材料信息
                [weakSelf getMaterialTable];
            }else{
                NSLog(@"获取患者数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"PatientTable_Error:%@",error);
    }];
}
#pragma mark -获取材料信息
- (void)getMaterialTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *matServLastSyncDate = [self getCurrentSyncTimeWithTableName:MaterialTableName];
    if (nil == matServLastSyncDate) {
        matServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"material" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[matServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    Material *material = nil;
                    if (0 != [dic count] ) {
                        material = [Material MaterialFromMaterialResult:dic];
                        [[DBManager shareInstance] insertMaterial:material];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:MaterialTableName];
                //获取预约数据
                [weakSelf getReserverecordTableHasNext:YES];
            }else{
                NSLog(@"获取材料数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"MaterialTable_Error:%@",error);
    }];
}
#pragma mark -获取预约数据
- (void)getReserverecordTableHasNext:(BOOL)hasNext{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *rcServLastSyncDate = [self getCurrentSyncTimeWithTableName:LocalNotificationTableName];
    
    if (nil == rcServLastSyncDate) {
        rcServLastSyncDate = [self getDefaultTime];
    }
    [params setObject:[@"reserverecord" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[rcServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    LocalNotification *local = nil;
                    if (0 != [dic count] ) {
                        local = [LocalNotification LNFromLNFResult:dic];
                        [[DBManager shareInstance] insertLocalNotification:local];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:LocalNotificationTableName];
                if (hasNext) {
                    //获取PatientIntrMap数据
                    [weakSelf getPatIntrMapTable];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
                }
            }else{
                if (!hasNext) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
                }
                NSLog(@"获取预约数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        if (!hasNext) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCreated object:nil];
        }
        NSLog(@"LocalNotificationTable_Error:%@",error);
    }];
}

#pragma mark -获取PatientIntrMap信息
- (void)getPatIntrMapTable{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *patInServLastSyncDate = [self getCurrentSyncTimeWithTableName:PatIntrMapTableName];
    
    if (nil == patInServLastSyncDate) {
        patInServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"getdoctor" TripleDESIsEncrypt:YES] forKey:@"action"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"uid"];
    [params setObject:[patInServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance ] logWithUrlStr:SYNC_GET_PATIENT_INTRODUCER_MAP_URL params:params];
    [[CRMHttpTool shareInstance] POST:SYNC_GET_PATIENT_INTRODUCER_MAP_URL parameters:params success:^(id responseObject) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    PatientIntroducerMap *pI = nil;
                    if (0 != [dic count] ) {
                        pI = [PatientIntroducerMap PIFromMIResult:dic];
                        [[DBManager shareInstance] insertPatientIntroducerMap_Sync:pI];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:PatIntrMapTableName];
                //获取修复医生信息
                [weakSelf getRepairDoctorTable];
            }else{
                NSLog(@"获取PatIntrMap数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"PatientIntrMapTable_Error:%@",error);
    }];
}
#pragma mark -获取修复医生信息
- (void)getRepairDoctorTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *reDocInServLastSyncDate = [self getCurrentSyncTimeWithTableName:RepairDocTableName];
    
    if (nil == reDocInServLastSyncDate) {
        reDocInServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"repairdoctor" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[reDocInServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                    NSArray *datas = respond.result;
                    for (NSDictionary *dic in datas) {
                        RepairDoctor *rD = nil;
                        if (0 != [dic count] ) {
                            rD = [RepairDoctor repairDoctorFromDoctorResult:dic];
                            [[DBManager shareInstance] insertRepairDoctor:rD];
                        }
                    }
                    //设置最后同步时间
                    [weakSelf setLastSyncTimeWithTableName:RepairDocTableName];
                    //获取病历信息
                    [weakSelf getMedicalCaseTable];
            }else{
                NSLog(@"获取修复医生数据异常code:%ld",[respond.code integerValue]);
            }
        });
        
    } failure:^(NSError *error) {
        NSLog(@"RepairDoctorTable_Error:%@",error);
    }];
}
#pragma mark -获取病历信息
- (void)getMedicalCaseTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *caseServLastSyncDate = [self getCurrentSyncTimeWithTableName:MedicalCaseTableName];
    
    if (nil == caseServLastSyncDate) {
        caseServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"medicalcase" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[caseServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    MedicalCase *medicalCase = nil;
                    if (0 != [dic count] ) {
                        medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:dic];
                        [[DBManager shareInstance] insertMedicalCase:medicalCase];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:MedicalCaseTableName];
                //获取耗材信息
                [weakSelf getMedicalExpenseTable];
            }else{
                NSLog(@"获取病历数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"MedicalCaseTable_Error:%@",error);
    }];
}
#pragma mark -同步耗材信息
- (void)getMedicalExpenseTable{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *expServLastSyncDate = [self getCurrentSyncTimeWithTableName:MedicalExpenseTableName];
    
    if (nil == expServLastSyncDate) {
        expServLastSyncDate = [self getDefaultTime];
    }
    [params setObject:[@"medicalexpense" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[expServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    MedicalExpense *medicalexpense = nil;
                    if (0 != [dic count] ) {
                        medicalexpense = [MedicalExpense MEFromMEResult:dic];
                        [[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:MedicalExpenseTableName];
                //获取病历记录信息
                [weakSelf getMedicalRecordTable];
            }else{
                NSLog(@"获取耗材数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"MedicalExpense_Error:%@",error);
    }];
}

#pragma mark -下载病历记录信息
- (void)getMedicalRecordTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *recServLastSyncDate = [self getCurrentSyncTimeWithTableName:MedicalRecordableName];
    
    if (nil == recServLastSyncDate) {
        recServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"medicalrecord" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[recServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    MedicalRecord *medicalrecord = nil;
                    if (0 != [dic count] ) {
                        medicalrecord = [MedicalRecord MRFromMRResult:dic];
                        [[DBManager shareInstance] insertMedicalRecord:medicalrecord];
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:MedicalRecordableName];
                //获取会诊信息
                [weakSelf getPatientConsulationTable];
            }else{
                NSLog(@"获取病历记录数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
         NSLog(@"MedicalRecord_Error:%@",error);
    }];
}
#pragma mark -获取会诊信息
- (void)getPatientConsulationTable{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSString *caseServLastSyncDate = [self getCurrentSyncTimeWithTableName:PatientConsultationTableName];
    
    if (nil == caseServLastSyncDate) {
        caseServLastSyncDate = [self getDefaultTime];
    }
    
    [params setObject:[@"patientconsultation" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[caseServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            NSLog(@"patientConsulation:%@",respond.result);
            if ([respond.code integerValue] == 200) {
                    NSArray *datas = respond.result;
                    for (NSDictionary *dic in datas) {
                        PatientConsultation *patientC = nil;
                        if (0 != [dic count] ){
                            patientC = [PatientConsultation PCFromPCResult:dic];
                            [[DBManager shareInstance] insertPatientConsultation:patientC];
                        }
                    }
                    //设置最后同步时间
                    [weakSelf setLastSyncTimeWithTableName:PatientConsultationTableName];
                    //获取CT信息
                    [weakSelf getCTLibTable];
            }else{
                NSLog(@"获取会诊信息数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"PatientConsultation_Error:%@",error);
    }];
}

#pragma mark -获取CT信息
- (void)getCTLibTable{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *libServLastSyncDate = [self getCurrentSyncTimeWithTableName:CTLibTableName];
    
    if (nil == libServLastSyncDate) {
        libServLastSyncDate = [self getDefaultTime];
    }
    [params setObject:[@"ctlib" TripleDESIsEncrypt:YES] forKey:@"table"];
    [params setObject:[[CRMUserDefalut latestUserId] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    [params setObject:[libServLastSyncDate TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    
    [[CRMHttpTool shareInstance] POST:SYNC_GET_COMMON_URL parameters:params success:^(id responseObject) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
            if ([respond.code integerValue] == 200) {
                NSArray *datas = respond.result;
                for (NSDictionary *dic in datas) {
                    CTLib *ctlib = nil;
                    if (0 != [dic count] ) {
                        ctlib = [CTLib CTLibFromCTLibResult:dic];
                        [[DBManager shareInstance] insertCTLib:ctlib];
                        
                        //如果存在CT图片，将图片URL存放在数组中
                        if ([ctlib.ct_image isNotEmpty]) {
                            [weakSelf.downloadMedicalCasesCTImages addObject:ctlib];
                        }
                    }
                }
                //设置最后同步时间
                [weakSelf setLastSyncTimeWithTableName:CTLibTableName];
                
                //判断是否发送同步成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:SyncGetSuccessNotification object:nil];
                if (weakSelf.showSuccess) {
                    //同步结束
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:@"同步成功"];
                    });
                }
                
                //判断是否有CT图片
                if (self.downloadMedicalCasesCTImages.count > 0) {
                    if ([weakSelf.downloadMedicalCasesCTImages count] <= MaxDownLoadCount) {
                        for (int i=0; i < [weakSelf.downloadMedicalCasesCTImages count]; i++) {
                            [weakSelf.curDownLoadMc addObject:[weakSelf.downloadMedicalCasesCTImages objectAtIndex:i]];
                        }
                    } else {
                        for (int i=0; i < MaxDownLoadCount; i++) {
                            [weakSelf.curDownLoadMc addObject:[weakSelf.downloadMedicalCasesCTImages objectAtIndex:i]];
                        }
                    }
                    [weakSelf downLoadCTLibImage];
                }
            }else{
                NSLog(@"获取会诊信息数据异常code:%ld",[respond.code integerValue]);
            }
        });
    } failure:^(NSError *error) {
        NSLog(@"CTLib_Error:%@",error);
    }];
}

#pragma mark -递归下载CT图片
- (void)downLoadCTLibImage{
    //下载CT图片
    __block UIImage *image = nil;
    
    for (CTLib *ctlib in self.curDownLoadMc) {
        @autoreleasepool {
            if (![PatientManager IsImageExisting:ctlib.ct_image]) {
                NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", SYNC_IMAGEDOWN, ctlib.ckeyid, ctlib.ct_image];
                
                image = [self getImageFromURL:urlImage];
                if (nil != image) {
                    NSString *key = [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                    NSLog(@"图片下载完成:%@ --- %@----key:%@",urlImage,[NSThread currentThread],key);
                }
            }
        }
    }
    
    for (int i=0; i<[self.curDownLoadMc count]; i++) {
        [self.downloadMedicalCasesCTImages removeObject:[self.curDownLoadMc objectAtIndex:i]];
    }
    [self.curDownLoadMc removeAllObjects];
    
    if ([self.downloadMedicalCasesCTImages count] != 0) {
        if ([self.downloadMedicalCasesCTImages count] <= MaxDownLoadCount) {
            for (int i=0; i < [self.downloadMedicalCasesCTImages count]; i++) {
                [self.curDownLoadMc addObject:[self.downloadMedicalCasesCTImages objectAtIndex:i]];
            }
        } else {
            for (int i=0; i < MaxDownLoadCount; i++) {
                [self.curDownLoadMc addObject:[self.downloadMedicalCasesCTImages objectAtIndex:i]];
            }
        }
        [self downLoadCTLibImage];
    } else {
        return;
    }
    
}

@end

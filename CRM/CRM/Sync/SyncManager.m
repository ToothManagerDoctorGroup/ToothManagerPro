//
//  SyncManager.m
//  CRM
//
//  Created by du leiming on 9/9/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "SyncManager.h"
#import "AFNetworkReachabilityManager.h"
#import "CRMHttpRequest+Sync.h"
#import "DBManager+sync.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperation.h"

@interface SyncManager() <dataSyncResult>
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager;
    
}

- (void)startSync;

@property (nonatomic, strong)NSMutableArray *tableNameArr;
@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation SyncManager
Realize_ShareInstance(SyncManager);

- (NSMutableArray *)tableNameArr{
    if (!_tableNameArr) {
        _tableNameArr = [NSMutableArray array];
    }
    return _tableNameArr;
}

- (BOOL)opendSync
{
    afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"not network");
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wifi network");
                //检查是否有未同步的项，进行同步
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"data network");
                //检查是否设置了
                
                break;
            }
                
            default:
                break;
        }
        
    }];
    
    [CRMHttpRequest shareInstance].delegate = self;
    
    return YES;
}


- (void)startSync {
    self.syncGetCount = 0;
    self.syncGetFailCount = 0;
    self.syncGetSuccessCount = 0;
    
#pragma mark - **************************GCD实现多线程的下载操作*****************
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getMaterialTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getIntroducerTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getReserverecordTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getPatIntrMapTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getRepairDoctorTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getDoctorTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getPatientTable];
}

#pragma mark - 网络状态的实时检测；
- (BOOL)networkAvailable
{
    NSUserDefaults *userDefalut = [NSUserDefaults standardUserDefaults];
    NSInteger wifi = [userDefalut integerForKey:@"WifiIsOn"];

    if (wifi == 0)
    {
        return [AFNetworkReachabilityManager sharedManager].isReachable;
    }
    else
    {
        return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
    }
    
}

#pragma mark - dataSycn protocol
- (void)dataSycnResultWithTable:(NSString *)TableId isSucesseful:(BOOL)isSucesseful{
    [self.tableNameArr addObject:TableId];
    
    if ([TableId isEqualToString:DoctorTableName]) {
//        [SVProgressHUD showWithStatus:@"医生信息同步成功..."];
        
    }else if ([TableId isEqualToString:MaterialTableName]){
//        [SVProgressHUD showWithStatus:@"材料信息同步成功..."];
    
    }else if ([TableId isEqualToString:IntroducerTableName]){
//        [SVProgressHUD showWithStatus:@"介绍人信息同步成功..."];
        
    }else if ([TableId isEqualToString:PatientTableName]){
//        [SVProgressHUD showWithStatus:@"患者信息同步成功..."];
        
    }else if ([TableId isEqualToString:LocalNotificationTableName]){
//        [SVProgressHUD showWithStatus:@"预约信息同步成功..."];
        
    }else if ([TableId isEqualToString:PatIntrMapTableName]){
//        [SVProgressHUD showWithStatus:@"患者介绍人同步成功..."];
        
    }else if ([TableId isEqualToString:RepairDocTableName]){
//        [SVProgressHUD showWithStatus:@"修复医生信息同步成功..."];
        
    }else if ([TableId isEqualToString:CTLibTableName]){
//        [SVProgressHUD showWithStatus:@"CT信息同步成功..."];
        
    }else if ([TableId isEqualToString:MedicalCaseTableName]){
//        [SVProgressHUD showWithStatus:@"病历信息同步成功..."];
        
    }else if ([TableId isEqualToString:MedicalExpenseTableName]){
//        [SVProgressHUD showWithStatus:@"费用信息同步成功..."];
        
    }else if ([TableId isEqualToString:MedicalRecordableName]){
//        [SVProgressHUD showWithStatus:@"病历记录信息同步成功..."];
        
    }else if ([TableId isEqualToString:PatientConsultationTableName]){
//        [SVProgressHUD showWithStatus:@"会诊信息同步成功..."];
    }
    
    /**
     *  同步成功的表:(
         "repair_doctor_version2",
         "material_version2",
         "introducer_version2",
         "local_notificaion_version2",
         "doctor_version2",
         "patient_introducer_map_version2",
         "patient_version2",
         "patient_consultation_version2",
         "medical_case_version2",
         "medical_expense_version2",
         "ct_lib_version2"
         )
     */
    
//    if (self.tableNameArr.count == 11) {
//        //同步成功
//        [SVProgressHUD dismiss];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
//    }
    
    NSLog(@"同步成功数据:%lu",(unsigned long)self.tableNameArr.count);
    NSLog(@"同步成功的表:%@",self.tableNameArr);
    NSLog(@"下载数据请求的次数:%ld",(long)self.syncGetCount);
    NSLog(@"请求成功的次数%ld",(long)self.syncGetSuccessCount);
    NSLog(@"请求失败的次数%ld",(long)self.syncGetFailCount);
    
    /*
    if ([TableId isEqualToString:DoctorTableName]) {
        [SVProgressHUD showWithStatus:@"医生信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getMaterialTable];
    }
    if([TableId isEqualToString:MaterialTableName]){
        [SVProgressHUD showWithStatus:@"耗材信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getIntroducerTable];
    }
    if([TableId isEqualToString:IntroducerTableName]){
        [SVProgressHUD showWithStatus:@"介绍人信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getReserverecordTable];
    }
    if([TableId isEqualToString:LocalNotificationTableName]){
        [SVProgressHUD showWithStatus:@"预约信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getPatIntrMapTable];
        
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getRepairDoctorTable];
    }
    if([TableId isEqualToString:RepairDocTableName]){
        [SVProgressHUD showWithStatus:@"修复医生信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getPatientConsulationTable];
    }
    if([TableId isEqualToString:PatientConsultationTableName]){
        [SVProgressHUD showWithStatus:@"会诊信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [SVProgressHUD showWithStatus:@"患者信息同步成功..."];
        [NSThread sleepForTimeInterval: 0.5];
        [[CRMHttpRequest shareInstance] getPatientTable];
    }
    */
}


@end

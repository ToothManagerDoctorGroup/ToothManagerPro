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
    
    /*
    //目前的设计是手工同步不需要检查网络状态
#if 0
     if(![self networkAvailable])
     {
          NSLog(@"network unavailable");
         return;
     }
#endif
    
//    //upload patient
     NSArray *recordArray = [NSMutableArray arrayWithArray:[[DBManager shareInstance] getAllNeedSyncPatient]];
     if (0 != [recordArray count])
     {
         
        [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
     }
#if 1
     recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncPatient]];
    
     if (0 != [recordArray count])
     {
         
        [[CRMHttpRequest shareInstance] editAllNeedSyncPatient:recordArray];
         [NSThread sleepForTimeInterval: 0.5];
     }

     recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncPatient]];
    
     if (0 != [recordArray count])
     {
         
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncPatient:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
         
     }

    //upload material

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncMaterial]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncMaterial:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncMaterial]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncMaterial:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncMaterial]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncMaterial:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    //upload introducer
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncIntroducer]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncIntroducer:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncIntroducer]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncIntroducer:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }


    //upload medical_case
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncMedical_case]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncMedical_case:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncMedical_case]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncMedical_case:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncMedical_case]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncMedical_case:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    //upload ct_lib
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncCt_lib]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncCt_lib:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncCt_lib]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncCt_lib:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncCt_lib]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncCt_lib:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    //upload medical_expense
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncMedical_expense]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncMedical_expense:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncMedical_expense]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncMedical_expense:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncMedical_expense]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncMedical_expense:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    //upload medical_record
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncMedical_record]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncMedical_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncMedical_record]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncMedical_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncMedical_record]];
    
    if (0 != [recordArray count])
    {
        
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncMedical_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
#endif
    //upload loclal notification
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncLocal_Notification]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncReserve_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncLocal_Notification]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncReserve_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncLocal_Notification]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncReserve_record:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    //upload repair doctor
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncRepair_Doctor]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncRepair_doctor:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncRepair_Doctor]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncRepair_Doctor:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncRepair_Doctor]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncRepair_doctor:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }

    
    //upload patientconsultation
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncPatient_consultation]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] postAllNeedSyncPatient_consultation:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllEditNeedSyncPatient_consultation]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] editAllNeedSyncPatient_consultation:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllDeleteNeedSyncPatient_consultation]];
    
    if (0 != [recordArray count])
    {
        
        [[CRMHttpRequest shareInstance] deleteAllNeedSyncPatient_consultation:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    
    
    //upload patientintroducermap
    recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncPatientIntroducerMap]];
    
    if (0 != [recordArray count])
    {

        [[CRMHttpRequest shareInstance] postAllNeedSyncPatientIntroducerMap:recordArray];
        [NSThread sleepForTimeInterval: 0.5];
    }
     
*/
//download
    
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
    
//    //开启一个全局队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////    dispatch_queue_t queue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
//    dispatch_async(queue, ^{
//        //添加多线程进行下载操作
//        // 创建一个组
//        dispatch_group_t group = dispatch_group_create();
//        // 关联一个任务到group
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            [[CRMHttpRequest shareInstance] getMaterialTable];
//        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            
//            [[CRMHttpRequest shareInstance] getIntroducerTable];
//        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            [[CRMHttpRequest shareInstance] getReserverecordTable];
//        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            [[CRMHttpRequest shareInstance] getPatIntrMapTable];
//            
//        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            
//            [[CRMHttpRequest shareInstance] getRepairDoctorTable];
//        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            [[CRMHttpRequest shareInstance] getDoctorTable];
//        });
//        
////        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////            [NSThread sleepForTimeInterval: 0.5];
////            [[CRMHttpRequest shareInstance] getPatientConsulationTable];
////        });
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [NSThread sleepForTimeInterval: 0.2];
//            [[CRMHttpRequest shareInstance] getPatientTable];
//            
//        });
//    });
    
#pragma mark - **************************GCD实现多线程的下载操作*****************

//    [NSThread sleepForTimeInterval: 0.5];
//    [[CRMHttpRequest shareInstance] getDoctorTable];
//    
//    [NSThread sleepForTimeInterval: 0.5];
//
//    [[CRMHttpRequest shareInstance] getMaterialTable];
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    
//    [[CRMHttpRequest shareInstance] getIntroducerTable];
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    [[CRMHttpRequest shareInstance] getReserverecordTable];
//
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    [[CRMHttpRequest shareInstance] getPatIntrMapTable];
//
//    [NSThread sleepForTimeInterval: 0.5];
//    [[CRMHttpRequest shareInstance] getRepairDoctorTable];
//
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    [[CRMHttpRequest shareInstance] getPatientConsulationTable];
//
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    
//    [[CRMHttpRequest shareInstance] getPatientTable];
//    
//    [NSThread sleepForTimeInterval: 0.5];
    
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"tongbu" object:nil];
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

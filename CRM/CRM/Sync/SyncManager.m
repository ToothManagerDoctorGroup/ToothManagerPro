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


@interface SyncManager() <dataSyncResult>
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager;
    
}

- (void)startSync;

@end

@implementation SyncManager
Realize_ShareInstance(SyncManager);

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
    
    //目前的设计是手工同步不需要检查网络状态
#if 0
     if(![self networkAvailable])
     {
          NSLog(@"network unavailable");
         return;
     }
#endif
//    //upload patient
//    
//    //[SVProgressHUD showWithStatus:@"同步中..."];
//    
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
     

//download
    
    
//
    [NSThread sleepForTimeInterval: 0.5];
    [[CRMHttpRequest shareInstance] getDoctorTable];
    
    
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
    
//    [NSThread sleepForTimeInterval: 0.5];
//    
//    [NSThread sleepForTimeInterval: 0.5];
//    
//    [NSThread sleepForTimeInterval: 0.5]; 
//    
//    [NSThread sleepForTimeInterval: 0.5];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[CRMHttpRequest shareInstance]getPatientConsulationTable];
    
    [NSThread sleepForTimeInterval: 0.5]; 
    
    [[CRMHttpRequest shareInstance] getPatientTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    
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
    NSLog(@"ok");
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

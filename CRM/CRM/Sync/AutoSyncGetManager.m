//
//  AutoSyncGetManager.m
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AutoSyncGetManager.h"
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
#import "XLAutoGetSyncTool.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperation.h"

@implementation AutoSyncGetManager

Realize_ShareInstance(AutoSyncGetManager);

- (void)startSyncGet{
    
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 // 未知状态
                 NSLog(@"未知");
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 // 无网络
                 NSLog(@"无网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 // 手机自带网络
                 NSLog(@"手机自带网络");
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 // 当有wifi情况下自动进行同步
                 [weakSelf autoSyncGet];
                 break;
             default:
                 break;
         }
     }];
}

- (void)autoSyncGet{
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getMaterialTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getIntroducerTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getReserverecordTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getPatIntrMapTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getRepairDoctorTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getDoctorTable];
    
    [NSThread sleepForTimeInterval: 0.5];
    [[XLAutoGetSyncTool shareInstance] getPatientTable];
    
    
//    NSURL *url2 = [NSURL URLWithString:@"http://www.sohu.com"];
//    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
//    AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
//    
//    [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"Response2: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"Error: %@", error);
//        
//    }];
}

@end

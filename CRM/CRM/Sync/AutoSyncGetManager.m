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

- (void)startSyncGetShowSuccess:(BOOL)showSuccess{
    [[XLAutoGetSyncTool shareInstance] getAllDataShowSuccess:showSuccess];
}

@end

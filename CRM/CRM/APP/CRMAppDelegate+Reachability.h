//
//  CRMAppDelegate+Reachability.h
//  CRM
//
//  Created by Argo Zhang on 16/1/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate.h"
/**
 *  网络实时监控
 */
@interface CRMAppDelegate (Reachability)

- (void)addNetWorkNotification;

- (void)removeNetWorkNotification;
@end

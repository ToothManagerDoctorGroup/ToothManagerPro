//
//  CRMAppDelegate+Reachability.m
//  CRM
//
//  Created by Argo Zhang on 16/1/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate+Reachability.h"

@implementation CRMAppDelegate (Reachability)

- (void)addNetWorkNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    self.connectionStatus = [self.conn currentReachabilityStatus];
    [self.conn startNotifier];
    
}

- (void)removeNetWorkNotification{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)noti{
    
    Reachability * reach = [noti object];
    NetworkStatus status = [reach currentReachabilityStatus];

    // 3.判断网络状态
    if (status == ReachableViaWiFi) { // 有wifi
        NSLog(@"有wifi");
    } else if (status == ReachableViaWWAN) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
    } else { // 没有网络
        NSLog(@"当前无网络");
    }
    self.connectionStatus = status;
}
@end

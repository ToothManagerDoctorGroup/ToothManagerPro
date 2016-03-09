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
    [self.conn startNotifier];
    
}

- (void)removeNetWorkNotification{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *)noti{
    
    Reachability * reach = [noti object];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    // 1.检测wifi状态
//    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
//    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if (status == ReachableViaWiFi) { // 有wifi
        NSLog(@"有wifi");
//        self.connectionStatus = [wifi currentReachabilityStatus];
    } else if (status == ReachableViaWWAN) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
//        self.connectionStatus = [conn currentReachabilityStatus];
    } else { // 没有网络
        NSLog(@"当前无网络");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无网络，请选择网络后重新打开此页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
        
    }
    self.connectionStatus = status;
    
    
}
@end

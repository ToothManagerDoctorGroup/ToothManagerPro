//
//  TimTabBarViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimTabBarViewController : UITabBarController{
    EMConnectionState _connectionState;
}

- (void)networkChanged:(EMConnectionState)connectionState;
- (void)jumpToChatList;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)closeAllTimer;

@property (nonatomic, assign)BOOL executeSyncAction;//是否自动执行同步操作
@property (nonatomic, assign)BOOL isLoginFromOthers;//是否从其它地方登录
@end

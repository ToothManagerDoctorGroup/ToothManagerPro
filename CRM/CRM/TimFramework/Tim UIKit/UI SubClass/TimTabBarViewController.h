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

@end

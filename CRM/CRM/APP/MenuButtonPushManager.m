//
//  MenuButtonPushManager.m
//  CRM
//
//  Created by lsz on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MenuButtonPushManager.h"
#import "AddReminderViewController.h"
#import "AccountManager.h"
#import "AppoinmentMenuViewController.h"
#import "XLSelectYuyueViewController.h"
#import "XLQrcodePatientViewController.h"

@implementation MenuButtonPushManager
-(void)yuyueButtonDidSelected{
    
    XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
    selectYuyeVc.hidesBottomBarWhenPushed = YES;
    selectYuyeVc.isHome = YES;
    [self.viewController pushViewController:selectYuyeVc animated:YES];
    
}
-(void)huanzheButtonDidSeleted{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLQrcodePatientViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLQrcodePatientViewController"];
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:qrVC animated:YES];
}
@end

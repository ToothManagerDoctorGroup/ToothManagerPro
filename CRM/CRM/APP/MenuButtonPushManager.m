//
//  MenuButtonPushManager.m
//  CRM
//
//  Created by lsz on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MenuButtonPushManager.h"
#import "AddReminderViewController.h"
#import "QrCodePatientViewController.h"

@implementation MenuButtonPushManager
-(void)yuyueButtonDidSelected{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
    addReminderVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:addReminderVC animated:YES];
}
-(void)huanzheButtonDidSeleted{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    QrCodePatientViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodePatientViewController"];
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:qrVC animated:YES];
}
@end

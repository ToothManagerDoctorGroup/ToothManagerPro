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
#import "AccountManager.h"
#import "UserInfoViewController.h"
#import "AppoinmentMenuViewController.h"
#import "XLSelectYuyueViewController.h"

@implementation MenuButtonPushManager
-(void)yuyueButtonDidSelected{
    
    if ([[AccountManager shareInstance] currentUser].hospitalName == NULL || ![[[AccountManager shareInstance] currentUser].hospitalName isNotEmpty]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有设置所在医院，是否前往设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
        alertView.tag = 200;
        [alertView show];
        return;
    }
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
//    addReminderVC.hidesBottomBarWhenPushed = YES;
//    [self.viewController pushViewController:addReminderVC animated:YES];
    
    
//    AppoinmentMenuViewController *appointVc = [[AppoinmentMenuViewController alloc] init];
//    appointVc.hidesBottomBarWhenPushed = YES;
//    [self.viewController pushViewController:appointVc animated:YES];
    
    XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
    selectYuyeVc.hidesBottomBarWhenPushed = YES;
    selectYuyeVc.isHome = YES;
    [self.viewController pushViewController:selectYuyeVc animated:YES];
    
}
-(void)huanzheButtonDidSeleted{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    QrCodePatientViewController *qrVC = [storyBoard instantiateViewControllerWithIdentifier:@"QrCodePatientViewController"];
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.viewController pushViewController:qrVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //取消
    }else{
        //编辑个人信息
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        userInfoVC.hidesBottomBarWhenPushed = YES;
        [self.viewController pushViewController:userInfoVC animated:YES];
    }
}
@end

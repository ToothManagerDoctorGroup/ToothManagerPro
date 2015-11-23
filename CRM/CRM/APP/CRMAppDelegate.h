//
//  AppDelegate.h
//  CRM
//
//  Created by TimTiger on 4/5/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MMDrawerController.h"
#import "BaiduMapHeader.h"


@interface CRMAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>{
    BMKMapManager* _mapManager; //百度地图定位
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  MMDrawerController *drawerController;

- (NSURL *)applicationDocumentsDirectory;

@property (strong,nonatomic) UITabBarController *tabBarController;

@end
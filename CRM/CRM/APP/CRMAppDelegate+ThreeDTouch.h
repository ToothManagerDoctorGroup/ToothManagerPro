//
//  CRMAppDelegate+ThreeDTouch.h
//  CRM
//
//  Created by Argo Zhang on 16/5/30.
//  Copyright © 2016年 TimTiger. All rights reserved.
//


#import "CRMAppDelegate.h"

#define ThreeDTouchSearchPatient @"ThreeDTouchSearchPatient"
#define ThreeDTouchAddPatient @"ThreeDTouchAddPatient"
#define ThreeDTouchAddReminder @"ThreeDTouchAddReminder"

@interface CRMAppDelegate (ThreeDTouch)

- (void)add3DViewWithApplication:(UIApplication *)application;

@end

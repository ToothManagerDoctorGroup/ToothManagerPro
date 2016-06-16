//
//  CRMAppDelegate+EaseMob.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate.h"

@interface CRMAppDelegate (EaseMob)

/**
 *  注册环信相关信息
 */
- (void)registerEaseMobConfigWithapplication:(UIApplication *)application options:(NSDictionary *)launchOptions;

@end

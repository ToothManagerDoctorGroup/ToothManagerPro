//
//  CRMAppDelegate+UMessage.h
//  CRM
//
//  Created by Argo Zhang on 16/3/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "CRMAppDelegate.h"

@interface CRMAppDelegate (UMessage)

/**
 *  注册友盟相关信息
 */
- (void)registerUMessageConfigWithOptions:(NSDictionary *)launchOptions;

@end

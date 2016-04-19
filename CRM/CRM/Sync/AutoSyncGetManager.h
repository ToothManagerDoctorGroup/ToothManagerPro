//
//  AutoSyncGetManager.h
//  CRM
//
//  Created by Argo Zhang on 15/12/31.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimFramework.h"

@interface AutoSyncGetManager : NSObject
Declare_ShareInstance(AutoSyncGetManager);

- (void)startSyncGetShowSuccess:(BOOL)showSuccess;

@end

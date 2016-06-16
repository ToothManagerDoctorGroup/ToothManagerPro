//
//  AutoSyncManager.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimFramework.h"

@interface AutoSyncManager : NSObject
Declare_ShareInstance(AutoSyncManager);

- (BOOL)startAutoSync;

@end

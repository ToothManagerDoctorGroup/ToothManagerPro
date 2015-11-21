//
//  SyncManager.h
//  CRM
//
//  Created by du leiming on 9/9/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimFramework.h"


@interface SyncManager : NSObject 

Declare_ShareInstance(SyncManager);

- (BOOL)networkAvailable;
- (BOOL)opendSync;
- (void)startSync;

@end

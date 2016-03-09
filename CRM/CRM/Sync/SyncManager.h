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

@property (nonatomic, assign)NSInteger syncGetCount;//下载的请求次数
@property (nonatomic, assign)NSInteger syncGetSuccessCount;//下载成功的请求次数
@property (nonatomic, assign)NSInteger syncGetFailCount;//下载失败的请求次数

@end

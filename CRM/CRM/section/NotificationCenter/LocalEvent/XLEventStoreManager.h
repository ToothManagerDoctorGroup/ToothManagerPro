//
//  XLEventStoreManager.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"

@class LocalNotification,Patient;
@interface XLEventStoreManager : NSObject
Declare_ShareInstance(XLEventStoreManager);

- (void)addEventToSystemCalendarWithLocalNotification:(LocalNotification *)noti patient:(Patient *)patient;

- (void)removeEventToSystemCalendarWithLocalNotification:(LocalNotification *)noti;
@end

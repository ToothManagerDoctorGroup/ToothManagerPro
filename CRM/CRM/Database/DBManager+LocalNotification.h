//
//  DBManager+LocalNotification.h
//  CRM
//
//  Created by TimTiger on 14-8-30.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DBManager.h"
#import "LocalNotificationCenter.h"

@interface DBManager (LocalNotification)

- (NSArray *)localNotificationListFormDB;

- (BOOL)insertLocalNotification:(LocalNotification *)notification;

- (BOOL)updateLocalNotificaiton:(LocalNotification *)notification;

- (BOOL)deleteLocalNotification:(LocalNotification *)notification;

- (BOOL)deleteLocalNotification_Sync:(LocalNotification *)notification;

- (LocalNotification *)getLocalNotificationWithCkeyId:(NSString *)ckeyId;

@end

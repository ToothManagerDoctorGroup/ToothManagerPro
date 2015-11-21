//
//  FriendNotification.h
//  CRM
//
//  Created by TimTiger on 3/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendNotification : NSObject<NSCopying,NSCoding>

@property (nonatomic, strong) NSMutableArray *result;

@end

@interface FriendNotificationItem : NSObject<NSCopying,NSCoding>
@property (nonatomic,copy) NSString *creation_time;
@property (nonatomic,copy) NSString *doctor_id;
@property (nonatomic,copy) NSString *doctor_name;
@property (nonatomic,copy) NSString *notification_content;
@property (nonatomic) NSNumber *notification_status;
@property (nonatomic) NSNumber *notification_type;
@property (nonatomic,copy) NSString *receiver_id;
@property (nonatomic,copy) NSString *receiver_name;

+ (FriendNotificationItem *)friendnotificationWithDic:(NSDictionary *)dic;

@end

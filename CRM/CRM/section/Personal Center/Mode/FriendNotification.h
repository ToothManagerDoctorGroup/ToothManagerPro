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

/**
 *  {
 "creation_time" = "2016-01-06 09:58:19";
 "doctor_id" = 598;
 "doctor_image" = "598.jpg";
 "doctor_name" = "\U5c39\U4e03\U6c11";
 keyid = 745;
 "notification_content" = "\U7533\U8bf7\U6210\U4e3a\U597d\U53cb";
 "notification_status" = 0;
 "notification_type" = 1;
 "receiver_id" = 970;
 "receiver_name" = "\U5f90\U6653\U9f99";
 }
 */

@interface FriendNotificationItem : NSObject<NSCopying,NSCoding>
@property (nonatomic,copy) NSString *creation_time;
@property (nonatomic,copy) NSString *doctor_id;
@property (nonatomic, copy)NSString *doctor_image;
@property (nonatomic,copy) NSString *doctor_name;
@property (nonatomic,copy) NSString *notification_content;
@property (nonatomic) NSNumber *notification_status;
@property (nonatomic) NSNumber *notification_type;
@property (nonatomic,copy) NSString *receiver_id;
@property (nonatomic,copy) NSString *receiver_name;
@property (nonatomic, copy)NSString *receiver_image;

+ (FriendNotificationItem *)friendnotificationWithDic:(NSDictionary *)dic;

@end

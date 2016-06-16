//
//  FriendNotification.m
//  CRM
//
//  Created by TimTiger on 3/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "FriendNotification.h"
#import "NSDictionary+Extension.h"

@implementation FriendNotification

- (id)init
{
    self = [super init];
    if (self) {
        self.result = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.result = [aDecoder decodeObjectForKey:@"result"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_result forKey:@"result"];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    FriendNotification *copy = [[[self class]allocWithZone:zone]init];
    _result = [self.result copy];
    return copy;
}


@end

@implementation FriendNotificationItem

+ (FriendNotificationItem *)friendnotificationWithDic:(NSDictionary *)dic {
    FriendNotificationItem *fnotificationItem = [[FriendNotificationItem alloc] init];
    fnotificationItem.creation_time = [dic stringForKey:@"creation_time"];
    fnotificationItem.doctor_id = [dic stringForKey:@"doctor_id"];
    fnotificationItem.doctor_image = [dic stringForKey:@"doctor_image"];
    fnotificationItem.doctor_name = [dic stringForKey:@"doctor_name"];
    fnotificationItem.notification_content = [dic stringForKey:@"notification_content"];
    fnotificationItem.notification_status =[NSNumber numberWithInteger: [dic integerForKey:@"notification_status"]];
    fnotificationItem.notification_type = [NSNumber numberWithInteger:[dic integerForKey:@"notification_type"]];
    fnotificationItem.receiver_id = [dic stringForKey:@"receiver_id"];
    fnotificationItem.receiver_name = [dic stringForKey:@"receiver_name"];
    fnotificationItem.receiver_image = [dic stringForKey:@"receiver_image"];
    return fnotificationItem;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.creation_time = [aDecoder decodeObjectForKey:@"creation_time"];
        self.doctor_id = [aDecoder decodeObjectForKey:@"doctor_id"];
        self.doctor_name = [aDecoder decodeObjectForKey:@"doctor_name"];
        self.notification_content = [aDecoder decodeObjectForKey:@"notification_content"];
        self.notification_status = [aDecoder decodeObjectForKey:@"notification_status"];
        self.notification_type = [aDecoder decodeObjectForKey:@"notification_type"];
        self.receiver_id = [aDecoder decodeObjectForKey:@"receiver_id"];
        self.receiver_name = [aDecoder decodeObjectForKey:@"patientreceiver_names"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.creation_time forKey:@"creation_time"];
    [aCoder encodeObject:self.doctor_id forKey:@"doctor_id"];
    [aCoder encodeObject:self.doctor_name forKey:@"doctor_name"];
    [aCoder encodeObject:self.notification_content forKey:@"notification_content"];
    [aCoder encodeObject:self.notification_status forKey:@"notification_status"];
    [aCoder encodeObject:self.notification_type forKey:@"notification_type"];
    [aCoder encodeObject:self.receiver_id forKey:@"receiver_id"];
    [aCoder encodeObject:self.receiver_name forKey:@"receiver_name"];
}

#pragma mark -
#pragma mark NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    FriendNotificationItem *copy = [[[self class] allocWithZone:zone]init];
    _creation_time = [self.creation_time copy];
    _doctor_id = [self.doctor_id copy];
    _doctor_name = [self.doctor_name copy];
    _notification_content = [self.notification_content copy];
    _notification_status = [self.notification_status copy];
    _notification_type = [self.notification_type copy];
    _receiver_id = [self.receiver_id copy];
    _receiver_name = [self.receiver_name copy];
    
    return copy;
}


@end

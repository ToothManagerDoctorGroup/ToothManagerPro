//
//  InPatientNotification.m
//  CRM
//
//  Created by fankejun on 15/5/6.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "InPatientNotification.h"
#import "NSDictionary+Extension.h"

@implementation InPatientNotification
@synthesize result;

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
    [aCoder encodeObject:result forKey:@"result"];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    InPatientNotification *copy = [[[self class]allocWithZone:zone]init];
    result = [self.result copy];
    return copy;
}

@end

@implementation InPatientNotificationItem

+ (InPatientNotificationItem *)inpatientNotificationWithDic:(NSDictionary *)dic {
    InPatientNotificationItem *innotificationItem = [[InPatientNotificationItem alloc] init];
    innotificationItem.patient_id = [dic stringForKey:@"patient_id"];
    innotificationItem.patient_name = [dic stringForKey:@"patient_name"];
    innotificationItem.doctor_info_id = [dic stringForKey:@"doctor_info_id"];
    innotificationItem.doctor_info_name = [dic stringForKey:@"doctor_info_name"];
    innotificationItem.intro_time = [dic stringForKey:@"intro_time"];
    innotificationItem.doctor_info_image = [dic stringForKey:@"doctor_info_image"];
    innotificationItem.patient_count = [dic stringForKey:@"patient_count"];
    innotificationItem.patients = [dic stringForKey:@"patients"];
    return innotificationItem;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.patient_id = [aDecoder decodeObjectForKey:@"patient_id"];
        self.patient_name = [aDecoder decodeObjectForKey:@"patient_name"];
        self.doctor_info_id = [aDecoder decodeObjectForKey:@"doctor_info_id"];
        self.doctor_info_name = [aDecoder decodeObjectForKey:@"doctor_info_name"];
        self.intro_time = [aDecoder decodeObjectForKey:@"intro_time"];
        self.doctor_info_image = [aDecoder decodeObjectForKey:@"doctor_info_image"];
        self.patient_count = [aDecoder decodeObjectForKey:@"patient_count"];
        self.patients = [aDecoder decodeObjectForKey:@"patients"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.patient_id forKey:@"patient_id"];
    [aCoder encodeObject:self.patient_name forKey:@"patient_name"];
    [aCoder encodeObject:self.doctor_info_id forKey:@"doctor_info_id"];
    [aCoder encodeObject:self.doctor_info_name forKey:@"doctor_info_name"];
    [aCoder encodeObject:self.intro_time forKey:@"intro_time"];
    [aCoder encodeObject:self.doctor_info_image forKey:@"doctor_info_image"];
    [aCoder encodeObject:self.patient_count forKey:@"patient_count"];
    [aCoder encodeObject:self.patients forKey:@"patients"];
}

#pragma mark -
#pragma mark NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    InPatientNotificationItem *copy = [[[self class] allocWithZone:zone]init];
    _patient_id = [self.patient_id copy];
    _patient_name = [self.patient_name copy];
    _doctor_info_id = [self.doctor_info_id copy];
    _doctor_info_name = [self.doctor_info_name copy];
    _intro_time = [self.intro_time copy];
    _doctor_info_image = [self.doctor_info_image copy];
    _patient_count = [self.patient_count copy];
    _patients = [self.patients copy];
    return copy;
}

@end
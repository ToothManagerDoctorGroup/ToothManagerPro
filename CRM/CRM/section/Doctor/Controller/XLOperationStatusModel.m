//
//  XLOperationStatusModel.m
//  CRM
//
//  Created by Argo Zhang on 16/5/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLOperationStatusModel.h"
#import "MJExtension.h"

@implementation XLOperationStatusModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"business" : @"Business",
             @"seatList" : @"SeatList",
             @"timeList" : @"TimeList"};
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"business" : [XLBusiness class],
             @"seatList" : [XLSeatInfo class],
             @"timeList" : [XLOccupyTime class]
             };
}

@end


@implementation XLBusiness

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"clinicId" : @"ClinicId",
             @"businessHours" : @"BusinessHours",
             @"businessWeek" : @"BusinessWeek"};
}

@end

@implementation XLSeatInfo

@end

@implementation XLOccupyTime

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"clinicId" : @"ClinicId",
             @"seatId" : @"SeatId",
             @"reserveTime" : @"ReserveTime",
             @"reserveDuration" : @"ReserveDuration"};
}

@end
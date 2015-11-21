//
//  ClinicDetailModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicDetailModel.h"
#import "ClinicImageModel.h"
#import "SeatModel.h"

@implementation ClinicDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"ClinicInfo":[ClinicImageModel class],@"Seats":[SeatModel class]};
}

@end

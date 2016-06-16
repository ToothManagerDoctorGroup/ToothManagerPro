//
//  SysMessageModel.m
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SysMessageModel.h"
#import "MJExtension.h"

//新增患者
NSString *const AttainNewPatient = @"AttainNewPatient";
//新的好友
NSString *const AttainNewFriend = @"AttainNewFriend";
//取消预约
NSString *const CancelReserveRecord = @"CancelReserveRecord";
//修改预约
NSString *const UpdateReserveRecord = @"UpdateReserveRecord";
//新增预约
NSString *const InsertReserveRecord = @"InsertReserveRecord";
//诊所预约
NSString *const ClinicReserver = @"ClinicReserver";

@implementation SysMessageModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

@end

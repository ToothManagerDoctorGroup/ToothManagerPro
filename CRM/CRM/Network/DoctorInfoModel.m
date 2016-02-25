//
//  DoctorInfoModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorInfoModel.h"

@implementation DoctorInfoModel
MJCodingImplementation

+ (instancetype)shareDcotorInfo{
    static DoctorInfoModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DoctorInfoModel alloc] init];
    });
    return instance;
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyID" : @"KeyID"};
}


@end

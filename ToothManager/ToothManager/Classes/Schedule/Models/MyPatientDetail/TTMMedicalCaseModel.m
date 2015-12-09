//
//  TTMMedicalCaseModel.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMMedicalCaseModel.h"

@implementation TTMMedicalCaseModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

+ (NSArray *)ignoredPropertyNames{
    return @[@"ctLibs"];
}

@end

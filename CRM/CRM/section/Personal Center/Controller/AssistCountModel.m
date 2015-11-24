//
//  AssistCountModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AssistCountModel.h"

@implementation AssistCountModel

+ (NSArray *)ignoredPropertyNames{
    return @[@"num"];
}
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

@end

//
//  XLCureProjectModel.m
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCureProjectModel.h"
#import "MJExtension.h"

@implementation XLCureProjectModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

+ (NSArray *)ignoredPropertyNames{
    return @[@"step"];
}

- (NSString *)end_date{
    if ([_end_date isEqualToString:@"0001-01-01 00:00:00"]) {
        return @"";
    }else{
        return _end_date;
    }
}

@end

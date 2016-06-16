//
//  XLBehaviourModel.m
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBehaviourModel.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"

@implementation XLBehaviourModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyId" : @"KeyId"};
}

- (instancetype)initWithActionType:(NSString *)actionType
                          dataType:(NSString *)dataType
                            dataId:(NSString *)dataId
                           jsonStr:(NSString *)jsonStr{
    if (self = [super init]) {
        self.doctor_id = [AccountManager currentUserid];
        self.action_type = actionType;
        self.data_type = dataType;
        self.data_id = dataId;
        self.device_token = [CRMUserDefalut objectForKey:DeviceToken];
        self.json_str = jsonStr;
    }
    return self;
}


- (NSString *)paramToJosnString{
    return [self.keyValues JSONString];
}

@end

//
//  XLAdviceDetailModel.m
//  CRM
//
//  Created by Argo Zhang on 16/4/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviceDetailModel.h"
#import "DBTableMode.h"
#import "CRMUserDefalut.h"
#import "MyDateTool.h"

@implementation XLAdviceDetailModel

- (instancetype)initWithName:(NSString *)name adviceTypeId:(NSNumber *)adviceTypeId adviceTypeName:(NSString *)adviceTypeName contentType:(NSString *)contentType content:(NSString *)content{
    if (self = [super init]) {
        self.ckeyid = [self createCkeyId];
        self.a_name = name;
        self.advice_type_id = adviceTypeId;
        self.advice_type_name = adviceTypeName;
        self.content_type = contentType;
        self.a_content = content;
        self.creation_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
        self.doctor_id = [CRMUserDefalut latestUserId];
    }
    return self;
}


//创建cekyid
- (NSString *)createCkeyId {
    NSString *ckeyid = [CRMUserDefalut latestUserId];
    if ([NSString isEmptyString:ckeyid]) {
        ckeyid = @"";
    }
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]*1000];
    ckeyid = [ckeyid stringByAppendingString:@"_"];
    ckeyid = [ckeyid stringByAppendingString:timeString];
    return ckeyid;
}

@end

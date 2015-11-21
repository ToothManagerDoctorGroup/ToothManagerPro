//
//  CRMHttpRespond.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "CRMHttpRespondModel.h"

@implementation CRMHttpRespondModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"code" : @"Code",@"result" : @"Result"};
}

@end

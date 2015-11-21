//
//  BillDetailModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "BillDetailModel.h"
#import "MaterialModel.h"
#import "AssistModel.h"

@implementation BillDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"materials":[MaterialModel class],@"assists":[AssistModel class],@"extras":[MaterialModel class]};
}

@end

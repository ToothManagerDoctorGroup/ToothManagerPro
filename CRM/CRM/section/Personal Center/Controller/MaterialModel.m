//
//  MaterialModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MaterialModel.h"
#import "MaterialCountModel.h"

@implementation MaterialModel


+ (instancetype)modelWithMaterialCountModel:(MaterialCountModel *)countModel{
    MaterialModel *model = [[self alloc] init];
    model.KeyId = countModel.keyId;
    model.reserve_id = @"";
    model.mat_id = @"";
    model.mat_name = countModel.mat_name;
    model.plan_num = @"";
    model.actual_num = [NSString stringWithFormat:@"%ld",(long)countModel.num];
    model.price = countModel.mat_price;
    model.plan_money = @"";
    model.actual_money = [NSString stringWithFormat:@"%f",countModel.num * [countModel.mat_price floatValue]];
    model.is_reserved = @"";
    return model;
}

@end

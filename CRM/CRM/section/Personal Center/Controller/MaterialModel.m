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
    model.KeyId = @"1";
    model.reserve_id = @"0";
    model.mat_id = countModel.keyId;
    model.mat_name = countModel.mat_name;
    model.plan_num = [NSString stringWithFormat:@"%ld",(long)countModel.num];
    model.actual_num = [NSString stringWithFormat:@"%ld",(long)countModel.num];
    model.price = countModel.mat_price;
    model.plan_money = [NSString stringWithFormat:@"%.2f",countModel.num * [countModel.mat_price floatValue]];
    model.actual_money = [NSString stringWithFormat:@"%.2f",countModel.num * [countModel.mat_price floatValue]];
    model.is_reserved = @"1";
    return model;
}

@end

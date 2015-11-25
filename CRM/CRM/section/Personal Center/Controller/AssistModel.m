//
//  AssistModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AssistModel.h"
#import "AssistCountModel.h"

/*"KeyId": 2,
 "assist_name": "研究生",
 "assist_price": 260,
 "assist_type": "研究生",
 "creation_time": "0001-01-01 00:00:00",
 "data_flag": 0
 
 @property (nonatomic, copy)NSString *KeyId;
 @property (nonatomic, copy)NSString *reserve_id;
 @property (nonatomic, copy)NSString *assist_id;
 @property (nonatomic, copy)NSString *assist_name;
 @property (nonatomic, copy)NSString *plan_num;
 @property (nonatomic, copy)NSString *actual_num;
 @property (nonatomic, copy)NSString *price;
 @property (nonatomic, copy)NSString *plan_money;
 @property (nonatomic, copy)NSString *actual_money;
 @property (nonatomic, copy)NSString *is_reserved;
 */

@implementation AssistModel

+ (instancetype)modelWithAssistCountModel:(AssistCountModel *)countModel{
    AssistModel *model = [[self alloc] init];
    model.KeyId = @"1";
    model.reserve_id = @"0";
    model.assist_id = countModel.keyId;
    model.assist_name = countModel.assist_name;
    model.plan_num = [NSString stringWithFormat:@"%ld",(long)countModel.num];
    model.actual_num = [NSString stringWithFormat:@"%ld",(long)countModel.num];
    model.price = countModel.assist_price;
    model.plan_money = [NSString stringWithFormat:@"%.2f",countModel.num * [countModel.assist_price floatValue]];
    model.actual_money = [NSString stringWithFormat:@"%.2f",countModel.num * [countModel.assist_price floatValue]];
    model.is_reserved = @"1";
    return model;
}

@end

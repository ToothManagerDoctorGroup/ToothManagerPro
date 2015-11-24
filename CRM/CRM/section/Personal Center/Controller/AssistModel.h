//
//  AssistModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class AssistCountModel;
@interface AssistModel : NSObject<MJKeyValue>
/*
 "KeyId": 134,
 "reserve_id": 140,
 "assist_id": "1",
 "assist_name": "护士",
 "plan_num": 0,
 "actual_num": 1,
 "price": 200,
 "plan_money": 200,
 "actual_money": 200,
 "is_reserved": 1
 */

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

+ (instancetype)modelWithAssistCountModel:(AssistCountModel *)countModel;

@end

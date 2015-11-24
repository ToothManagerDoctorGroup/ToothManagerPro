//
//  MaterialModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class MaterialCountModel;
@interface MaterialModel : NSObject<MJKeyValue>


@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *reserve_id;
@property (nonatomic, copy)NSString *mat_id;
@property (nonatomic, copy)NSString *mat_name;
@property (nonatomic, copy)NSString *plan_num;
@property (nonatomic, copy)NSString *actual_num;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *plan_money;
@property (nonatomic, copy)NSString *actual_money;
@property (nonatomic, copy)NSString *is_reserved;

+ (instancetype)modelWithMaterialCountModel:(MaterialCountModel *)countModel;

@end

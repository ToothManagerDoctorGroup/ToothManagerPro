//
//  BillDetailModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDetailModel : NSObject

@property (nonatomic, strong)NSArray *materials;

@property (nonatomic, strong)NSArray *assists;

@property (nonatomic, copy)NSArray *extras;

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *doctor_id;
@property (nonatomic, copy)NSString *doctor_name;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *clinic_name;
@property (nonatomic, copy)NSString *seat_id;
@property (nonatomic, copy)NSString *seat_price;
@property (nonatomic, copy)NSString *seat_name;
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *patient_name;
@property (nonatomic, copy)NSString *tooth_position;
@property (nonatomic, copy)NSString *reserve_type;
@property (nonatomic, copy)NSString *reserve_time;
@property (nonatomic, copy)NSString *reserve_duration;
@property (nonatomic, copy)NSString *reserve_status;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *expert_result;
@property (nonatomic, copy)NSString *expert_suggestion;
@property (nonatomic, copy)NSString *seat_money;
@property (nonatomic, copy)NSString *material_money;
@property (nonatomic, copy)NSString *assist_money;
@property (nonatomic, copy)NSString *extra_money;
@property (nonatomic, copy)NSString *total_money;
@property (nonatomic, copy)NSString *actual_start_time;
@property (nonatomic, copy)NSString *actual_end_time;
@property (nonatomic, copy)NSString *used_time;


@end

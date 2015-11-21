//
//  BillModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface BillModel : NSObject<MJKeyValue>

/*
 "KeyId": 140,
 "clinic_id": 0,
 "clinic_name": "西京医院",
 "seat_id": 0,
 "seat_name": "1号",
 "patient_name": "黎威威",
 "type": "种植",
 "bill_time": "2015-10-09 17:00:00",
 "start_time": "2011-01-01 00:00:00",
 "use_time": 0,
 "total_money": 7715,
 "reserve_status": 0
 */

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *clinic_name;
@property (nonatomic, copy)NSString *seat_id;
@property (nonatomic, copy)NSString *seat_name;
@property (nonatomic, copy)NSString *patient_name;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *bill_time;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *use_time;
@property (nonatomic, copy)NSString *total_money;
@property (nonatomic, copy)NSString *reserve_status;

@end

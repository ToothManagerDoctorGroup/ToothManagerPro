//
//  SeatModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "KeyId": 1,
 "clinic_id": 1,
 "seat_name": "1号",
 "available": 0,
 "seat_id": "1",
 "seat_brand": "啊斯隆",
 "seat_desc": "就发个",
 "seat_tapwater": 1,
 "seat_distillwater": 1,
 "seat_ultrasound": 1,
 "seat_light": 1,
 "seat_price": 1500,
 "assistant_price": 5003
 */
@interface SeatModel : NSObject

//存放椅位基本信息
@property (nonatomic, strong)NSArray *SeatInfos;
//存放椅位的图片信息
@property (nonatomic, strong)NSArray *SeatImgInfos;

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *seat_name;
@property (nonatomic, copy)NSString *available;
@property (nonatomic, copy)NSString *seat_id;
@property (nonatomic, copy)NSString *seat_brand;
@property (nonatomic, copy)NSString *seat_desc;
@property (nonatomic, copy)NSString *seat_tapwater;
@property (nonatomic, copy)NSString *seat_distillwater;
@property (nonatomic, copy)NSString *seat_ultrasound;
@property (nonatomic, copy)NSString *seat_light;
@property (nonatomic, copy)NSString *seat_price;
@property (nonatomic, copy)NSString *assistant_price;



@end

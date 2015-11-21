//
//  SeatInfosModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "KeyId": 5,
 "seat_id": "1",
 "start_time": "0001-01-01 00:00:00",
 "end_time": "0001-01-01 00:00:00",
 "available_time": "中午11:00-12:00",
 "duation": "2",
 "remarks": "2"
 */
@interface SeatInfosModel : NSObject

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *seat_id;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *end_time;
@property (nonatomic, copy)NSString *available_time;
@property (nonatomic, copy)NSString *duation;
@property (nonatomic, copy)NSString *remarks;



@end

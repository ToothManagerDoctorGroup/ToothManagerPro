//
//  SeatImgInfosModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "KeyId": 54,
 "seat_id": "1",
 "img_info": "http://122.114.62.57/clinicServer/seat_info/1/ee7b7141-3d7d-4869-87a9-a37f8ff2b955.jpg",
 "remark": "S51029-105859.jpg"
 */
@interface SeatImgInfosModel : NSObject

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *seat_id;
@property (nonatomic, copy)NSString *img_info;
@property (nonatomic, copy)NSString *remark;

@end

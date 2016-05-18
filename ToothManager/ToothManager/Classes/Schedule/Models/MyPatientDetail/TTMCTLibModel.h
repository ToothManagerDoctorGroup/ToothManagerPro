//
//  TTMCTLibModel.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMCTLibModel : NSObject<MJKeyValue>

/**
 *  "KeyId": 4305,
 "patient_id": null,
 "case_id": "639_20151111145034",
 "ct_image": "1447224627748.jpg",
 "ct_desc": "",
 "creation_time": "0001-01-01 00:00:00",
 "doctor_id": 639,
 "ckeyid": "639_20151111145032",
 "sync_time": "2015-11-12 10:44:51"
 */
@property (nonatomic, assign)NSInteger keyId;
@property (nonatomic, copy)NSString *case_id;
@property (nonatomic, copy)NSString *ckeyid;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *ct_desc;
@property (nonatomic, copy)NSString *ct_image;
@property (nonatomic, copy)NSString *doctor_id;
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *sync_time;
@end

//
//  DoctorInfoModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
/*
     "KeyID": 121,
     "doctor_id": 162,
     "doctor_name": "尹建民",
     "doctor_gender": 0,
     "doctor_age": 0,
     "doctor_birthday": "1980-12-22 00:00:00",
     "doctor_skill": "",
     "doctor_cv": "",
     "doctor_image": "http://122.114.62.57/his.crm/avatar/162.jpg",
     "doctor_dept": "颌面外科",
     "doctor_phone": "12345",
     "doctor_hospital": "首都医科大学",
     "doctor_position": "主治医师",
     "doctor_degree": "硕士",
     "doctor_is_verified": 0,
     "doctor_verify_reason": "",
     "doctor_certificate": "",
     "is_expert": 0,
     "is_sign": 0,
     "is_open": 1,
     "creation_time": "2014-11-25 10:05:23",
     "ckeyid": "",
     "sync_time": "2015-11-18 11:29:51",
     "template_id": "U_DIY",
     "star_level": 5
 */
@interface DoctorInfoModel : NSObject<MJKeyValue,MJCoding>

@property (nonatomic, copy)NSString *KeyID;
@property (nonatomic, copy)NSString *doctor_id;
@property (nonatomic, copy)NSString *doctor_name;
@property (nonatomic, copy)NSString *doctor_gender;
@property (nonatomic, copy)NSString *doctor_age;
@property (nonatomic, copy)NSString *doctor_birthday;
@property (nonatomic, copy)NSString *doctor_skill;
@property (nonatomic, copy)NSString *doctor_cv;
@property (nonatomic, copy)NSString *doctor_image;
@property (nonatomic, copy)NSString *doctor_dept;
@property (nonatomic, copy)NSString *doctor_phone;
@property (nonatomic, copy)NSString *doctor_hospital;
@property (nonatomic, copy)NSString *doctor_position;
@property (nonatomic, copy)NSString *doctor_degree;
@property (nonatomic, copy)NSString *doctor_is_verified;
@property (nonatomic, copy)NSString *doctor_verify_reason;
@property (nonatomic, copy)NSString *doctor_certificate;
@property (nonatomic, copy)NSString *is_expert;
@property (nonatomic, copy)NSString *is_sign;
@property (nonatomic, copy)NSString *is_open;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *ckeyid;
@property (nonatomic, copy)NSString *sync_time;
@property (nonatomic, copy)NSString *template_id;
@property (nonatomic, copy)NSString *star_level;


+ (instancetype)shareDcotorInfo;

@end

//
//  TTMDoctorModel.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMDoctorModel : NSObject<MJKeyValue>

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


@end

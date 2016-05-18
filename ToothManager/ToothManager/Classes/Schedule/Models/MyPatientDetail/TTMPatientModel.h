//
//  TTMPatientModel.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMPatientModel : NSObject<MJKeyValue>
/**
 *  KeyId = 4630;
 ckeyid = "639_20151030180750";
 "creation_time" = "2015-10-30 18:09:50";
 "doctor_id" = 615;
 "intr_name" = "<null>";
 "introducer_id" = 639;
 "ori_doctor_id" = 0;
 "patient_address" = "";
 "patient_age" = 0;
 "patient_allergy" = "";
 "patient_avatar" = "";
 "patient_birthday" = "0001-01-01 00:00:00";
 "patient_gender" = 0;
 "patient_name" = "\U80d6\U5b50\U9ec4";
 "patient_phone" = 18310927054;
 "patient_remark" = "<null>";
 "patient_status" = 3;
 "sync_time" = "2015-11-24 14:09:04";
 "update_time" = "2015-11-24 14:09:04";
 */

@property (nonatomic, assign)NSInteger keyId;
@property (nonatomic, copy)NSString *ckeyid;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, assign)NSInteger doctor_id;
@property (nonatomic, copy)NSString *intr_name;
@property (nonatomic, assign)NSInteger introducer_id;
@property (nonatomic, assign)NSInteger ori_doctor_id;
@property (nonatomic, copy)NSString *patient_address;
@property (nonatomic, assign)NSInteger patient_age;
@property (nonatomic, copy)NSString *patient_allergy;
@property (nonatomic, copy)NSString *patient_avatar;
@property (nonatomic, copy)NSString *patient_birthday;
@property (nonatomic, assign)NSInteger patient_gender;
@property (nonatomic, copy)NSString *patient_name;
@property (nonatomic, copy)NSString *patient_phone;
@property (nonatomic, copy)NSString *patient_remark;
@property (nonatomic, assign)NSInteger patient_status;
@property (nonatomic, copy)NSString *sync_time;
@property (nonatomic, copy)NSString *update_time;
@property (nonatomic, copy)NSString *anamnesis;
@end

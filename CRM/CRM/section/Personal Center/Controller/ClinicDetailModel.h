//
//  ClinicDetailModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ClinicDetailModel : NSObject<MJKeyValue>
/*
"KeyId": 1,
"clinic_id": 1,
"clinic_name": "西京医院",
"clinic_img": "http://122.114.62.57/clinicServer/img/1_59.jpg",
"clinic_code": "",
"clinic_location": "武汉理工大学(南湖校区)",
"business_hours": "全天",
"clinic_phone": "888888888",
"longitude": 0,
"dimension": 0,
"pay_password": null,
"clinic_summary": null,
"clinic_area": null
 
*/

//存放椅位实景图:ClinicImageModel
@property (nonatomic, strong)NSArray *ClinicInfo;
//存放诊所的具体配置信息
@property (nonatomic, strong)NSDictionary *ClinicSummary;
//存放椅位详细信息 :
@property (nonatomic, strong)NSArray *Seats;

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *clinic_name;
@property (nonatomic, copy)NSString *clinic_img;
@property (nonatomic, copy)NSString *clinic_code;
@property (nonatomic, copy)NSString *clinic_location;
@property (nonatomic, copy)NSString *business_hours;
@property (nonatomic, copy)NSString *clinic_phone;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *dimension;
@property (nonatomic, copy)NSString *pay_password;
@property (nonatomic, copy)NSString *clinic_summary;
@property (nonatomic, copy)NSString *clinic_area;

@end

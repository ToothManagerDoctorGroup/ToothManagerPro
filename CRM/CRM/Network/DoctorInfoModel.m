//
//  DoctorInfoModel.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorInfoModel.h"
#import "DBTableMode.h"

@implementation DoctorInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"keyID" : @"KeyID"};
}

- (instancetype)initWithUserObj:(UserObject *)user{
    if (self = [super init]) {
        self.doctor_id = user.userid;
        self.doctor_name = user.name;
        self.doctor_dept = user.department;
        self.doctor_phone = user.phone;
        self.doctor_hospital = user.hospitalName;
        self.doctor_position = user.title;
        self.doctor_degree = user.degree;
        self.doctor_image = user.img;
        self.doctor_is_verified = [NSString stringWithFormat:@"%ld",(long)user.authStatus];
        self.doctor_verify_reason = user.authText;
        self.doctor_certificate = @"";
        self.doctor_birthday = user.doctor_birthday;
        self.doctor_gender = user.doctor_gender;
        self.doctor_cv = user.doctor_cv;
        self.doctor_skill = user.doctor_skill;
        self.is_open = @"1";
    }
    
    return self;
}


@end

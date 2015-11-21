//
//  ClinicModel.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface ClinicModel : NSObject<MJKeyValue>

@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *apply_time;
@property (nonatomic, copy)NSString *clinic_address;
@property (nonatomic, copy)NSString *clinic_id;
@property (nonatomic, copy)NSString *clinic_image;
@property (nonatomic, copy)NSString *clinic_name;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, copy)NSString *doctor_id;
@property (nonatomic, copy)NSString *doctor_name;
@property (nonatomic, copy)NSString *process_time;
@property (nonatomic, copy)NSString *sign_status;


@end

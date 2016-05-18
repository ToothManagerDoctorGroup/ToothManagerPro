//
//  TTMMedicalCaseModel.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMMedicalCaseModel : NSObject<MJKeyValue>

@property (nonatomic, assign)NSInteger keyId;
@property (nonatomic, copy)NSString *case_name;
@property (nonatomic, assign)NSInteger case_status;
@property (nonatomic, copy)NSString *ckeyid;
@property (nonatomic, copy)NSString *creation_time;
@property (nonatomic, assign)NSInteger doctor_id;
@property (nonatomic, copy)NSString *implant_time;
@property (nonatomic, copy)NSString *next_reserve_time;
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *repair_doctor;
@property (nonatomic, copy)NSString *repair_time;
@property (nonatomic, copy)NSString *sync_time;

@property (nonatomic, strong)NSArray *ctLibs;

@end

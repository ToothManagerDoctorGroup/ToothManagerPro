//
//  RepairDoctorCellMode.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairDoctorCellMode : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,readwrite) NSInteger count;
@property (nonatomic,copy) NSString *ckeyid;
@property (nonatomic, copy) NSString *phoneNum;
@end

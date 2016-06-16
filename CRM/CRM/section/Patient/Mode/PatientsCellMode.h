//
//  PatientsCellMode.h
//  CRM
//
//  Created by TimTiger on 6/2/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientsCellMode : NSObject

@property (nonatomic,copy) NSString* patientId;
@property (nonatomic,copy) NSString* introducerId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *statusStr;
@property (nonatomic,readwrite) NSInteger status;
@property (nonatomic,copy) NSString *introducerName;
@property (nonatomic,readwrite) NSInteger countMaterial;

@property (nonatomic, assign)BOOL isTransfer;

@property (nonatomic,copy) NSString *phone;

@end

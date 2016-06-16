//
//  XLCureProjectParam.m
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCureProjectParam.h"
#import "AccountManager.h"
#import "MyDateTool.h"

@implementation XLCureProjectParam

- (instancetype)initWithCaseId:(NSString *)case_id patientId:(NSString *)patient_id therapistId:(NSNumber *)therapist_id therapistName:(NSString *)therapist_name toothPosition:(NSString *)tooth_position medicalItem:(NSString *)medical_item endDate:(NSString *)end_date goldCount:(NSNumber *)gold_count status:(NSNumber *)status{
    if (self = [super init]) {
        self.case_id = case_id;
        self.patient_id = patient_id;
        self.therapist_id = therapist_id;
        self.therapist_name = therapist_name;
        self.tooth_position =  tooth_position;
        self.medical_item = medical_item;
        self.end_date = end_date;
        self.gold_count = gold_count;
        self.status = status;
        self.create_user = @([[AccountManager currentUserid] integerValue]);
        self.create_time = [MyDateTool stringWithDateWithSec:[NSDate date]];
    }
    
    return self;
}

@end

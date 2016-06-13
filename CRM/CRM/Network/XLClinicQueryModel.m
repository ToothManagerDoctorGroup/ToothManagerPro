//
//  XLClinicQueryModel.m
//  CRM
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicQueryModel.h"

@implementation XLClinicQueryModel

- (instancetype)initWithKeyWord:(NSString *)keyWord
                          isAsc:(BOOL)isAsc
                       doctorId:(NSString *)doctorId{
    if (self = [super init]) {
        
        self.KeyWord = keyWord;
        self.IsAsc = isAsc;
        self.SortField = @"modified_time";
        self.PageIndex = @(0);
        self.PageSize = @(0);
        self.DoctorId = doctorId;
        self.ClinicId = @"";
        self.ClinicName = @"";
        self.ClinicArea = @"";
        self.BusinessHours = @"";
        self.BusinessWeek = @"";
    }
    return self;
}

@end

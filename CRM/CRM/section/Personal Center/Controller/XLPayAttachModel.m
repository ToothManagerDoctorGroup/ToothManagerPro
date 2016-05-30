//
//  XLPayAttachModel.m
//  CRM
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPayAttachModel.h"
#import "MJExtension.h"
#import "MyDateTool.h"



@implementation XLPayAttachModel

+ (NSArray *)ignoredPropertyNames{
    return @[@"type"];
}

- (instancetype)initWithBillId:(NSString *)billId
                     billPayer:(NSString *)billPayer
                     billMoney:(NSString *)billMoney
                       payType:(PayAttachType)type
                      clinicId:(NSString *)clinicId{
    if (self = [super init]) {
        self.bill_id = billId;
        self.bill_payer = billPayer;
        self.bill_money = billMoney;
        self.clinic_id = clinicId;
        self.bill_status = @"0";
        switch (type) {
            case PayAttachTypeClinicReserve:
                self.bill_type = BillPayTypeClinicReserve;
                break;
            default:
                self.bill_type = BillPayTypeClinicReserve;
                break;
        }
    }
    return self;
}

@end

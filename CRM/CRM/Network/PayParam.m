//
//  PayParam.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PayParam.h"

@implementation PayParam

+ (instancetype)payParamWithBillId:(NSString *)billId
                          billType:(NSString *)type
                         billPayer:(NSString *)payer
                         billMoney:(NSString *)money
                          billTime:(NSString *)time
                        billStatus:(NSString *)status{
    PayParam *param = [[self alloc] init];
    param.bill_id = billId;
    param.bill_type = type;
    param.bill_payer = payer;
    param.bill_money = money;
    param.bill_time = time;
    param.bill_status = status;
    
    return param;
}
@end

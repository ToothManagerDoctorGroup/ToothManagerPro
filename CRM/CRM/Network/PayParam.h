//
//  PayParam.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface PayParam : NSObject<MJKeyValue>

/*{"bill_id":"201510181443",
    "bill_type":"预约",
    "bill_payer":"295",
    "bill_money":1715,
    "bill_time":"2015-10-19 15:24:00",
    "bill_status":1}*/

@property (nonatomic, copy)NSString *bill_id;
@property (nonatomic, copy)NSString *bill_type;
@property (nonatomic, copy)NSString *bill_payer;
@property (nonatomic, copy)NSString *bill_money;
@property (nonatomic, copy)NSString *bill_time;
@property (nonatomic, copy)NSString *bill_status;

+ (instancetype)payParamWithBillId:(NSString *)billId
                      billType:(NSString *)type
                     billPayer:(NSString *)payer
                     billMoney:(NSString *)money
                      billTime:(NSString *)time
                    billStatus:(NSString *)status;
@end

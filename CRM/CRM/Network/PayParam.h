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

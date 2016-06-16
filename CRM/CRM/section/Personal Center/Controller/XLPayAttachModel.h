//
//  XLPayAttachModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PayAttachType){
    PayAttachTypeClinicReserve,//诊所预约支付
    PayAttachTypeOther //其他
};

#define BillPayTypeClinicReserve @"creserver"

@interface XLPayAttachModel : NSObject

//{"bill_id":"预约id","bill_type":"支付类型","bill_payer":"付款人id","bill_money":1.5,"bill_time":"2016-05-21 13:05:36","bill_status":0,"clinic_id":33}
/**
 *  预约id
 */
@property (nonatomic, copy)NSString *bill_id;
/**
 *  支付类型
 */
@property (nonatomic, copy)NSString *bill_type;
/**
 *  付款人id
 */
@property (nonatomic, copy)NSString *bill_payer;
/**
 *  支付金额
 */
@property (nonatomic, copy)NSString *bill_money;
/**
 *  账单状态
 */
@property (nonatomic, copy)NSString *bill_status;
/**
 *  诊所id
 */
@property (nonatomic, copy)NSString *clinic_id;
/**
 *  支付类型(初始化时传入)
 */
@property (nonatomic, assign)PayAttachType type;

- (instancetype)initWithBillId:(NSString *)billId
                     billPayer:(NSString *)billPayer
                     billMoney:(NSString *)billMoney
                       payType:(PayAttachType)type
                      clinicId:(NSString *)clinicId;


@end

//
//  MyBillTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BillDetailModel,PayParam,CRMHttpRespondModel;
@interface MyBillTool : NSObject

/*
 获取账单列表信息
 */
+ (void)requestBillsWithDoctorId:(NSString *)doctocId type:(NSString *)type success:(void(^)(NSArray *bills))success failure:(void(^)(NSError *error))failure;

/*获取账单详细信息*/
+ (void)requestBillDetailWithBillId:(NSString *)billId success:(void(^)(BillDetailModel *billDetail))success failure:(void(^)(NSError *error))failure;

/*
    取消预约
 */
+ (void)cancleAppointWithAppointId:(NSString *)appointId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/*
    前往支付
 */
+ (void)payWithPayParam:(PayParam *)payParam success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;


//字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//数组转json
+ (NSString *)arrayToJson:(NSArray *)array;
@end

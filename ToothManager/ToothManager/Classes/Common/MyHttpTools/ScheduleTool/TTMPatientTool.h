//
//  TTMPatientTool.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMPatientModel.h"

@interface TTMPatientTool : NSObject

/*获取患者的详细信息*/
+ (void)requestPatientInfoWithpatientId:(NSString *)patientId success:(void(^)(TTMPatientModel *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取患者的病例信息
 *
 *  @param patientId 患者id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)requestMedicalCaseWithPatientId:(NSString *)patientId success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

/**
 *  获取患者的ct片信息
 *
 *  @param patientId 患者id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)requestCTLibWithCaseId:(NSString *)caseId success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
@end

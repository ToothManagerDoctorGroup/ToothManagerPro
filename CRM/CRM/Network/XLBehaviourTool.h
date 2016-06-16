//
//  XLBehaviourTool.h
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  行为
 */
@class XLBehaviourModel,CRMHttpRespondModel;
@interface XLBehaviourTool : NSObject
/**
 *  新增用户行为
 *
 *  @param model   行为模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addNewBehaviourWithBehaviourModel:(XLBehaviourModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure;

/**
 *  查询所有的用户行为
 *
 *  @param doctorId 医生id
 *  @param syncTime 同步时间
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)queryNewBehavioursWithDoctorId:(NSString *)doctorId syncTime:(NSString *)syncTime success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;

@end


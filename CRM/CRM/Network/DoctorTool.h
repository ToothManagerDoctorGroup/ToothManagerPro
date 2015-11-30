//
//  DoctorTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DoctorInfoModel,CRMHttpRespondModel;
@interface DoctorTool : NSObject

/*获取医生的详细信息*/
+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure;

/**
 *  上传用户头像
 *
 *  @param image   上传的图片
 *  @param userId  用户的id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void(^)())success failure:(void(^)(NSError *error))failure;


/**
 *  删除医生好友
 *
 *  @param doctorId 医生id
 *  @param introId  介绍人id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)deleteFriendWithDoctorId:(NSString *)doctorId introId:(NSString *)introId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;
@end

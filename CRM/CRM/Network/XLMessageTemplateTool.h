//
//  XLMessageTemplateTool.h
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  预约消息模板网络请求工具
 */
@class XLMessageTemplateParam,CRMHttpRespondModel;
@interface XLMessageTemplateTool : NSObject
/**
 *  获取用户自定义消息模板
 *
 *  @param doctor_id 医生id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getMessageTemplateByDoctorId:(NSString *)doctor_id success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  添加一个自定义消息模板
 *
 *  @param param   传递的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure;
/**
 *  编辑一个自定义消息模板
 *
 *  @param param   消息模板模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure;
/**
 *  删除一个自定义的消息模板
 *
 *  @param param   消息模板模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteMessageTemplateWithParam:(XLMessageTemplateParam *)param success:(void (^)(CRMHttpRespondModel *model))success failure:(void (^)(NSError *error))failure;



@end

//
//  SysMessageTool.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHttpRespondModel.h"

@interface SysMessageTool : NSObject
/**
 *  获取所有的未读消息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getUnReadMessagesWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  获取所有的已读消息
 *
 *  @param doctorId  医生id
 *  @param pageIndex 页码
 *  @param pageSize  每页显示多少条数据
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getReadedMessagesWithDoctorId:(NSString *)doctorId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;

/**
 *  删除一条消息
 *
 *  @param messageId 消息的keyId
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)deleteMessageWithMessageId:(NSInteger)messageId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  将消息设置为已读
 *
 *  @param messageId 消息id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)setMessageReadedWithMessageId:(NSInteger)messageId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end

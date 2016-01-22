//
//  SysMessageTool.h
//  CRM
//
//  Created by Argo Zhang on 15/12/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRMHttpRespondModel.h"
#import "LocalNotificationCenter.h"

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

/**
 *  发送微信信息
 *
 *  @param newId   新的预约id
 *  @param oldId   旧的预约id
 *  @param type    预约类型（修改预约，取消预约）
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)sendWeiXinReserveNotificationWithNewReserveId:(NSString *)newId oldReserveId:(NSString *)oldId isCancel:(BOOL)isCancel notification:(LocalNotification *)noti type:(NSString *)type success:(void (^)())success failure:(void (^)())failure;

/**
 *  更新预约信息的状态
 *
 *  @param reserve_id 预约信息id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)updateReserveRecordStatusWithReserveId:(NSString *)reserve_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

/**
 *  获取单条预约信息
 *
 *  @param reserve_id 预约id
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getReserveRecordByReserveId:(NSString *)reserve_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;
/**
 *  发送消息给患者
 *
 *  @param patient_id   患者的环信id
 *  @param content_type 发送的类型
 *  @param send_content 发送的内容
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)sendHuanXiMessageToPatientWithPatientId:(NSString *)patient_id contentType:(NSString *)content_type sendContent:(NSString *)send_content success:(void (^)())success failure:(void (^)(NSError *error))failure;

@end

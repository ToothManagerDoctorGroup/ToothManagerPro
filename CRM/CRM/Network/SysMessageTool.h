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

typedef NS_ENUM(NSInteger,SysMessageReadState){
    SysMessageReadStateAll = -1,   //所有
    SysMessageReadStateUnread = 0, //未读
    SysMessageReadStateReaded = 1  //已读
};

@class XLMessageQueryModel;
@interface SysMessageTool : NSObject

/**
 *  综合查询消息
 *
 *  @param queryModel 查询参数模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getMessageByQueryModel:(XLMessageQueryModel *)queryModel success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取所有消息
 *
 *  @param doctorId 医生id
 *  @param syncTime 同步时间
 *  @param isRead   是否已读（0未读，1已读，非0和1为获取所有）
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getMessagesWithDoctorId:(NSString *)doctorId syncTime:(NSString *)syncTime isRead:(SysMessageReadState)isRead success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取所有的未读消息
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getUnReadMessagesWithDoctorId:(NSString *)doctorId success:(void (^)(NSArray *result))success failure:(void (^)(NSError *error))failure;
/**
 *  获取未读消息的数量
 *
 *  @param doctorId 医生id
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)getUnReadMessageCountWithDoctorId:(NSString *)doctorId success:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure;

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
+ (void)updateReserveRecordStatusWithReserveId:(NSString *)reserve_id therapy_doctor_id:(NSString *)therapy_doctor_id success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

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
 *  @param doctor_id    发送者的id
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)sendHuanXiMessageToPatientWithPatientId:(NSString *)patient_id contentType:(NSString *)content_type sendContent:(NSString *)send_content doctorId:(NSString *)doctor_id success:(void (^)())success failure:(void (^)(NSError *error))failure;
/**
 *  发送消息给患者
 *
 *  @param doctor_id  医生id
 *  @param patient_id 患者id
 *  @param isWeixin   微信发送
 *  @param isSms      短信发送
 *  @param content    发送的内容
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)sendMessageWithDoctorId:(NSString *)doctor_id patientId:(NSString *)patient_id isWeixin:(BOOL)isWeixin isSms:(BOOL)isSms txtContent:(NSString *)content success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure;

@end

@interface XLMessageQueryModel : NSObject
//{"DoctorId":156,"IsRead":-1,"MsgId":"1063","MsgType":"AttainNewFriend","SyncTime":"2015-01-01 00:00:00","KeyWord":null,"SortField":"create_time","IsAsc":true,"PageIndex":0,"PageSize":10}
@property (nonatomic, copy)NSString *DoctorId;
@property (nonatomic, strong)NSNumber *IsRead;
@property (nonatomic, copy)NSString *MsgId;
@property (nonatomic, copy)NSString *MsgType;
@property (nonatomic, copy)NSString *SyncTime;
@property (nonatomic, copy)NSString *KeyWord;
@property (nonatomic, copy)NSString *SortField;
@property (nonatomic, assign)BOOL IsAsc;
@property (nonatomic, assign)NSInteger PageIndex;
@property (nonatomic, assign)NSInteger PageSize;

- (instancetype)initWithIsRead:(NSNumber *)isRead
                      syncTime:(NSString *)syncTime
                     sortField:(NSString *)sortField
                         isAsc:(BOOL)isAsc
                     pageIndex:(NSInteger)pageIndex
                      pageSize:(NSInteger)pageSize;

@end

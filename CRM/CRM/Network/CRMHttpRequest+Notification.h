//
//  CRMHttpRequest+Notification.h
//  CRM
//
//  Created by TimTiger on 3/6/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"

DEF_STATIC_CONST_STRING(Notification_Prefix,Notification);
DEF_URL NotificationFriends_URL = @"http://122.114.62.57/his.crm/ashx/NotificationFriendHandler.ashx?action=getdata";
DEF_URL NotificationSystem_URL = @"http://122.114.62.57/his.crm/ashx/NotificationSystemHandler.ashx?action=getdata";
DEF_URL NotificationInpatient_URL = @"http://122.114.62.57/his.crm/ashx/GetMessage.ashx?action=inpatient";
DEF_URL NotificationOutpatient_URL = @"http://122.114.62.57/his.crm/ashx/GetMessage.ashx?action=outpatient";

@interface CRMHttpRequest (Notification)

/**
 *  获取 好友通知消息
 *
 *  @param userid 用户id
 */
- (void)getFriendsNotificationListWithUserid:(NSString *)userid;

/**
 * 获取转入患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getInpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time;

/**
 * 获取转出患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getOutpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time;

/**
 *  获取系统消息列表
 *
 *  @param userid 用户id
 */
- (void)getSystemNotificationListWithUserid:(NSString *)userid;

@end

@protocol CRMHttpRequestNotificationDelegate <NSObject>

//获取好友通知列表
- (void)getFriendsNotificationListSuccessWithResult:(NSDictionary *)result;
- (void)getFriendsNotificationListFailedWithError:(NSError *)error;

//获取系统通知列表
- (void)getSystemNotificationListSuccessWithResult:(NSDictionary *)result;
- (void)getSystemNotificationListFailedWithError:(NSError *)error;

//获取转入病人通知列表
- (void)getInpatientNotificationListSuccessWithResult:(NSDictionary *)result;
- (void)getInpatientNotificationListFailedWithError:(NSError *)error;

//获取转出病人通知列表
- (void)getOutpatientNotificationListSuccessWithResult:(NSDictionary *)result;
- (void)getOutpatientNotificationListFailedWithError:(NSError *)error;

@end

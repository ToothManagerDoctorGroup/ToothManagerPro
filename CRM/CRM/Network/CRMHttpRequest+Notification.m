//
//  CRMHttpRequest+Notification.m
//  CRM
//
//  Created by TimTiger on 3/6/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CRMHttpRequest+Notification.h"
#import "NSError+Extension.h"
#import "NSString+TTMAddtion.h"

@implementation CRMHttpRequest (Notification)

/**
 *  获取 好友通知消息
 *
 *  @param userid 用户id
 */
- (void)getFriendsNotificationListWithUserid:(NSString *)userid {
    if (userid == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    [paramDic setObject:[@"getdata" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userid TripleDESIsEncrypt:YES] forKey:@"uid"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:NotificationFriends_URL andParams:paramDic withPrefix:Notification_Prefix];
    [self requestWithParams:param];
}

/**
 * 获取转入患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getInpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time
{
    if (userid == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"inpatient" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userid TripleDESIsEncrypt:YES] forKey:@"uid"];
    [paramDic setObject:[sync_time TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:NotificationPatient_Common_URL andParams:paramDic withPrefix:Notification_Prefix];
    [self requestWithParams:param];
}

/**
 * 获取转出患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getOutpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time
{
    if (userid == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"outpatient" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userid TripleDESIsEncrypt:YES] forKey:@"uid"];
    [paramDic setObject:[sync_time TripleDESIsEncrypt:YES] forKey:@"sync_time"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:NotificationPatient_Common_URL andParams:paramDic withPrefix:Notification_Prefix];
    [self requestWithParams:param];
}

/**
 *  获取系统消息列表
 *
 *  @param userid 用户id
 */
- (void)getSystemNotificationListWithUserid:(NSString *)userid {
    if (userid == nil) {
        return;
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"getdata" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userid TripleDESIsEncrypt:YES] forKey:@"uid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:NotificationSystem_URL andParams:paramDic withPrefix:Notification_Prefix];
    [self requestWithParams:param];
}

#pragma mark - Request CallBack
- (void)onNotificationRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onNotificationRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onNotificationRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onNotificationRequestSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onNotificationRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onNotificationRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onNotificationRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
}

- (void)onNotificationRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onNotificationRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onNotificationRequestSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:NotificationFriends_URL]) {
        [self requestFriendsNotificationListSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:NotificationSystem_URL]) {
        [self requestSystemNotificationListSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:NotificationPatient_Common_URL]) {
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"inpatient"]) {
            [self requestInpatientNotificationListSuccess:result andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"outpatient"]){
            [self requestOutpatientNotificationListSuccess:result andParam:param];
        }
        
    }
}

- (void)requestFriendsNotificationListSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getFriendsNotificationListSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestSystemNotificationListSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getSystemNotificationListSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestInpatientNotificationListSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getInpatientNotificationListSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestOutpatientNotificationListSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getOutpatientNotificationListSuccessWithResult:) withObject:result withObject:nil];
}

#pragma mark - Failure
- (void)onNotificationRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:NotificationFriends_URL]) {
        [self requestFriendsNotificationListFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:NotificationSystem_URL]) {
        [self requestSystemNotificationListFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:NotificationPatient_Common_URL]) {
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"inpatient"]) {
            [self requestInpatientNotificationListFailure:error andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"outpatient"]){
            [self requestOutpatientNotificationListFailure:error andParam:param];
        }
    }
}

- (void)requestFriendsNotificationListFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getFriendsNotificationListFailedWithError:) withObject:error withObject:nil];
}

- (void)requestSystemNotificationListFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getSystemNotificationListFailedWithError:) withObject:error withObject:nil];
}

- (void)requestInpatientNotificationListFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getInpatientNotificationListFailedWithError:) withObject:error withObject:nil];
}

- (void)requestOutpatientNotificationListFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getOutpatientNotificationListFailedWithError:) withObject:error withObject:nil];
}

@end

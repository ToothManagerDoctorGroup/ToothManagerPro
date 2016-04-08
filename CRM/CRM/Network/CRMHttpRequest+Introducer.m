//
//  TimRequest+Introducer.m
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest+Introducer.h"
#import "AccountManager.h"
#import "NSError+Extension.h"
#import "NSJSONSerialization+jsonString.h"
#import "NSString+TTMAddtion.h"

@implementation CRMHttpRequest (Introducer)

#pragma mark - send request
- (void)getIntroducerDataArray {
    TimRequestParam *param = [TimRequestParam paramWithURLSting:@"" andParams:nil withPrefix:Introducer_Prefix];
    [self requestWithParams:param];
}

/**
 *  申请成为介绍人
 *
 *  @param dotorid 医生id
 */
- (void)applyToBecomeIntroducerWithDoctorId:(NSString *)dotorid {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    /*
     {"doctor_id":"7","receiver_id":"8","notification_type":"1","notification_content":"234","creation_time":""}
     */
    /*
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提示语句" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];
    */
    
    UserObject *user = [[AccountManager shareInstance] currentUser];
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [subParamDic setValue:user.userid forKey:@"doctor_id"];
    [subParamDic setValue:dotorid forKey:@"receiver_id"];
    [subParamDic setValue:@"1" forKey:@"notification_type"];
    [subParamDic setValue:@"申请成为好友" forKey:@"notification_content"];
    NSDate *date = [NSDate date];
    [subParamDic setValue:[date description] forKey:@"creation_time"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:subParamDic];

    [paramDic setObject:[@"add" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ApplyToBecomeIntroducer_URL andParams:paramDic withPrefix:Introducer_Prefix];
    [self requestWithParams:param];
}

/**
 *  介绍人短信长链接转短链接
 *
 *  @param source 应用的app key
 *  @param access_token  AccessToken
 *  @param  url_long   长链接，需要URLencoded
 */
- (void)longUrlToShortUrl:(NSString *)source withAccessToken:(NSString *)access_token withLongUrl:(NSString *)url_long{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:source forKey:@"source"];
  //  [paramDic setObject:access_token forKey:@"access_token"];
    
  //  [paramDic setObject:@"long2short" forKey:@"action"];
    
    [paramDic setObject:url_long forKey:@"url_long"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:LongUrlToShortUrlSinaApi andParams:paramDic withPrefix:Introducer_Prefix];
    
    NSString *string= [NSString stringWithFormat:@"https://api.weibo.com/2/short_url/shorten.json?source=%@&url_long=%@",source,url_long];
    
    
    TimRequestParam *reqParam = [[TimRequestParam alloc]init];
    //reqParam.params = [NSMutableDictionary dictionaryWithDictionary:paramDic];

    reqParam.requestUrl = string;
    reqParam.method = RequestMethodGET;
//    reqParam.retryTimes = 1;
//    reqParam.timeoutInterval = 20;
//    reqParam.retryInterval = 2;
    reqParam.callbackPrefix = Introducer_Prefix;
    
     [self requestWithParams:param];
}

-(void)getPatientIntroducerMap:(NSString *)userId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];

    [paramDic setObject:[@"getdoctor" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userId TripleDESIsEncrypt:YES] forKey:@"uid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PatientIntroducerMap_Common_URL andParams:paramDic withPrefix:Introducer_Prefix];
    [self requestWithParams:param];
}

-(void)postPatientIntroducerMap:(NSString *)patientId withDoctorId:(NSString *)doctorId withIntrId:(NSString *)intrId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:intrId forKey:@"intr_id"];
    [dataEntity setObject:@"B" forKey:@"intr_source"];
    [dataEntity setObject:[NSString currentDateString] forKey:@"intr_time"];
    
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];

    [paramDic setObject:[@"add" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PatientIntroducerMap_Common_URL andParams:paramDic withPrefix:Introducer_Prefix];
    [self requestWithParams:param];
}

/**
 *  将患者转换为介绍人
 *
 *  @param userId 当前用户的userId
 *  @param ckeyid  当前患者的ckeyid
 *  @param  name   当前患者的姓名
 *  @param  phone   当前患者的电话
 */
- (void)patientToIntroducer:(NSString *)userId withCkeyId:(NSString *)ckeyid withName:(NSString *)name withPhone:(NSString *)phone{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[@"patient" TripleDESIsEncrypt:YES] forKey:@"Action"];
    [paramDic setObject:[userId TripleDESIsEncrypt:YES] forKey:@"uid"];
    [paramDic setObject:[ckeyid TripleDESIsEncrypt:YES] forKey:@"pid"];
    [paramDic setObject:[name TripleDESIsEncrypt:YES] forKey:@"pName"];
    [paramDic setObject:[phone TripleDESIsEncrypt:YES] forKey:@"pPhone"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:PatientToIntroducer_URL andParams:paramDic withPrefix:Introducer_Prefix];
    [self requestWithParams:param];
}
#pragma mark - Request CallBack
- (void)onIntroducerRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onIntroducerRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onIntroducerRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onIntroducerRequestSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onIntroducerRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onIntroducerRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onIntroducerRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
}

- (void)onIntroducerRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onIntroducerRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onIntroducerRequestSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:ApplyToBecomeIntroducer_URL]) {
        [self requestApplyToBecomeIntroducerSuccess:result andParam:param];
    }else if ([param.requestUrl isEqualToString:LongUrlToShortUrlSinaApi]){
        [self requestLongUrlToShortUrlSuccess:result andParam:param];
    }else if ([param.requestUrl isEqualToString:PatientToIntroducer_URL]){
        [self requestPatientToIntroducerSuccess:result andParam:param];
    }else if ([param.requestUrl isEqualToString:PatientIntroducerMap_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdoctor"]) {
            [self requestPatientIntroducerMapSuccess:result andParam:param];
        }else if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"add"]){
            [self requestPostPatientIntroducerMapSuccess:result andParam:param];
        }
    }
}
- (void)requestLongUrlToShortUrlSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(longUrlToShortUrlSucessWithResult:) withObject:result withObject:nil];
}
- (void)requestApplyToBecomeIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(applyToBecomeIntroducerSuccess:) withObject:result withObject:result];
}
- (void)requestPatientToIntroducerSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(patientToIntroducerSuccess:) withObject:result withObject:result];
}
- (void)requestPatientIntroducerMapSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(getPatientIntroducerMapSuccess:) withObject:result withObject:result];
}

- (void)requestPostPatientIntroducerMapSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(postPatientIntroducerMapSuccess:) withObject:result withObject:result];
}

#pragma mark - Failure
- (void)onIntroducerRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:ApplyToBecomeIntroducer_URL]) {
        [self requestApplyToBecomeIntroducerFailure:error andParam:param];
    }else if ([param.requestUrl isEqualToString:LongUrlToShortUrlSinaApi]){
        [self requestLongUrlToShortUrlFailure:error andParam:param];
    }else if ([param.requestUrl isEqualToString:PatientToIntroducer_URL]){
        [self requestPatientToIntroducerFailure:error andParam:param];
    }else if ([param.requestUrl isEqualToString:PatientIntroducerMap_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdoctor"]) {
            [self requestPatientIntroducerMapFailure:error andParam:param];
        }else if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"add"]){
            [self requestPostPatientIntroducerMapFailure:error andParam:param];
        } 
    }
}
- (void)requestPatientToIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(patientToIntroducerFailed:) withObject:error withObject:nil];
}
- (void)requestApplyToBecomeIntroducerFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(applyToBecomeIntroducerFailed:) withObject:error withObject:nil];
}
- (void)requestLongUrlToShortUrlFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(longUrlToShortUrlFailedWithError:) withObject:error withObject:nil];
}
- (void)requestPatientIntroducerMapFailure:(NSError *)error andParam:(TimRequestParam *)param{
        [self responderPerformSelector:@selector(getPatientIntroducerMapFailed:) withObject:error withObject:nil];
}
- (void)requestPostPatientIntroducerMapFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(postPatientIntroducerMapFailed:) withObject:error withObject:nil];
}

@end

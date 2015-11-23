//
//  CRMHttpRequest+Doctor.m
//  CRM
//
//  Created by TimTiger on 11/4/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest+Doctor.h"
#import "NSError+Extension.h"
#import "NSJSONSerialization+jsonString.h"

@implementation CRMHttpRequest (Doctor)

/**
 *  获取个人的医生列表
 *
 *  @param userid 个人id
 */
- (void)getDoctorListWithUserid:(NSString *)userid {
    
    if (userid == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDic setObject:userid forKey:@"userid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:GetDoctorList_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

/**
 *  更具姓名搜索医生
 *
 *  @param doctorname 医生名
 */
- (void)searchDoctorWithName:(NSString *)doctorname {
    
    if (doctorname == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDic setObject:doctorname forKey:@"username"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:SearchDoctor_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

- (void)doctorIconWithUserId:(NSString *)userid withData:(NSData *)data{
    /*
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"avatar" forKey:@"Action"];
    [paramDic setObject:userid forKey:@"KeyId"];
    NSMutableDictionary *addParamDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [addParamDic setObject:@"avatar" forKey:@"pic"];
    [addParamDic setObject:data forKey:@"key"];
   TimRequestParam *param =  [TimRequestParam paramWithURLSting:DoctorIcon_URL andParams:paramDic additionParams:addParamDic  withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
    */
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"avatar" forKey:@"Action"];
    [paramDic setObject:userid forKey:@"KeyId"];
    NSMutableDictionary *addParamDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [addParamDic setObject:[NSString stringWithFormat:@"%@.jpg",userid] forKey:@"pic"];
    [addParamDic setObject:data forKey:@"key"];
    TimRequestParam *param =  [TimRequestParam paramWithURLSting:DoctorIcon_URL andParams:paramDic additionParams:addParamDic  withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
    
}

/**
 *  转诊病人
 *
 *  @param patientIds:病人id  doctorId:医生id  receiver_id:接收人id
 **/
- (void)trasferPatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toReceiver:(NSString *)receiverId
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:4];
    /*
    [dataEntity setObject:patientIds forKey:@"patientIds"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:receiverId forKey:@"receiver_id"];*/
    [dataEntity setObject:patientIds forKey:@"patient_id"];
    [dataEntity setObject:receiverId forKey:@"doctor_id"];
    [dataEntity setObject:doctorId forKey:@"intr_id"];
    [dataEntity setObject:@"I" forKey:@"intr_source"];
    
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Transfer_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
    
}

/**
 *  医生预约列表
 *
 *  @param doctorId:医生id
 **/
- (void)clinicMessage:(NSString *)doctorId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"getAppointment" forKey:@"Action"];
    [paramDic setObject:doctorId forKey:@"doctor_id"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicMessage_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}


- (void)doctorClinic:(NSString *)doctorId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"getClinic" forKey:@"Action"];
    [paramDic setObject:doctorId forKey:@"doctor_id"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:DoctorClinic_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

- (void)clinicSeat:(NSString *)clinicId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"getList" forKey:@"Action"];
    [paramDic setObject:clinicId forKey:@"clinicid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicSeat_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}


- (void)yuYueInfoByClinicSeatDate:(NSString *)clinicId withSeatId:(NSString *)seatId withDate:(NSString *)date{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"getListBySeatAndDate" forKey:@"Action"];
    [paramDic setObject:clinicId forKey:@"clinicid"];
    [paramDic setObject:date forKey:@"cdate"];
    [paramDic setObject:seatId forKey:@"seatid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:YuYueInfoByClinicSeatDate_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}
/**
 *  医生微信消息推送
 *
 *  @param patientIds:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientIds forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    [paramDic setObject:@"SendMessage" forKey:@"action"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:WeiXin_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

/**
 *  预约短信消息推送
 *
 *  @param patientId:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:YuYueDuanXin_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}
#pragma mark - Request CallBack
- (void)onDoctorRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onDoctorRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDoctorRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onDoctorRequestSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onDoctorRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onDoctorRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onDoctorRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }
    
}

- (void)onDoctorRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onDoctorRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onDoctorRequestSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:SearchDoctor_URL]) {
        [self requestSearchDoctorWithNameSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:GetDoctorList_URL]) {
        [self requestGetDoctorListSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Transfer_URL]) {
        [self requestTransferSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:WeiXin_URL]){
        [self requestWeiXinMessageSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:DoctorClinic_URL]){
        [self requestDoctorClinicSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:ClinicSeat_URL]){
        [self requestClinicSeatSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueInfoByClinicSeatDate_URL]){
        [self requestYuYueInfoByClinicSeatDateSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueDuanXin_URL]){
        [self requestYuYueMessageSuccess:result andParam:param];
    }
}

- (void)requestSearchDoctorWithNameSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(searchDoctorWithNameSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestGetDoctorListSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getDoctorListSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestTransferSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(transferPatientSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestWeiXinMessageSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(weiXinMessageSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestYuYueMessageSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(yuYueMessageSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestClinicMessageSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(clinicMessageSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestDoctorClinicSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(doctorClinicSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestClinicSeatSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(clinicSeatSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestYuYueInfoByClinicSeatDateSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(yuYueInfoByClinicSeatDateSuccessWithResult:) withObject:result withObject:nil];
}


#pragma mark - Failure
- (void)onDoctorRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:SearchDoctor_URL]) {
        [self requestSearchDoctorWithNameFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:GetDoctorList_URL]) {
        [self requestGetDoctorListFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Transfer_URL]) {
        [self requestTransferFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:WeiXin_URL]){
        [self requestWeiXinMessageFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:DoctorClinic_URL]){
        [self requestDoctorClinicFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:ClinicSeat_URL]){
        [self requestClinicSeatFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueInfoByClinicSeatDate_URL]){
        [self requestYuYueInfoByClinicSeatDateFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueDuanXin_URL]){
        [self requestYuYueMessageFailure:error andParam:param];
    }
}

- (void)requestSearchDoctorWithNameFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(searchDoctorWithNameFailedWithError:) withObject:error withObject:nil];
}

- (void)requestGetDoctorListFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(getDoctorListFailedWithError:) withObject:error withObject:nil];
}

- (void)requestTransferFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(transferPatientFailedWithError:) withObject:error withObject:nil];
}

- (void)requestWeiXinMessageFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(weiXinMessageFailedWithError:) withObject:error withObject:nil];
}

- (void)requestYuYueMessageFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(yuYueMessageFailedWithError:) withObject:error withObject:nil];
}

-(void)requestClinicMessageFailure:(NSError *)error andParam:(TimRequestParam *)param{
        [self responderPerformSelector:@selector(clinicMessageFailedWithError:) withObject:error withObject:nil];
}

-(void)requestDoctorClinicFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(doctorClinicFailedWithError:) withObject:error withObject:nil];
}

-(void)requestClinicSeatFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(clinicSeatFailedWithError:) withObject:error withObject:nil];
}

-(void)requestYuYueInfoByClinicSeatDateFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(yuYueInfoByClinicSeatDateFailedWithError:) withObject:error withObject:nil];
}
@end
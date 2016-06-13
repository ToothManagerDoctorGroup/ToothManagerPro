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
#import "NSString+TTMAddtion.h"
#import "JSONKit.h"
#import "AccountManager.h"
#import "CRMHttpTool.h"
#import "CRMUserDefalut.h"

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
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDic setObject:[@"getdatabyid" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[userid TripleDESIsEncrypt:YES] forKey:@"userid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:GetOrSearchDoctorList_AndIcon_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

/**
 *  根据姓名搜索医生
 *
 *  @param doctorname 医生名
 */
- (void)searchDoctorWithName:(NSString *)doctorname {
    
    if (doctorname == nil) {
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"getdata" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[doctorname TripleDESIsEncrypt:YES] forKey:@"username"];
    [paramDic setObject:[[AccountManager currentUserid] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:GetOrSearchDoctorList_AndIcon_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

- (void)doctorIconWithUserId:(NSString *)userid withData:(NSData *)data{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"avatar" forKey:@"Action"];
    [paramDic setObject:userid forKey:@"KeyId"];
    
    NSMutableDictionary *addParamDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [addParamDic setObject:[NSString stringWithFormat:@"%@.jpg",userid] forKey:@"pic"];
    [addParamDic setObject:data forKey:@"key"];
    
    TimRequestParam *param =  [TimRequestParam paramWithURLSting:GetOrSearchDoctorList_AndIcon_Common_URL andParams:paramDic additionParams:addParamDic  withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
    
}

/**
 *  转诊病人
 *
 *  @param patientIds:病人id  doctorId:医生id  receiver_id:接收人id
 **/
- (void)trasferPatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toReceiver:(NSString *)receiverId
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [dataEntity setObject:patientIds forKey:@"patient_id"];
    [dataEntity setObject:receiverId forKey:@"doctor_id"];
    [dataEntity setObject:doctorId forKey:@"intr_id"];
    [dataEntity setObject:@"I" forKey:@"intr_source"];
    
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:[@"transfer" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    paramDic[@"devicetoken"] = [[CRMUserDefalut objectForKey:DeviceToken] TripleDESIsEncrypt:YES];
    
    
    [[CRMHttpTool shareInstance] logWithUrlStr:Transfer_URL params:paramDic];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Transfer_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
    
}

/**
 *  医生预约列表
 *
 *  @param doctorId:医生id
 **/
- (void)clinicMessage:(NSString *)doctorId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"getAppointment" TripleDESIsEncrypt:YES] forKey:@"Action"];
    [paramDic setObject:[doctorId TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicMessage_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}


- (void)doctorClinic:(NSString *)doctorId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"getClinic" TripleDESIsEncrypt:YES] forKey:@"Action"];
    [paramDic setObject:[doctorId TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicMessage_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

- (void)clinicSeat:(NSString *)clinicId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[@"getList" TripleDESIsEncrypt:YES] forKey:@"Action"];
    [paramDic setObject:[clinicId TripleDESIsEncrypt:YES] forKey:@"clinicid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicSeat_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}


- (void)yuYueInfoByClinicSeatDate:(NSString *)clinicId withSeatId:(NSString *)seatId withDate:(NSString *)date{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[@"getListBySeatAndDate" TripleDESIsEncrypt:YES] forKey:@"Action"];
    [paramDic setObject:[clinicId TripleDESIsEncrypt:YES] forKey:@"clinicid"];
    [paramDic setObject:[date TripleDESIsEncrypt:YES] forKey:@"cdate"];
    [paramDic setObject:[seatId TripleDESIsEncrypt:YES] forKey:@"seatid"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:YuYueInfoByClinicSeatDate_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}
/**
 *  医生微信消息推送
 *
 *  @param patientIds:病人id  doctorId:医生id  message_type:类型   send_type  send_time
 **/
- (void)weiXinMessagePatient:(NSString *)patientIds fromDoctor:(NSString *)doctorId toDoctor:(NSString *)toDoctor withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    [dataEntity setObject:patientIds forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    [dataEntity setObject:toDoctor forKey:@"therapy_doctor_id"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    [paramDic setObject:[@"SendMessage" TripleDESIsEncrypt:YES] forKey:@"action"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:WeiXin_SMS_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
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
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    [paramDic setObject:[@"getMessageItem" TripleDESIsEncrypt:YES] forKey:@"action"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:WeiXin_SMS_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
    [self requestWithParams:param];
}

//预约推送到诊所端
- (void)YuYueTuiSongClinic:(NSString *)patientId withClinicName:(NSString *)clinic_name withCliniId:(NSString *)clinic_id withDoctorId:(NSString *)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:16];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctor_id forKey:@"doctor_id"];
    [dataEntity setObject:clinic_name forKey:@"clinic_name"];
    [dataEntity setObject:clinic_id forKey:@"clinic_id"];
    [dataEntity setObject:appoint_time forKey:@"appoint_time"];
    
    [dataEntity setObject:[NSString stringWithFormat:@"%f",duration] forKey:@"duration"];
    [dataEntity setObject:[NSString stringWithFormat:@"%f",seat_price] forKey:@"seat_price"];
    [dataEntity setObject:[NSString stringWithFormat:@"%f",appoint_money] forKey:@"appoint_money"];
    
    [dataEntity setObject:appoint_type forKey:@"appoint_type"];
    [dataEntity setObject:seat_id forKey:@"seat_id"];
    [dataEntity setObject:tooth_position forKey:@"tooth_position"];
    
    [dataEntity setObject:assist forKey:@"assist"];
    [dataEntity setObject:material forKey:@"material"];
    
    [dataEntity setObject:@"xuyaopeihe" forKey:@"remark"];
    [dataEntity setObject:@"0" forKey:@"expert_result"];
    [dataEntity setObject:@"可以做" forKey:@"expert_suggestion"];
    
    NSString *jsonString = [dataEntity JSONString];
    [paramDic setObject:[@"appoint" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ClinicMessage_Common_URL andParams:paramDic withPrefix:Doctor_Prefix];
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
    if ([param.requestUrl isEqualToString:GetOrSearchDoctorList_AndIcon_Common_URL]) {
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdatabyid"]) {
            [self requestGetDoctorListSuccess:result andParam:param];
            
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdata"]){
            [self requestSearchDoctorWithNameSuccess:result andParam:param];
        }
    } else if ([param.requestUrl isEqualToString:Transfer_URL]) {
        [self requestTransferSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:WeiXin_SMS_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"SendMessage"]) {
            [self requestWeiXinMessageSuccess:result andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getMessageItem"]){
            [self requestYuYueMessageSuccess:result andParam:param];
        }
    } else if ([param.requestUrl isEqualToString:ClinicMessage_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getClinic"]) {
            [self requestDoctorClinicSuccess:result andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"appoint"]){
            [self requestYuYueTuiSongClinicSuccess:result andParam:param];
        }
        
    } else if ([param.requestUrl isEqualToString:ClinicSeat_URL]){
        [self requestClinicSeatSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueInfoByClinicSeatDate_URL]){
        [self requestYuYueInfoByClinicSeatDateSuccess:result andParam:param];
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

- (void)requestYuYueTuiSongClinicSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(yuYueTuiSongClinicSuccessWithResult:) withObject:result withObject:nil];
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
    if ([param.requestUrl isEqualToString:GetOrSearchDoctorList_AndIcon_Common_URL]) {
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdatabyid"]) {
            [self requestGetDoctorListFailure:error andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getdata"]){
            [self requestSearchDoctorWithNameFailure:error andParam:param];
        }
        
    } else if ([param.requestUrl isEqualToString:Transfer_URL]) {
        [self requestTransferFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:WeiXin_SMS_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"SendMessage"]) {
            [self requestWeiXinMessageFailure:error andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getMessageItem"]){
            [self requestYuYueMessageFailure:error andParam:param];
        }
    } else if ([param.requestUrl isEqualToString:ClinicMessage_Common_URL]){
        if ([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"getClinic"]) {
            [self requestDoctorClinicFailure:error andParam:param];
        }else if([[param.params[@"action"] TripleDESIsEncrypt:NO] isEqualToString:@"appoint"]){
            [self requestYuYueTuiSongClinicFailure:error andParam:param];
        }
        
    } else if ([param.requestUrl isEqualToString:ClinicSeat_URL]){
        [self requestClinicSeatFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:YuYueInfoByClinicSeatDate_URL]){
        [self requestYuYueInfoByClinicSeatDateFailure:error andParam:param];
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

- (void)requestYuYueTuiSongClinicFailure:(NSError *)error andParam:(TimRequestParam *)param{
    [self responderPerformSelector:@selector(yuYueTuiSongClinicFailedWithError:) withObject:error withObject:nil];
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

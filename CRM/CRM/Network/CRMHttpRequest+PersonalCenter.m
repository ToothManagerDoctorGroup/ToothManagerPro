//
//  CRMHttpRequest+PersonalCenter.m
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest+PersonalCenter.h"
#import "NSError+Extension.h"
#import "AccountManager.h"
#import "NSJSONSerialization+jsonString.h"

@implementation CRMHttpRequest (PersonalCenter)

#pragma mark - Account
/**
 *  注册
 *
 *  @param nickname 昵称
 *  @param pwd      密码
 *  @param phone    手机号
 */
- (void)registerWithNickname:(NSString *)nick phone:(NSString *)phone passwd:(NSString *)passwd recommender:(NSString *)recommender validate:(NSString *)validate {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:nick forKey:@"username"];
    [params setObject:phone forKey:@"mobile"];
    [params setObject:passwd forKey:@"password"];
    [params setObject:recommender forKey:@"recommender"];
    [params setObject:passwd forKey:@"checkpassword"];
    [params setObject:@"huye@gmail.com" forKey:@"email"];
    [params setObject:validate forKey:@"Validatecode"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Register_URL andParams:params withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  获取验证码
 *
 *  @param phoneNumber 昵称
 */
- (void)sendValidateToPhone:(NSString *)phoneNumber {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:phoneNumber forKey:@"phoneNumber"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Validate_URL andParams:params withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  获取忘记密码页面的验证码
 *
 *  @param phoneNumber 手机号
 */
- (void)sendForgetValidateToPhone:(NSString *)phoneNumber{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:phoneNumber forKey:@"phoneNumber"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Forget_Validate_URL andParams:params withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  手机号、昵称登录
 *
 *  @param nickname 手机号或者账号名
 *  @param pwd      密码
 */
- (void)loginWithNickName:(NSString *)nickname passwd:(NSString *)pwd {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:nickname forKey:@"username"];
    [paramDic setObject:pwd forKey:@"password"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Login_URL andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  更新个人资料
 *
 *  @param dic 参数字典
 */
- (void)updateProfileWithDictionary:(Doctor *)doctor {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:3];
    [dataEntity setObject:doctor.doctor_id forKey:@"doctor_id"];
    [dataEntity setObject:doctor.doctor_name forKey:@"doctor_name"];
    [dataEntity setObject:doctor.doctor_dept forKey:@"doctor_dept"];
    [dataEntity setObject:doctor.doctor_phone forKey:@"doctor_phone"];
    [dataEntity setObject:doctor.doctor_hospital forKey:@"doctor_hospital"];
    [dataEntity setObject:doctor.doctor_position forKey:@"doctor_position"];
    [dataEntity setObject:doctor.doctor_degree forKey:@"doctor_degree"];
    [dataEntity setObject:doctor.doctor_image forKey:@"doctor_image"];
    [dataEntity setObject:[NSString stringWithFormat:@"%d",doctor.auth_status] forKey:@"doctor_is_verified"];
    [dataEntity setObject:doctor.auth_text forKey:@"doctor_verify_reason"];
    [dataEntity setObject:doctor.doctor_certificate forKey:@"doctor_certificate"];
    [dataEntity setObject:[NSString stringWithFormat:@"%hhd",doctor.isopen] forKey:@"is_open"];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:doctor.ckeyid forKey:@"keyid"];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    
    TimRequestParam *param = [TimRequestParam paramWithURLSting:UpdateUserInfo_URL andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  更新个人密码
 *
 *  @param oldpwd 老密码
 *  @param newpwd 新密码
 *  @param userId 用户Id
 */
- (void)updatePasswdWithOldpwd:(NSString *)oldpwd newpwd:(NSString *)newpwd userId:(NSString *)userId{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:2];
    [paramDic setObject:oldpwd forKey:@"old"];
    [paramDic setObject:newpwd forKey:@"new"];
  //  [paramDic setObject:userId forKey:@"userID"];
   //  [paramDic setObject:@"editpass2" forKey:@"action"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:UpdatePasswd_URL andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  同意介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)approveIntroducerApply:(NSString *)introducer_id {
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:0];
    [dataEntity setObject:introducer_id forKey:@"intr_id"];
    [dataEntity setObject:[AccountManager currentUserid] forKey:@"doctor_id"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:ApproveIntroducerApply andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  拒绝介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)refuseIntroducerApply:(NSString *)introducer_id {
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:0];
    [dataEntity setObject:introducer_id forKey:@"intr_id"];
    [dataEntity setObject:[AccountManager currentUserid] forKey:@"doctor_id"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:RefuseIntroducerApply andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}

/**
 *  获取医生二维码
 *
 *  @param user_id 医生id
 *  @param AccessToken  医生AccessToken
 */
- (void)getQrCode:(NSString *)user_id withAccessToken:(NSString *)AccessToken{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:user_id forKey:@"userId"];
    [paramDic setObject:AccessToken forKey:@"AccessToken"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Qrcode_URL andParams:paramDic withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}
/**
 *  忘记密码页面
 *
 *  @param newpwd   新密码
 *  @param phone    手机号
 *  @param validate 验证码
 */
- (void)forgetPasswordWithPhone:(NSString *)phone passwd:(NSString *)newpwd validate:(NSString *)validate{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:phone forKey:@"mobile"];
    [params setObject:validate forKey:@"Validatecode"];
    [params setObject:newpwd forKey:@"Newpass"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Forget_Password_URL andParams:params withPrefix:PersonalCenter_Prefix];
    [self requestWithParams:param];
}


#pragma mark - Request CallBack
- (void)onPersonalCenterRequestSuccessWithResponse:(id)response withParam:(TimRequestParam *)param {
    NSError *error = nil;
    NSString *message = nil;
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        //返回的不是字典
        message = @"返回内容错误";
        error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
        [self onPersonalCenterRequestFailureCallBackWith:error andParam:param];
        return;
    }
    @try {
        NSNumber *retCodeNum = [response objectForKey:@"Code"];
        if (retCodeNum == nil) {
            //没有code字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onPersonalCenterRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSInteger retCode = [retCodeNum integerValue];
        if (retCode == 200) {
            [self onPersonalCenterRequestSuccessCallBackWith:response andParam:param];
            return;
        } else {
            NSString *errorMessage = [response objectForKey:@"Result"];
            NSError *error = [NSError errorWithDomain:@"请求失败" localizedDescription:errorMessage errorCode:retCode];
            [self onPersonalCenterRequestFailureCallBackWith:error andParam:param];
            return;
        }
        
        NSDictionary *retDic = [response objectForKey:@"Result"];
        if (retDic == nil) {
            //没有result字段
            message = @"返回内容解析错误";
            error = [NSError errorWithDomain:@"请求失败" localizedDescription:message errorCode:404];
            [self onPersonalCenterRequestFailureCallBackWith:error andParam:param];
            return;
        }
    }
    @catch (NSException *exception) {
        [self onPersonalCenterRequestFailureCallBackWith:[NSError errorWithDomain:@"请求失败" localizedDescription:@"未知错误" errorCode:404] andParam:param];
    }
    @finally {
        
    }

}

- (void)onPersonalCenterRequestFailure:(NSError *)error withParam:(TimRequestParam *)param {
    [self onPersonalCenterRequestFailureCallBackWith:error andParam:param];
}

#pragma mark - Success
- (void)onPersonalCenterRequestSuccessCallBackWith:(NSDictionary *)result andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:Register_URL]) {
        [self requestUserRegisterSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Login_URL]) {
        [self requestUserLoginSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:UpdatePasswd_URL]) {
        [self requestUpdatePasswdSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:ApproveIntroducerApply]) {
        [self requestApproveIntroducerApplySuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:RefuseIntroducerApply]) {
        [self requestRefuseIntroducerApplySuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:UpdateUserInfo_URL]) {
        [self requestUpdateUserinfoSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Validate_URL]) {
        [self requestSendValidateSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Forget_Validate_URL]){
        [self requestSendForgetValidateSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Qrcode_URL]) {
        [self requestQrCodeSuccess:result andParam:param];
    } else if ([param.requestUrl isEqualToString:Forget_Password_URL]){
        [self requestForgetPasswordSuccess:result andParam:param];
    }
}

/**
 *  注册成功
 *
 *  @param result 注册结果
 *  @param param  注册参数
 */
- (void)requestUserRegisterSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    //1.处理result .结果写入数据库什么的
    //2.通知响应者们
    [self responderPerformSelector:@selector(registerSucessWithResult:) withObject:result withObject:nil];
}

- (void)requestUserLoginSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    //1.处理result .结果写入数据库什么的
    //2.通知响应者们
    [self responderPerformSelector:@selector(loginSucessWithResult:) withObject:result withObject:nil];
}

- (void)requestUpdatePasswdSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    
    [self responderPerformSelector:@selector(updatePasswdSucessWithResult:) withObject:result withObject:nil];
}

- (void)requestUpdateUserinfoSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(updateUserInfoSuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestApproveIntroducerApplySuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(approveIntroducerApplySuccessWithResult:) withObject:result withObject:nil];
}

- (void)requestRefuseIntroducerApplySuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(refuseIntroducerApplySuccessWithResult:) withObject:result withObject:nil];
}

//获取验证码
- (void)requestSendValidateSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(sendValidateSuccessWithResult:) withObject:result withObject:param];
}

- (void)requestSendForgetValidateSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(sendForgetValidateSuccessWithResult:) withObject:result withObject:param];
}

- (void)requestQrCodeSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(qrCodeImageSuccessWithResult:) withObject:result withObject:nil];
}
- (void)requestForgetPasswordSuccess:(NSDictionary *)result andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(forgetPasswordSucessWithResult:) withObject:result withObject:nil];
}
#pragma mark - Failure
- (void)onPersonalCenterRequestFailureCallBackWith:(NSError *)error andParam:(TimRequestParam *)param {
    if ([param.requestUrl isEqualToString:Register_URL]) {
        [self requestUserRegisterFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Login_URL]) {
        [self requestUserLoginFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:UpdatePasswd_URL]) {
        [self requestUpdatePasswdFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:ApproveIntroducerApply]) {
        [self requestApproveIntroducerApplayFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:RefuseIntroducerApply]) {
        [self requestRefuseIntroducerApplayFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:UpdateUserInfo_URL]) {
        [self requestUpdateUserInfoFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Validate_URL]) {
        [self requestSendValidateFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Forget_Validate_URL]){
        [self requestSendForgetValidateFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Qrcode_URL]) {
        [self requestQrCodeFailure:error andParam:param];
    } else if ([param.requestUrl isEqualToString:Forget_Password_URL]){
        [self requestForgetPasswordFailure:error andParam:param];
    }
}

/**
 *  注册失败
 *
 *  @param result 注册结果
 *  @param param  注册参数
 */
- (void)requestUserRegisterFailure:(NSError *)error andParam:(TimRequestParam *)param {
    //1.处理result .结果写入数据库什么的
    //2.通知响应者们
    [self responderPerformSelector:@selector(registerFailedWithError:) withObject:error withObject:nil];
}

- (void)requestUserLoginFailure:(NSError *)error andParam:(TimRequestParam *)param {
    //1.处理result .结果写入数据库什么的
    //2.通知响应者们
    [self responderPerformSelector:@selector(loginFailedWithError:) withObject:error withObject:nil];
}

- (void)requestUpdatePasswdFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(updatePasswdFailedWithError:) withObject:error withObject:nil];
}

- (void)requestUpdateUserInfoFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(updateUserInfoFailedWithError:) withObject:error withObject:nil];
}

- (void)requestApproveIntroducerApplayFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(approveIntroducerApplyFailedWithError:) withObject:error withObject:nil];
}

- (void)requestRefuseIntroducerApplayFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(refuseIntroducerApplyFailedWithError:) withObject:error withObject:nil];
}

//获取验证码
- (void)requestSendValidateFailure:(NSError *)error andParam:(TimRequestParam *)parem {
    [self responderPerformSelector:@selector(sendValidateFailedWithError:) withObject:error withObject:nil];
}

- (void)requestSendForgetValidateFailure:(NSError *)error andParam:(TimRequestParam *)parem {
    [self responderPerformSelector:@selector(sendForgetValidateFailedWithError:) withObject:error withObject:nil];
}

- (void)requestQrCodeFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(qrCodeImageFailedWithError:) withObject:error withObject:nil];
}

- (void)requestForgetPasswordFailure:(NSError *)error andParam:(TimRequestParam *)param {
    [self responderPerformSelector:@selector(forgetPasswordFailedWithError:) withObject:error withObject:nil];
}
@end
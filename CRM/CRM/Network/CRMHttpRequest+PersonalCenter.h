//
//  CRMHttpRequest+PersonalCenter.h
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"
#import "DoctorManager.h"

DEF_STATIC_CONST_STRING(PersonalCenter_Prefix,PersonalCenter);
//DEF_URL Register_URL = @"http://122.114.62.57/ashx/Register2Handler.ashx";
#define Register_URL [NSString stringWithFormat:@"%@ashx/Register2Handler.ashx",DomainName]

//DEF_URL Login_URL = @"http://122.114.62.57/ashx/loginhandler.ashx";
#define Login_URL [NSString stringWithFormat:@"%@ashx/loginhandler.ashx",DomainName]

//DEF_URL UpdatePasswd_URL = @"http://122.114.62.57/ashx/UserHandler.ashx?action=editpass2";
//DEF_URL UpdatePasswd_URL = @"http://122.114.62.57/sys/ashx/UserHandler.ashx?action=editpass2";
#define UpdatePasswd_URL [NSString stringWithFormat:@"%@%@/ashx/UserHandler.ashx?action=editpass2",DomainName,Method_Sys]

//DEF_URL UpdateUserInfo_URL = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx?action=edit";
#define UpdateUserInfo_URL [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx?action=edit",DomainName,Method_His_Crm]

//DEF_URL ApproveIntroducerApply = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx?action=approve";
#define ApproveIntroducerApply [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx?action=approve",DomainName,Method_His_Crm]

//DEF_URL RefuseIntroducerApply = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx?action=reject";
#define RefuseIntroducerApply [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx?action=reject",DomainName,Method_His_Crm]

//DEF_URL Validate_URL =@"http://122.114.62.57/ashx/Register2Handler.ashx?action=getValidateCode";
#define Validate_URL [NSString stringWithFormat:@"%@ashx/Register2Handler.ashx?action=getValidateCode",DomainName]

//DEF_URL Qrcode_URL = @"http://122.114.62.57/Weixin/CreateTicket.aspx";
#define Qrcode_URL [NSString stringWithFormat:@"%@%@/CreateTicket.aspx",DomainName,Method_Weixin]

//DEF_URL Forget_Validate_URL = @"http://122.114.62.57/sys/ashx/UserHandler.ashx?action=getValidateCode";
#define Forget_Validate_URL [NSString stringWithFormat:@"%@%@/ashx/UserHandler.ashx?action=getValidateCode",DomainName,Method_Sys]

//DEF_URL Forget_Password_URL = @"http://122.114.62.57/sys/ashx/UserHandler.ashx?action=forgetpass";
#define Forget_Password_URL [NSString stringWithFormat:@"%@%@/ashx/UserHandler.ashx?action=forgetpass",DomainName,Method_Sys]

@interface CRMHttpRequest (PersonalCenter)

#pragma mark - Account 
/**
 *  注册
 *
 *  @param nickname 昵称
 *  @param pwd      密码
 *  @param phone    手机号
 *  @param validate 验证码
 */
- (void)registerWithNickname:(NSString *)nick phone:(NSString *)phone passwd:(NSString *)passwd recommender:(NSString *)recommender validate:(NSString *)validate;

/**
 *  获取验证码
 *
 *  @param phoneNumber 昵称
 */
- (void)sendValidateToPhone:(NSString *)phoneNumber;

/**
 *  手机号、昵称登录
 *
 *  @param nickname 手机号或者账号名
 *  @param pwd      密码
 */
- (void)loginWithNickName:(NSString *)nickname passwd:(NSString *)pwd;

/**
 *  更新个人资料
 *
 *  @param Doctor 个人资料
 */
- (void)updateProfileWithDictionary:(Doctor *)doctor;

/**
 *  更新个人密码
 *
 *  @param oldpwd 老密码
 *  @param newpwd 新密码
 *  @param userId 用户Id
 */
- (void)updatePasswdWithOldpwd:(NSString *)oldpwd newpwd:(NSString *)newpwd userId:(NSString *)userId;

/**
 *  同意介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)approveIntroducerApply:(NSString *)introducer_id;

/**
 *  拒绝介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)refuseIntroducerApply:(NSString *)introducer_id;

/**
 *  获取医生二维码
 *
 *  @param user_id 医生id
 *  @param AccessToken  医生AccessToken
 */
- (void)getQrCode:(NSString *)user_id withAccessToken:(NSString *)AccessToken;

/**
 *  获取忘记密码页面的验证码
 *
 *  @param phoneNumber 昵称
 */
- (void)sendForgetValidateToPhone:(NSString *)phoneNumber;

/**
 *  忘记密码页面
 *
 *  @param newpwd   新密码
 *  @param phone    手机号
 *  @param validate 验证码
 */
- (void)forgetPasswordWithPhone:(NSString *)phone passwd:(NSString *)newpwd  validate:(NSString *)validate;

@end


@protocol CRMHttpRequestPersonalCenterDelegate <NSObject>

@optional
//注册
- (void)registerSucessWithResult:(NSDictionary *)result;
- (void)registerFailedWithError:(NSError *)error;

//登陆
- (void)loginSucessWithResult:(NSDictionary *)result;
- (void)loginFailedWithError:(NSError *)error;

//修改密码
- (void)updatePasswdSucessWithResult:(NSDictionary *)result;
- (void)updatePasswdFailedWithError:(NSError *)error;

//更新个人信息
- (void)updateUserInfoSuccessWithResult:(NSDictionary *)result;
- (void)updateUserInfoFailedWithError:(NSError *)error;

//接受申请
- (void)approveIntroducerApplySuccessWithResult:(NSDictionary *)result;
- (void)approveIntroducerApplyFailedWithError:(NSError *)error;

//拒绝申请
- (void)refuseIntroducerApplySuccessWithResult:(NSDictionary *)result;
- (void)refuseIntroducerApplyFailedWithError:(NSError *)error;

//获取验证码
- (void)sendValidateSuccessWithResult:(NSDictionary *)result;
- (void)sendValidateFailedWithError:(NSError *)error;

//获取忘记密码页面的验证码
- (void)sendForgetValidateSuccessWithResult:(NSDictionary *)result;
- (void)sendForgetValidateFailedWithError:(NSError *)error;

//获取二维码
- (void)qrCodeImageSuccessWithResult:(NSDictionary *)result;
- (void)qrCodeImageFailedWithError:(NSError *)error;

//忘记密码页面
- (void)forgetPasswordSucessWithResult:(NSDictionary *)result;
- (void)forgetPasswordFailedWithError:(NSError *)error;

@end
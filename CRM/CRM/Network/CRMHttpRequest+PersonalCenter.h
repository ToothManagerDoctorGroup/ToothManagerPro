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

#define RegisterOrValidate_Common_URL [NSString stringWithFormat:@"%@%@/Register2Handler.ashx",DomainName,Method_Ashx]

#define Login_URL [NSString stringWithFormat:@"%@%@/loginhandler.ashx",DomainName,Method_Ashx]

#define UpdateUserInfo_URL [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define ApproveOrRefuse_IntroducerApply [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

//获取二维码不加密
#define Qrcode_URL [NSString stringWithFormat:@"%@%@/CreateTicket.aspx",DomainName,Method_Weixin]
//获取二维码加密
#define Qrcode_URL_Encrypt [NSString stringWithFormat:@"%@%@/CreateTicketByCrpyt.aspx",DomainName,Method_Weixin]

#define ForgetOrUpdate_Password_Validate_URL [NSString stringWithFormat:@"%@%@/%@/UserHandler.ashx",DomainName,Method_Sys,Method_Ashx]

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
- (void)getQrCode:(NSString *)user_id withAccessToken:(NSString *)AccessToken patientKeyId:(NSString *)patientKeyId isDoctor:(BOOL)isDoctor;

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
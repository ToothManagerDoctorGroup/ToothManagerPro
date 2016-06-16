//
//  AccountManager.h
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"
#import "DBTableMode.h"
#import "TimManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "CRMHttpRequest+Notification.h"

@interface AccountManager : TimManager

Declare_ShareInstance(AccountManager);

@property (nonatomic,retain) UserObject *currentUser;
@property (nonatomic,readonly) BOOL isLogin;
+ (NSString *)currentUserid;

- (void)setUserinfoWithDictionary:(NSDictionary *)dic;
- (void)refreshCurrentUserInfo;
@end

@interface AccountManager (Request)

/**
 *  注册
 *
 *  @param nickname     用户名
 *  @param pwd          密码
 *  @param email        手机号
 *  @param successBlock 请求发出成功block
 *  @param failedBlock  请求发出失败block
 */
- (void)registerWithNickName:(NSString *)nickname passwd:(NSString *)pwd
                       phone:(NSString *)phone recommender:(NSString *)recommender validate:(NSString *)validate
                successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  注册获取验证码
 *
 *  @param phoneNumber     手机号
 */
- (void)sendValidateCodeToPhone:(NSString *)phoneNumber successBlock:(RequestSuccessBlock)successBlock
                    failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  忘记密码页面获取验证码
 *
 *  @param phoneNumber     手机号
 */
- (void)sendForgetValidateCodeToPhone:(NSString *)phoneNumber successBlock:(RequestSuccessBlock)successBlock
                    failedBlock:(RequestFailedBlock)failedBlock;
/**
 *  登陆
 *
 *  @param nickname     昵称
 *  @param pwd          密码
 *  @param successBlock 请求发出成功block
 *  @param failedBlock  请求发出失败block
 */
- (void)loginWithNickName:(NSString *)nickname passwd:(NSString *)pwd successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 * 退出登陆
 **/
- (void)logout;

/**
 *  更改用户密码
 *
 *  @param oldpwd 老密码
 *  @param newpwd 新密码
 *  @param userId 用户Id
 *  @param comfirmpwd 确认密码
 */
- (void)updatePasswdWithOldpwd:(NSString *)oldpwd newpwd:(NSString *)newpwd comfirmPwd:(NSString *)confirmpwd userId:(NSString *)userId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  获取 好友通知消息
 *
 *  @param userid 用户id
 */
- (void)getFriendsNotificationListWithUserid:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 * 获取转入患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getInpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 * 获取转出患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getOutpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  获取系统消息列表
 *
 *  @param userid 用户id
 */
- (void)getSystemNotificationListWithUserid:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  更新用户信息
 *
 *  @param Doctor 用户信息【用户就是一个医生】
 *
 */
- (void)updateUserInfo:(Doctor *)doctor successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  通过介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)approveIntroducerApply:(NSString *)introducer_id successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  拒绝介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)refuseIntroducerApply:(NSString *)introducer_id successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  获取医生二维码
 *
 *  @param user_id 医生id
 *  @param AccessToken  医生AccessToken
 */
- (void)getQrCode:(NSString *)user_id withAccessToken:(NSString *)AccessToken patientKeyId:(NSString *)patientKeyId isDoctor:(BOOL)isDoctor successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  忘记密码页面
 *
 *  @param newpwd   新密码
 *  @param phone    手机号
 *  @param validate 验证码
 */
- (void)forgetPasswordWithPhone:(NSString *)phone passwd:(NSString *)newpwd  validate:(NSString *)validate successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

-(void)uploadUserAvatar:(NSData*)data withUserid:(NSString *)userid;
@end

//
//  AccountManager.m
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "DBManager+User.h"
#import "NSString+Conversion.h"
#import "NSError+Extension.h"
#import "CRMMacro.h"
#import "CRMHttpRequest+Doctor.h"
#import "RemoteNotificationCenter.h"
#import "TimTabBarViewController.h"

@implementation AccountManager

Realize_ShareInstance(AccountManager);

- (id)init {
    self = [super init];
    if (self) {
        NSString *latest_userid = [CRMUserDefalut latestUserId];
        if ([latest_userid isNotEmpty]) {
            _currentUser = [[DBManager shareInstance] getUserObjectWithUserId:latest_userid];
        } else {
            _currentUser = [[UserObject alloc]init];
        }
    }
    return self;
}

- (BOOL)isLogin {
    if ([NSString isEmptyString:self.currentUser.userid] ) { //todo xh 记得要把这个判断打开|| [NSString isEmptyString:self.currentUser.accesstoken]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)setUserinfoWithDictionary:(NSDictionary *)dic {
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [userobj setUserObjectWithDic:dic];
    [[DBManager shareInstance] insertUserWithUserObject:userobj];
    [CRMUserDefalut setLatestUserId:userobj.userid];
    [CRMUserDefalut setObject:userobj.name forKey:LatestUserName];
}

- (void)refreshCurrentUserInfo {
    NSString *latest_userid = [CRMUserDefalut latestUserId];
    if ([latest_userid isNotEmpty]) {
        _currentUser = [[DBManager shareInstance] getUserObjectWithUserId:latest_userid];
    } else {
        _currentUser = [[UserObject alloc]init];
    }
}

+ (NSString *)currentUserid {
    return [AccountManager shareInstance].currentUser.userid;
}

@end

@implementation AccountManager (Request)

/**
 *  注册
 *
 *  @param nickname     用户名
 *  @param pwd          密码
 *  @param email        手机号
 *  @param successBlock 请求发出成功block
 *  @param failedBlock  请求发出失败block
 */
- (void)registerWithNickName:(NSString *)nickname passwd:(NSString *)pwd phone:(NSString *)phone recommender:(NSString *)recommender validate:(NSString *)validate successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    ValidationResult ret = ValidationResultValid;//[nickname isValidWithFormat:@"^[a-zA-Z0-9]{3,15}$"];
    
    ret = [phone isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"手机号格式错误" errorCode:400]);
        return;
    }
    
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"手机号不能为空" errorCode:400]);
        return;
    }
    
    if (validate.length <= 0) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"验证码不能为空" errorCode:400]);
        return;
    }
    
    ret = [pwd isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码格式错误" errorCode:400]);
        return;
    }
    
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码不能为空" errorCode:400]);
        return;
    }
    
    [[CRMHttpRequest shareInstance] registerWithNickname:nickname phone:phone passwd:pwd recommender:recommender validate:validate];
    successBlock();
}

/**
 *  忘记密码页面
 *
 *  @param newpwd   新密码
 *  @param phone    手机号
 *  @param validate 验证码
 */
- (void)forgetPasswordWithPhone:(NSString *)phone passwd:(NSString *)newpwd  validate:(NSString *)validate successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    ValidationResult ret = ValidationResultValid;//[nickname isValidWithFormat:@"^[a-zA-Z0-9]{3,15}$"];
    
    ret = [newpwd isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码格式错误" errorCode:400]);
        return;
    }
    
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码不能为空" errorCode:400]);
        return;
    }
    
    ret = [phone isValidWithFormat:@"^[0-9]{6,14}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"手机号格式错误" errorCode:400]);
        return;
    }
    
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"手机号不能为空" errorCode:400]);
        return;
    }
    
    if (validate.length <= 0) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"验证码不能为空" errorCode:400]);
        return;
    }
    
    [[CRMHttpRequest shareInstance] forgetPasswordWithPhone:phone passwd:newpwd validate:validate];
    successBlock();
}
/**
 *  注册获取验证码
 *
 *  @param phoneNumber     手机号
 */
- (void)sendValidateCodeToPhone:(NSString *)phoneNumber successBlock:(RequestSuccessBlock)successBlock
                    failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance] sendValidateToPhone:phoneNumber];
    successBlock();
}
/**
 *  忘记密码页面获取验证码
 *
 *  @param phoneNumber     手机号
 */
- (void)sendForgetValidateCodeToPhone:(NSString *)phoneNumber successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance] sendForgetValidateToPhone:phoneNumber];
    successBlock();
}
- (void)loginWithNickName:(NSString *)nickname passwd:(NSString *)pwd successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    ValidationResult ret = ValidationResultValid; //[nickname isValidWithFormat:@"^[\u4e00-\u9fa5]{3,15}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"昵称格式错误" errorCode:400]);
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"昵称不能为空" errorCode:400]);
        return;
    }
    ret = [pwd isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码格式错误" errorCode:400]);
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"密码不能为空" errorCode:400]);
        return;
    }
    
    [[CRMHttpRequest shareInstance] loginWithNickName:nickname passwd:pwd];
    successBlock();
}

- (void)logout {
    self.currentUser.userid = nil;
    self.currentUser.accesstoken = nil;
    [CRMUserDefalut setLatestUserId:nil];
    [CRMUserDefalut setLatestUserPassword:nil];
    NSString *signKey = kUserIsSignKey([self currentUser].userid);
    [CRMUserDefalut setObject:nil forKey:signKey];
    //取消定时器
    TimTabBarViewController *tabVc = (TimTabBarViewController *)[[RemoteNotificationCenter shareInstance] getCurrentVC];
    [tabVc closeAllTimer];
    
    //取消所有的下载操作
    [[CRMHttpRequest shareInstance] cancelAllOperations];
    //发送退出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SignOutSuccessNotification object:nil];
}

/**
 *  更改用户密码
 *
 *  @param oldpwd 老密码
 *  @param newpwd 新密码
 *  @param comfirmpwd 确认密码
 *  @param userId  用户id
 */
- (void)updatePasswdWithOldpwd:(NSString *)oldpwd newpwd:(NSString *)newpwd comfirmPwd:(NSString *)confirmpwd userId:(NSString *)userId successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    ValidationResult ret = ValidationResultValid;
    ret = [oldpwd isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"当前密码格式错误" errorCode:400]);
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"当前密码不能为空" errorCode:400]);
        return;
    }
    if (![newpwd isEqualToString:confirmpwd]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"两次输入的密码不一致" errorCode:400]);
        return;
    }
    ret = [newpwd isValidWithFormat:@"^[0-9|A-Z|a-z]{6,16}$"];
    if (ret == ValidationResultInValid)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"新密码格式错误" errorCode:400]);
        return;
    }
    if (ret == ValidationResultValidateStringIsEmpty)
    {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"新密码不能为空" errorCode:400]);
        return;
    }
    if ([oldpwd isEqualToString:newpwd]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"新密码不能与原密码相同" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] updatePasswdWithOldpwd:oldpwd newpwd:newpwd userId:userId];
    successBlock();
}

/**
 *  获取 好友通知消息
 *
 *  @param userid 用户id
 */
- (void)getFriendsNotificationListWithUserid:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if ([NSString isEmptyString:userid]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] getFriendsNotificationListWithUserid:userid];
    successBlock();
}

/**
 * 获取转入患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getInpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if ([NSString isEmptyString:userid]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] getInpatientNotificationListWithUserid:userid Sync_time:sync_time];
    successBlock();
}

/**
 * 获取转出患者消息通知
 *
 * @param userid 介绍人id
 * @param sync_time 同步时间
 */
- (void)getOutpatientNotificationListWithUserid:(NSString *)userid Sync_time:(NSString *)sync_time successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock
{
    if ([NSString isEmptyString:userid]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] getOutpatientNotificationListWithUserid:userid Sync_time:sync_time];
    successBlock();
}

/**
 *  获取系统消息列表
 *
 *  @param userid 用户id
 */
- (void)getSystemNotificationListWithUserid:(NSString *)userid successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if ([NSString isEmptyString:userid]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] getSystemNotificationListWithUserid:userid];
    successBlock();
}
/**
 *  更新用户信息
 *
 *  @param Doctor 用户信息【用户就是一个医生】
 *
 */
- (void)updateUserInfo:(Doctor *)doctor successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock
{
    [[CRMHttpRequest shareInstance] updateProfileWithDictionary:doctor];
    successBlock();
}

/**
 *  通过介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)approveIntroducerApply:(NSString *)introducer_id successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if ([NSString isEmptyString:introducer_id]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] approveIntroducerApply:introducer_id];
    successBlock();
}

/**
 *  拒绝介绍人申请
 *
 *  @param introducer_id 介绍人id
 */
- (void)refuseIntroducerApply:(NSString *)introducer_id successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock {
    if ([NSString isEmptyString:introducer_id]) {
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"参数错误" errorCode:400]);
        return;
    }
    [[CRMHttpRequest shareInstance] refuseIntroducerApply:introducer_id];
    successBlock();
}


/**
 *  获取医生二维码
 *
 *  @param user_id 医生id
 *  @param AccessToken  医生AccessToken
 */
- (void)getQrCode:(NSString *)user_id withAccessToken:(NSString *)AccessToken patientKeyId:(NSString *)patientKeyId isDoctor:(BOOL)isDoctor successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    if(user_id == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
    }
    [[CRMHttpRequest shareInstance] getQrCode:user_id withAccessToken:AccessToken patientKeyId:patientKeyId isDoctor:isDoctor];
    
    successBlock();
}

-(void)uploadUserAvatar:(NSData*)data withUserid:(NSString *)userid {
    [[CRMHttpRequest shareInstance] doctorIconWithUserId:userid withData:data];
    
}

@end


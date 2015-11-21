//
//  TTMUser.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  用户Model
 */
@interface TTMUser : NSObject

/**
 *  访问码
 */
@property (nonatomic, copy)   NSString *accessToken;
/**
 *  用户id
 */
@property (nonatomic, copy)   NSString *keyId;
/**
 *  用户名
 */
@property (nonatomic, copy)   NSString *username;
/**
 *  密码
 */
@property (nonatomic, copy)   NSString *password;
/**
 *  手机号
 */
@property (nonatomic, copy)   NSString *mobile;
/**
 *  邮箱
 */
@property (nonatomic, copy)   NSString *email;
/**
 *  微信
 */
@property (nonatomic, copy)   NSString *weixin;
/**
 *  qq
 */
@property (nonatomic, copy)   NSString *qq;


/**
 *  存入本地
 */
- (void)archiveUser;
/**
 *  从本地获取
 *
 *  @return TTMUser
 */
+ (TTMUser *)unArchiveUser;

/**
 *  登录
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param complete 回调
 */
+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                 Complete:(CompleteBlock)complete;
/**
 *  修改登录密码
 *
 *  @param passOld  旧密码
 *  @param passNew  新密码
 *  @param complete 回调
 */
+ (void)updatePassword:(NSString *)passOld
                   new:(NSString *)passNew
              Complete:(CompleteBlock)complete;
/**
 *  修改支付密码第一步
 *
 *  @param passOld  旧密码
 *  @param complete 回调
 */
+ (void)updatePayPassword:(NSString *)passOld
                 Complete:(CompleteBlock)complete;
/**
 *  修改支付密码第二步
 *
 *  @param passNew  新密码
 *  @param complete 回调
 */
+ (void)updatePayPasswordNew:(NSString *)passNew
                    Complete:(CompleteBlock)complete;

/**
 *  发送验证码
 *
 *  @param mobile  手机号
 */
+ (void)sendValidateCodeWithMobile:(NSString *)mobile
                          Complete:(CompleteBlock)complete;
/**
 *  忘记密码
 *
 *  @param mobile       手机
 *  @param validatecode 验证码
 *  @param passNew      新密码
 *  @param complete     回调
 */
+ (void)forgetPasswordWithMobile:(NSString *)mobile
                    validatecode:(NSString *)validatecode
                         passNew:(NSString *)passNew
                        Complete:(CompleteBlock)complete;
@end

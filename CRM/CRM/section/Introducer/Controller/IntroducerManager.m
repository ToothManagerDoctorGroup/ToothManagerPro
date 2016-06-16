//
//  IntroducerManager.m
//  CRM
//
//  Created by TimTiger on 10/28/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "IntroducerManager.h"
#import "AccountManager.h"
#import "NSError+Extension.h"
#import "CRMHttpRequest+Introducer.h"

@implementation IntroducerManager
Realize_ShareInstance(IntroducerManager);

- (void)applyToBecomeIntroducerWithDoctorId:(NSString *)doctorid successBlock:(RequestSuccessBlock)sucessblock failedBlock:(RequestFailedBlock)failedblock{
    if (doctorid < 0) {
        failedblock([NSError errorWithDomain:@"申请失败" localizedDescription:@"医生信息错误" errorCode:400]);
    }
    sucessblock();
    [[CRMHttpRequest shareInstance] applyToBecomeIntroducerWithDoctorId:doctorid];
}

/**
 *  介绍人短信长链接转短链接
 *
 *  @param source 应用的app key
 *  @param access_token  AccessToken
 *  @param  url_long   长链接，需要URLencoded
 */
- (void)longUrlToShortUrl:(NSString *)source withAccessToken:(NSString *)AccessToken withLongUrl:(NSString *)url_long successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    [[CRMHttpRequest shareInstance]longUrlToShortUrl:source withAccessToken:AccessToken withLongUrl:url_long];
     successBlock();
}

/**
 *  将患者转换为介绍人
 *
 *  @param userId 当前用户的userId
 *  @param ckeyid  当前患者的ckeyid
 *  @param  name   当前患者的姓名
 *  @param  phone   当前患者的电话
 */
- (void)patientToIntroducer:(NSString *)userId withCkeyId:(NSString *)ckeyid withName:(NSString *)name withPhone:(NSString *)phone successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock{
    ValidationResult ret = ValidationResultValid;//[nickname isValidWithFormat:@"^[a-zA-Z0-9]{3,15}$"];
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
    if(userId == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请登录" errorCode:400]);
    }
    if(ckeyid == nil){
        failedBlock([NSError errorWithDomain:@"提示" localizedDescription:@"请先选择患者" errorCode:400]);
    }
    [[CRMHttpRequest shareInstance] patientToIntroducer:userId withCkeyId:ckeyid withName:name withPhone:phone];
    successBlock();
}
@end

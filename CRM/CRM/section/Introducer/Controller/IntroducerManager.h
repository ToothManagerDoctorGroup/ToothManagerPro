//
//  IntroducerManager.h
//  CRM
//
//  Created by TimTiger on 10/28/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimManager.h"
#import "CommonMacro.h"
#import "DBTableMode.h"
#import "TimManager.h"
#import "CRMHttpRequest+Introducer.h"

@interface IntroducerManager : TimManager
Declare_ShareInstance(IntroducerManager);

//- (void)getIntruducerRecommendList:();
/**
 *  申请成为某医生的介绍人
 *
 *  @param doctorid 医生id
 */
- (void)applyToBecomeIntroducerWithDoctorId:(NSString *)doctorid successBlock:(RequestSuccessBlock)sucessblock failedBlock:(RequestFailedBlock)failedblock;

/**
 *  介绍人短信长链接转短链接
 *
 *  @param source 应用的app key
 *  @param access_token  AccessToken
 *  @param  url_long   长链接，需要URLencoded
 */
- (void)longUrlToShortUrl:(NSString *)source withAccessToken:(NSString *)AccessToken withLongUrl:(NSString *)url_long successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;

/**
 *  将患者转换为介绍人
 *
 *  @param userId 当前用户的userId
 *  @param ckeyid  当前患者的ckeyid
 *  @param  name   当前患者的姓名
 *  @param  phone   当前患者的电话
 */
- (void)patientToIntroducer:(NSString *)userId withCkeyId:(NSString *)ckeyid withName:(NSString *)name withPhone:(NSString *)phone successBlock:(RequestSuccessBlock)successBlock failedBlock:(RequestFailedBlock)failedBlock;
@end

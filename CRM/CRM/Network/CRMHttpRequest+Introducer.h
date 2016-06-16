//
//  TimRequest+Introducer.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"

DEF_STATIC_CONST_STRING(Introducer_Prefix,Introducer);

#define ApplyToBecomeIntroducer_URL [NSString stringWithFormat:@"%@%@/%@/NotificationFriendHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

DEF_URL LongUrlToShortUrlSinaApi = @"https://api.weibo.com/2/short_url/shorten.json";

#define PatientToIntroducer_URL [NSString stringWithFormat:@"%@%@/%@/TransformPatient.ashx",DomainName,Method_His_Crm,Method_Ashx]

#define PatientIntroducerMap_Common_URL [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx]

@interface CRMHttpRequest (Introducer)

- (void)getIntroducerDataArray;

/**
 *  申请成为介绍人
 *
 *  @param dotorid 医生id
 */
- (void)applyToBecomeIntroducerWithDoctorId:(NSString *)dotorid;

/**
 *  介绍人短信长链接转短链接
 *
 *  @param source 应用的app key
 *  @param access_token  AccessToken
 *  @param  url_long   长链接，需要URLencoded
 */
- (void)longUrlToShortUrl:(NSString *)source withAccessToken:(NSString *)access_token withLongUrl:(NSString *)url_long;


/**
 *  将患者转换为介绍人
 *
 *  @param userId 当前用户的userId
 *  @param ckeyid  当前患者的ckeyid
 *  @param  name   当前患者的姓名
 *  @param  phone   当前患者的电话
 */
- (void)patientToIntroducer:(NSString *)userId withCkeyId:(NSString *)ckeyid withName:(NSString *)name withPhone:(NSString *)phone;


/**
 *  患者介绍人表
 *
 *  @param userId 当前用户的userId
 */
-(void)getPatientIntroducerMap:(NSString *)userId;


/**
 *  post患者介绍人Map
 *
 */
-(void)postPatientIntroducerMap:(NSString *)patientId withDoctorId:(NSString *)doctorId withIntrId:(NSString *)intrId;


@end


@protocol RequestIntroducerDelegate <NSObject>

@optional
- (void)onRequestGetIntroducersSucc;

- (void)applyToBecomeIntroducerSuccess:(NSDictionary *)result;
- (void)applyToBecomeIntroducerFailed:(NSError *)error;

- (void)longUrlToShortUrlSucessWithResult:(NSDictionary *)result;
- (void)longUrlToShortUrlFailedWithError:(NSError *)error;

- (void)patientToIntroducerSuccess:(NSDictionary *)result;
- (void)patientToIntroducerFailed:(NSError *)error;

-(void)getPatientIntroducerMapSuccess:(NSDictionary *)result;
-(void)getPatientIntroducerMapFailed:(NSError *)error;

-(void)postPatientIntroducerMapSuccess:(NSDictionary *)result;
-(void)postPatientIntroducerMapFailed:(NSError *)error;
@end
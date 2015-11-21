//
//  CRMHttpRequest+Patients.h
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest.h"
#import "DBTableMode.h"

DEF_STATIC_CONST_STRING(Patient_Prefix,Patient);
DEF_URL Patient_Add_URL =  @"http://122.114.62.57/his.crm/ashx/SyncPost.ashx?table=patient&action=add";

@interface CRMHttpRequest (Patients)

/**
 *  post
 *
 *  @param userid 个人id
 */
- (void)postPatientSyncWithPatient:(Patient *)pat;


@end

@protocol CRMHttpRequestPatientDelegate <NSObject>

@optional

//post 病人
- (void)postPatientSyncWithPatientSuccessWithResult:(NSDictionary *)result;
- (void)postPatientSyncWithPatientFailedWithError:(NSError *)error;
@end

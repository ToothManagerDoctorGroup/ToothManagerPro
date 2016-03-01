//
//  CRMHttpRequest+Patients.m
//  CRM
//
//  Created by TimTiger on 5/15/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "CRMHttpRequest+Patients.h"
#import "NSError+Extension.h"
#import "NSJSONSerialization+jsonString.h"
@implementation CRMHttpRequest (Patients)


-(void)postPatientSyncWithPatient:(Patient *)pat{
    if(pat == nil){
        return;
    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [subParamDic setObject:pat.ckeyid forKey:@"ckeyid"];
    [subParamDic setObject:[NSString currentDateString] forKey:@"sync_time"];
    [subParamDic setObject:pat.patient_name forKey:@"patient_name"];
    [subParamDic setObject:pat.patient_phone forKey:@"patient_phone"];
    [subParamDic setObject:@"bb.jpg" forKey:@"patient_avatar"];
    if (nil != pat.patient_gender) {
        [subParamDic setObject:pat.patient_gender forKey:@"patient_gender"];
    } else {
        [subParamDic setObject:@"0" forKey:@"patient_gender"];
    }
    if (nil != pat.patient_age) {
        [subParamDic setObject:pat.patient_age forKey:@"patient_age"];
    } else {
        [subParamDic setObject:@"" forKey:@"patient_age"];
    }
    [subParamDic setObject:[[NSNumber numberWithInt: pat.patient_status] stringValue] forKey:@"patient_status"];
    [subParamDic setObject:pat.introducer_id forKey:@"introducer_id"];
    [subParamDic setObject:pat.doctor_id forKey:@"doctor_id"];
    
    [subParamDic setObject:pat.patient_allergy forKey:@"patient_allergy"];
    [subParamDic setObject:pat.patient_remark forKey:@"patient_remark"];
    [subParamDic setObject:pat.idCardNum forKey:@"IdCardNum"];
    [subParamDic setObject:pat.patient_address forKey:@"patient_address"];
    [subParamDic setObject:pat.anamnesis forKey:@"Anamnesis"];
    [subParamDic setObject:pat.nickName forKey:@"NickName"];
    
    /*
    NSString *jsonString = [NSJSONSerialization jsonStringWithObject:dataEntity];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    TimRequestParam *param = [TimRequestParam paramWithURLSting:Patient_Add_URL andParams:paramDic withPrefix:Patient_Prefix];
    [self requestWithParams:param];
     */
}

@end

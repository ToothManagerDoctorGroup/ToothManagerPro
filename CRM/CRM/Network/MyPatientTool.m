//
//  MyPatientTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "MyPatientTool.h"
#import "CRMHttpTool.h"
#import "CRMHttpRespondModel.h"
#import "JSONKit.h"
#import "XLPatientTotalInfoModel.h"

#define ActionParam @"action"
#define Patient_NameParam @"patient_name"
#define Patient_PhoneParam @"patient_phone"

@implementation MyPatientTool

+ (void)getPatientAllInfosWithPatientId:(NSString *)patientId doctorID:(NSString *)doctorId success:(void(^)(XLPatientTotalInfoModel *model))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/PatientHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = @"GetPatientAllInfo";
    params[@"patient_id"] = patientId;
    params[@"doctor_id"] = doctorId;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:responseObject[@"Result"]];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)getWeixinStatusWithPatientName:(NSString *)patientName patientPhone:(NSString *)patientPhone success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/PatientInfoHandler.ashx",DomainName,Method_Weixin];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = @"weixinBind";
//    NSString *encodingPatientName = [patientName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params[Patient_NameParam] = patientName;
    params[Patient_PhoneParam] = patientPhone;
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respond);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}


+ (void)postAppointInfoTuiSongClinic:(NSString *)patientId withClinicName:(NSString*)clinic_name withCliniId:(NSString*)clinic_id withDoctorId:(NSString*)doctor_id withAppointTime:(NSString *)appoint_time withDuration:(float)duration withSeatPrice:(float)seat_price withAppointMoney:(float)appoint_money withAppointType:(NSString *)appoint_type withSeatId:(NSString *)seat_id withToothPosition:(NSString *)tooth_position withAssist:(NSArray *)assist withMaterial:(NSArray *)material success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:16];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctor_id forKey:@"doctor_id"];
    [dataEntity setObject:clinic_name forKey:@"clinic_name"];
    [dataEntity setObject:clinic_id forKey:@"clinic_id"];
    [dataEntity setObject:appoint_time forKey:@"appoint_time"];
    
    [dataEntity setObject:[NSString stringWithFormat:@"%f",duration] forKey:@"duration"];
    [dataEntity setObject:[NSString stringWithFormat:@"%f",seat_price] forKey:@"seat_price"];
    [dataEntity setObject:[NSString stringWithFormat:@"%f",appoint_money] forKey:@"appoint_money"];
    
    [dataEntity setObject:appoint_type forKey:@"appoint_type"];
    [dataEntity setObject:seat_id forKey:@"seat_id"];
    [dataEntity setObject:tooth_position forKey:@"tooth_position"];
    
    [dataEntity setObject:assist forKey:@"assist"];
    [dataEntity setObject:material forKey:@"material"];
    
    [dataEntity setObject:@"xuyaopeihe" forKey:@"remark"];
    [dataEntity setObject:@"0" forKey:@"expert_result"];
    [dataEntity setObject:@"可以做" forKey:@"expert_suggestion"];
    
    
    NSString *jsonString = [dataEntity JSONString];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/ClinicMessage.ashx?action=appoint",DomainName,Method_His_Crm];
    
    [CRMHttpTool POST:urlStr parameters:paramDic success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respond);
        }
    } failure:^(NSError *error) {
        if(failure){
            failure(error);
        }
    }];
}

@end

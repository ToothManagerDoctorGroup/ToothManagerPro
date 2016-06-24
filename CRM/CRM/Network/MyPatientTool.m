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
#import "NSString+TTMAddtion.h"
#import "CRMUnEncryptedHttpTool.h"
#import "XLAppointImageUploadParam.h"

#define ActionParam @"action"
#define Patient_NameParam @"patient_name"
#define Patient_PhoneParam @"patient_phone"
#define Doctor_IdParam @"doctor_id"
#define Patient_IdParam @"ckeyId"

@implementation MyPatientTool

+ (void)getPateintKeyIdWithPatientCKeyId:(NSString *)ckeyid success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientInfoHandler.ashx",DomainName,Method_Weixin,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = [@"getPatientKeyIdByCkeyId" TripleDESIsEncrypt:YES];
    params[@"ckeyid"] = [ckeyid TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
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

+ (void)getPatientAllInfosWithPatientId:(NSString *)patientId doctorID:(NSString *)doctorId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = [@"newgetpatientallinfo" TripleDESIsEncrypt:YES];
    params[@"patient_id"] = [patientId TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondT = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        
        if (success) {
            success(respondT);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)getWeixinStatusWithPatientId:(NSString *)patientId success:(void (^)(CRMHttpRespondModel *))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientInfoHandler.ashx",DomainName,Method_Weixin,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = [@"weixinBind" TripleDESIsEncrypt:YES];
    params[Patient_IdParam] = [patientId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
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
    paramDic[@"action"] = @"appoint";
    paramDic[@"DataEntity"] = jsonString;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ClinicMessage.ashx",DomainName,Method_His_Crm,@"ashx"];
    
    [[CRMHttpTool shareInstance] logWithUrlStr:urlStr params:paramDic];
    
    [[CRMUnEncryptedHttpTool shareInstance] POST:urlStr parameters:paramDic success:^(id responseObject) {
        
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


/**
 *  上传预约所需图片
 *
 *  @param param   参数模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)uploadAppointmentImageWithParam:(XLAppointImageUploadParam *)param imageData:(NSData *)imageData success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/ReserverFilesHandler.ashx",DomainName,Method_ClinicServer,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = @"add";
    params[@"DataEntity"] = [param.keyValues JSONString];
    
    MyUploadParam *upLoadParam = [[MyUploadParam alloc] init];
    upLoadParam.data = imageData;
    upLoadParam.name = @"uploadfile";
    upLoadParam.fileName = param.file_name;
    upLoadParam.mimeType = @"image/png,image/jpeg,image/pjpeg";
    
    [[CRMUnEncryptedHttpTool shareInstance] POST:urlStr parameters:params uploadParam:upLoadParam success:^(id responseObject) {
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

/**
 *  获取患者CT的状态
 *
 *  @param ckeyIds CTLib的id，中间用“，”隔开
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPatientCTStatusCTCkeyIds:(NSString *)ckeyIds success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CtLibHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ActionParam] = [@"getctstatus" TripleDESIsEncrypt:YES];
    params[@"ct_ckeyids"] = [ckeyIds TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] logWithUrlStr:urlStr params:params];
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *mArray = [NSMutableArray array];
        if ([respond.code integerValue] == 200) {
            for (NSDictionary *dic in respond.result) {
                XLPatientCTStatusModel *model = [XLPatientCTStatusModel objectWithKeyValues:dic];
                [mArray addObject:model];
            }
        }
        if (success) {
            success(mArray);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

@end


@implementation XLPatientCTStatusModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ckeyid" : @"Ckeyid",
             @"fileStatus" : @"FileStatus"};
}

@end

//
//  DoctorTool.m
//  CRM
//
//  Created by Argo Zhang on 15/11/18.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorTool.h"
#import "CRMHttpTool.h"
#import "DoctorInfoModel.h"
#import "MyUploadParam.h"
#import "JSONKit.h"
#import "CRMHttpRespondModel.h"


#define userIdParam @"userid"
#define requestActionParam @"action"
@implementation DoctorTool

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getdatabyid";
    params[userIdParam] = doctorId;
    
    
    [CRMHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        DoctorInfoModel *doctorInfo = [DoctorInfoModel objectWithKeyValues:[responseObject[@"Result"] lastObject]];
        if (success) {
            success(doctorInfo);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void (^)())success failure:(void (^)(NSError *))failure{
    
    //创建上传参数
    MyUploadParam *uploadParam = [[MyUploadParam alloc] init];
    uploadParam.data = UIImageJPEGRepresentation(image, .2);
    uploadParam.name = @"pic";
    uploadParam.fileName = [NSString stringWithFormat:@"%@.jpg",userId];
    uploadParam.mimeType = @"image/png,image/jpeg,image/pjpeg";
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Action"] = @"avatar";
    params[@"KeyId"] = userId;
    
    [CRMHttpTool Upload:@"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx" parameters:params uploadParam:uploadParam success:^{
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)deleteFriendWithDoctorId:(NSString *)doctorId introId:(NSString *)introId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"delete";
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    dataEntity[@"doctor_id"] = doctorId;
    dataEntity[@"intr_id"] = introId;
    params[@"DataEntity"] = [dataEntity JSONString];
    
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


+ (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = @"http://122.114.62.57/Weixin/ashx/DoctorPatientMapHandler.ashx";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getMessageItem";
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    
    params[@"DataEntity"] = [dataEntity JSONString];
    
    [CRMHttpTool POST:urlStr parameters:params success:^(id responseObject) {
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

@end

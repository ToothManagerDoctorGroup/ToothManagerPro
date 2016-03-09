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
#import "DBTableMode.h"
#import "XLQueryModel.h"
#import "GroupMemberModel.h"
#import "JSONKit.h"
#import "MJExtension.h"

#define userIdParam @"userid"
#define requestActionParam @"action"
@implementation DoctorTool

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure{
    
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getdatabyid";
    params[userIdParam] = doctorId;
    
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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
+ (void)updateUserInfoWithDoctorInfoModel:(DoctorInfoModel *)doctorInfo ckeyId:(NSString *)ckeyId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx?action=edit",DomainName,Method_His_Crm];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    [dataEntity setObject:doctorInfo.doctor_id forKey:@"doctor_id"];
    [dataEntity setObject:doctorInfo.doctor_name forKey:@"doctor_name"];
    [dataEntity setObject:doctorInfo.doctor_dept forKey:@"doctor_dept"];
    [dataEntity setObject:doctorInfo.doctor_phone forKey:@"doctor_phone"];
    [dataEntity setObject:doctorInfo.doctor_hospital forKey:@"doctor_hospital"];
    [dataEntity setObject:doctorInfo.doctor_position forKey:@"doctor_position"];
    [dataEntity setObject:doctorInfo.doctor_degree forKey:@"doctor_degree"];
    [dataEntity setObject:doctorInfo.doctor_image forKey:@"doctor_image"];
    [dataEntity setObject:@"0" forKey:@"doctor_is_verified"];
    [dataEntity setObject:@"" forKey:@"doctor_verify_reason"];
    [dataEntity setObject:doctorInfo.doctor_certificate forKey:@"doctor_certificate"];
    [dataEntity setObject:doctorInfo.doctor_birthday forKey:@"doctor_birthday"];
    [dataEntity setObject:doctorInfo.doctor_gender forKey:@"doctor_gender"];
    [dataEntity setObject:doctorInfo.doctor_cv forKey:@"doctor_cv"];
    [dataEntity setObject:doctorInfo.doctor_skill forKey:@"doctor_skill"];
    
    [dataEntity setObject:[NSString stringWithFormat:@"%@",doctorInfo.is_open] forKey:@"is_open"];
    
    NSString *jsonString = [dataEntity JSONString];
    [paramDic setObject:ckeyId forKey:@"keyid"];
    [paramDic setObject:jsonString forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:paramDic success:^(id responseObject) {
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


+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void (^)())success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorInfoHandler.ashx",DomainName,Method_His_Crm];
    
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
    
    [[CRMHttpTool shareInstance] Upload:urlStr parameters:params uploadParam:uploadParam success:^{
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
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"delete";
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    dataEntity[@"doctor_id"] = doctorId;
    dataEntity[@"intr_id"] = introId;
    params[@"DataEntity"] = [dataEntity JSONString];
    
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


+ (void)yuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/Weixin/ashx/DoctorPatientMapHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorPatientMapHandler.ashx",DomainName,Method_Weixin];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = @"getMessageItem";
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    
    params[@"DataEntity"] = [dataEntity JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
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

+ (void)getDoctorFriendListWithDoctorId:(NSString *)doctorId success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getintroducer";
    params[@"uid"] = doctorId;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSLog(@"我的类型:%@",[responseObject class]);
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        if ([responseObject[@"Code"] integerValue] == 200) {
            
            for (NSDictionary *dic in array) {
                Doctor *doctor = [Doctor DoctorFromDoctorResult:dic];
                [arrayM addObject:doctor];
            }
        }
        if (success) {
            success(arrayM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)transferPatientWithPatientId:(NSString *)patientId doctorId:(NSString *)doctorId receiverId:(NSString *)receiverId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/NotificationPatientHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"transfer";

    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:4];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:receiverId forKey:@"doctor_id"];
    [dataEntity setObject:doctorId forKey:@"intr_id"];
    [dataEntity setObject:@"I" forKey:@"intr_source"];
    
    [params setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        CRMHttpRespondModel *model = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getDoctorFriendListWithDoctorId:(NSString *)doctorId syncTime:(NSString *)sync_time queryInfo:(XLQueryModel *)info success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetIntroducerByPage";
    params[@"uid"] = doctorId;
    params[@"sync_time"] = sync_time;
    params[@"query_info"] = [info.keyValues JSONString];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        if ([responseObject[@"Code"] integerValue] == 200) {
            
            for (NSDictionary *dic in array) {
                Doctor *doctor = [Doctor DoctorWithPatientCountFromDoctorResult:dic];
                [arrayM addObject:doctor];
            }
        }
        if (success) {
            success(arrayM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryPlantPatientsWithDoctorId:(NSString *)doctor_id beginDate:(NSString *)begin_date endDate:(NSString *)end_date success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure{
    ////ttp://118.244.234.207/his.crm/ashx/PatientHandler.ashx?action=listpatientbyimplanttime&doctor_id=156&begin_date=2015-01-01&end_date=2016-01-16
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/PatientHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listpatientbyimplanttime";
    params[@"doctor_id"] = doctor_id;
    params[@"begin_date"] = begin_date;
    params[@"end_date"] = end_date;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        if ([responseObject[@"Code"] integerValue] == 200) {
            
            for (NSDictionary *dic in array) {
                GroupMemberModel *member = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:member];
            }
        }
        if (success) {
            success(arrayM);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)queryRepairPatientsWithDoctorId:(NSString *)doctor_id beginDate:(NSString *)begin_date endDate:(NSString *)end_date repairDoctorId:(NSString *)repair_doctor_id success:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure{
    //ttp://118.244.234.207/his.crm/ashx/PatientHandler.ashx?action=listpatientbyrepairtime&doctor_id=156&begin_date=2015-01-01&end_date=2016-01-16&repair_doctor_id=156_20141204083956
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/PatientHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"listpatientbyrepairtime";
    params[@"doctor_id"] = doctor_id;
    params[@"begin_date"] = begin_date;
    params[@"end_date"] = end_date;
    params[@"repair_doctor_id"] = repair_doctor_id;
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        NSArray *array = responseObject[@"Result"];
        if ([responseObject[@"Code"] integerValue] == 200) {
            
            for (NSDictionary *dic in array) {
                GroupMemberModel *member = [GroupMemberModel objectWithKeyValues:dic];
                [arrayM addObject:member];
            }
        }
        if (success) {
            success(arrayM);
        }
    
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendAdviceWithDoctorId:(NSString *)doctor_id content:(NSString *)content success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *error))failure{
    //ttp://localhost/his.crm/ashx/CustomerFeedbackHandler.ashx?action=Insert&DataEntity={"doctor_id":971,"content":"复苏动力科技"}
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/CustomerFeedbackHandler.ashx",DomainName,Method_His_Crm];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    dataEntity[@"doctor_id"] = doctor_id;
    dataEntity[@"content"] = content;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"Insert";
    param[@"DataEntity"] = [dataEntity JSONString];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
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

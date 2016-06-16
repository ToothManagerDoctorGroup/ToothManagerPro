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
#import "XLAssistenceModel.h"
#import "NSString+TTMAddtion.h"
#import "CRMUnEncryptedHttpTool.h"
#import "XLAdviceTypeModel.h"
#import "XLAdviceDetailModel.h"
#import "XLPatientEducationModel.h"
#import "XLChatRecordQueryModel.h"
#import "XLChatModel.h"
#import "AccountManager.h"
#import "XLAutoSyncTool.h"
#import "CRMUserDefalut.h"

#define userIdParam @"userid"
#define requestActionParam @"action"
@implementation DoctorTool

/**
 *  获取个人的医生列表
 *
 *  @param userid 个人id
 */
+ (void)getDoctorListWithUserid:(NSString *)userid success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [NSString TripleDES:@"getdatabyid" encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    params[@"userid"] = [NSString TripleDES:userid encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:NULL];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respondM = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(respondM);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(DoctorInfoModel *dcotorInfo))success failure:(void(^)(NSError *error))failure{
    
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorInfoHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"getdatabyid" TripleDESIsEncrypt:YES];
    params[userIdParam] = [doctorId TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
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
    [paramDic setObject:[@"edit" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[ckeyId TripleDESIsEncrypt:YES] forKey:@"keyid"];
    [paramDic setObject:[jsonString TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    
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


+ (void)composeTeacherHeadImg:(UIImage *)image userId:(NSString *)userId success:(void (^)(CRMHttpRespondModel *respond))success failure:(void (^)(NSError *))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    //创建上传参数
    MyUploadParam *uploadParam = [[MyUploadParam alloc] init];
    uploadParam.data = UIImageJPEGRepresentation(image, .5);
    uploadParam.name = @"pic";
    uploadParam.fileName = [NSString stringWithFormat:@"%@.jpg",userId];
    uploadParam.mimeType = @"image/png,image/jpeg,image/pjpeg";
    
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Action"] = [@"avatar" TripleDESIsEncrypt:YES];
    params[@"KeyId"] = [userId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params uploadParam:uploadParam success:^(id responseObject) {
        CRMHttpRespondModel *res = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        if (success) {
            success(res);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)deleteFriendWithDoctorId:(NSString *)doctorId introId:(NSString *)introId success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = @"http://122.114.62.57/his.crm/ashx/DoctorIntroducerMapHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[requestActionParam] = [@"delete" TripleDESIsEncrypt:YES];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    dataEntity[@"doctor_id"] = doctorId;
    dataEntity[@"intr_id"] = introId;
    params[@"DataEntity"] = [[dataEntity JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:[[XLAutoSyncTool shareInstance] addCommenParams:params] success:^(id responseObject) {
        
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorPatientMapHandler.ashx",DomainName,Method_Weixin,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    
    params[requestActionParam] = [@"getMessageItem" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[dataEntity JSONString] TripleDESIsEncrypt:YES];
    
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

+ (void)newYuYueMessagePatient:(NSString *)patientId fromDoctor:(NSString *)doctorId therapyDoctorId:(NSString *)therapyDoctorId withMessageType:(NSString *)message_type withSendType:(NSString *)send_type withSendTime:(NSString *)send_time success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
    //    NSString *urlStr = @"http://122.114.62.57/Weixin/ashx/DoctorPatientMapHandler.ashx";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorPatientMapHandler.ashx",DomainName,Method_Weixin,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:5];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:doctorId forKey:@"doctor_id"];
    [dataEntity setObject:message_type forKey:@"message_type"];
    [dataEntity setObject:send_type forKey:@"send_type"];
    [dataEntity setObject:send_time forKey:@"send_time"];
    [dataEntity setObject:therapyDoctorId forKey:@"therapy_doctor_id"];
    
    params[requestActionParam] = [@"newgetMessageItem" TripleDESIsEncrypt:YES];
    params[@"DataEntity"] = [[dataEntity JSONString] TripleDESIsEncrypt:YES];
    
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

    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"getintroducer" TripleDESIsEncrypt:YES];
    params[@"uid"] = [doctorId TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] GET:urlStr parameters:params success:^(id responseObject) {
        
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
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@/ashx/NotificationPatientHandler.ashx",DomainName,Method_His_Crm];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"transfer";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"add" TripleDESIsEncrypt:YES];

    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionaryWithCapacity:4];
    [dataEntity setObject:patientId forKey:@"patient_id"];
    [dataEntity setObject:receiverId forKey:@"doctor_id"];
    [dataEntity setObject:doctorId forKey:@"intr_id"];
    [dataEntity setObject:@"I" forKey:@"intr_source"];
    
    [params setObject:[[dataEntity JSONString] TripleDESIsEncrypt:YES] forKey:@"DataEntity"];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:[[XLAutoSyncTool shareInstance] addCommenParams:params] success:^(id responseObject) {
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorIntroducerMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"GetIntroducerByPage" TripleDESIsEncrypt:YES];
    params[@"uid"] = [doctorId TripleDESIsEncrypt:YES];
    params[@"sync_time"] = [sync_time TripleDESIsEncrypt:YES];
    params[@"query_info"] = [[info.keyValues JSONString] TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listpatientbyimplanttime" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    params[@"begin_date"] = [begin_date TripleDESIsEncrypt:YES];
    params[@"end_date"] = [end_date TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/PatientHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"listpatientbyrepairtime" TripleDESIsEncrypt:YES];
    params[@"doctor_id"] = [doctor_id TripleDESIsEncrypt:YES];
    params[@"begin_date"] = [begin_date TripleDESIsEncrypt:YES];
    params[@"end_date"] = [end_date TripleDESIsEncrypt:YES];
    params[@"repair_doctor_id"] = [repair_doctor_id TripleDESIsEncrypt:YES];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/CustomerFeedbackHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    dataEntity[@"doctor_id"] = doctor_id;
    dataEntity[@"content"] = content;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"Insert" TripleDESIsEncrypt:YES];
    param[@"DataEntity"] = [[dataEntity JSONString] TripleDESIsEncrypt:YES];
    
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

+ (void)getAllUsingHelpSuccess:(void(^)(NSArray *array))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/UsingHelpHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"listhelp" TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Result"]) {
            XLAssistenceModel *model = [XLAssistenceModel objectWithKeyValues:dic];
            [arrayM addObject:model];
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


/**
 *  查询所有的医嘱类型
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getMedicalAdviceTypeSuccess:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalAdviceTypeHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"listall" TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
    
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dic in respond.result) {
            XLAdviceTypeModel *model = [XLAdviceTypeModel objectWithKeyValues:dic];
            [mArray addObject:model];
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

/**
 *  查询指定类型下的所有医嘱
 *
 *  @param doctorId   医生id（必填）
 *  @param ckeyId     医嘱主键（选填）
 *  @param keyWord    关键字（选填）
 *  @param adviceId   医嘱的id（必填）
 *  @param adviceName 医嘱的名称（必填）
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getMedicalAdviceOfTypeByDoctorId:(NSString *)doctorId ckeyid:(NSString *)ckeyId keyWord:(NSString *)keyWord adviceId:(NSString *)adviceId adviceName:(NSString *)adviceName success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalAdviceHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"listbydoctorid" TripleDESIsEncrypt:YES];
    param[@"doctor_id"] = [doctorId TripleDESIsEncrypt:YES];
    param[@"ckeyid"] = [ckeyId TripleDESIsEncrypt:YES];
    param[@"key_word"] = [keyWord TripleDESIsEncrypt:YES];
    param[@"advice_id"] = [adviceId TripleDESIsEncrypt:YES];
    param[@"advice_name"] = [adviceName TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *mArray = [NSMutableArray array];
        for (NSDictionary *dic in respond.result) {
            XLAdviceDetailModel *model = [XLAdviceDetailModel objectWithKeyValues:dic];
            [mArray addObject:model];
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

/**
 *  新增一条医嘱
 *
 *  @param model   医嘱模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)addNewMedicalAdviceOfTypeByAdviceDetailModel:(XLAdviceDetailModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalAdviceHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    param[@"DataEntity"] = [[model.keyValues JSONString] TripleDESIsEncrypt:YES];
    
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

/**
 *  删除一条医嘱
 *
 *  @param ckeyId  医嘱id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)deleteMedicalAdviceOfTypeByCkeyId:(NSString *)ckeyId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalAdviceHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    param[@"ckeyid"] = [ckeyId TripleDESIsEncrypt:YES];
    
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


/**
 *  编辑一条医嘱
 *
 *  @param model   医嘱模型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)editMedicalAdviceOfTypeByAdviceDetailModel:(XLAdviceDetailModel *)model success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/MedicalAdviceHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"update" TripleDESIsEncrypt:YES];
    param[@"DataEntity"] = [[model.keyValues JSONString] TripleDESIsEncrypt:YES];
    
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

/**
 *  获取所有的患教信息
 *
 *  @param type    信息类型
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getPatientEducationWithType:(NSString *)type success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/UrlMapHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"listbytype" TripleDESIsEncrypt:YES];
    param[@"type"] = [@"patient_edu" TripleDESIsEncrypt:YES];
    
    
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in respond.result) {
            XLPatientEducationModel *model = [XLPatientEducationModel objectWithKeyValues:dic];
            [arrayM addObject:model];
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

/**
 *  模糊查询所有聊天记录
 *
 *  @param queryModel 查询模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getAllChatRecordWithChatQueryModel:(XLChatRecordQueryModel *)queryModel success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorChatRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"listbypage" TripleDESIsEncrypt:YES];
    param[@"QueryModel"] = [[queryModel.keyValues JSONString] TripleDESIsEncrypt:YES];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:param success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dic in respond.result) {
            XLChatModel *model = [XLChatModel objectWithKeyValues:dic];
            [arrayM addObject:model];
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

/**
 *  新增聊天记录
 *
 *  @param chatModel 聊天记录模型
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)addNewChatRecordWithChatModel:(XLChatModel *)chatModel success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorChatRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"add" TripleDESIsEncrypt:YES];
    param[@"DataEntity"] = [[chatModel.keyValues JSONString] TripleDESIsEncrypt:YES];
    
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

/**
 *  删除聊天记录
 *
 *  @param keyId      某个聊天记录主键（可不传）
 *  @param receiverId 接收者id（多个接收者，中间用“，”隔开）
 *  @param senderId   发送者id (多个发送者，中间用“，”隔开）
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)deleteChatRecordWithKeyId:(NSString *)keyId receiverId:(NSString *)receiverId senderId:(NSString *)senderId success:(void(^)(CRMHttpRespondModel *respond))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorChatRecordHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = [@"delete" TripleDESIsEncrypt:YES];
    param[@"keyid"] = [keyId TripleDESIsEncrypt:YES];
    param[@"receiver_id"] = [receiverId TripleDESIsEncrypt:YES];
    param[@"sender_id"] = [senderId TripleDESIsEncrypt:YES];
    
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


/**
 *  根据医生姓名查询医生
 *
 *  @param doctorName 医生姓名
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)searchDoctorWithDoctorName:(NSString *)doctorName success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure{
    
    if ([doctorName isEmpty]) {
        [SVProgressHUD showImage:nil status:@"医生姓名不能为空"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/DoctorInfoHandler.ashx",DomainName,Method_His_Crm,Method_Ashx];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[@"getdata" TripleDESIsEncrypt:YES] forKey:@"action"];
    [paramDic setObject:[doctorName TripleDESIsEncrypt:YES] forKey:@"username"];
    [paramDic setObject:[[AccountManager currentUserid] TripleDESIsEncrypt:YES] forKey:@"doctor_id"];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:paramDic success:^(id responseObject) {
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        
        if ([respond.code integerValue] == 200) {
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSDictionary *dic in respond.result) {
                Doctor *doctor = [Doctor DoctorFromDoctorResult:dic];
                [mArray addObject:doctor];
            }
            if (success) {
                success(mArray);
            }
        }else{
            if (success) {
                success(@[]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取患者或者医生的二维码
 *
 *  @param patientKeyId 患者的keyId
 *  @param isDoctor     是否是医生
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getQrCodeWithPatientKeyId:(NSString *)patientKeyId isDoctor:(BOOL)isDoctor success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[[AccountManager currentUserid] TripleDESIsEncrypt:YES] forKey:@"userId"];
    [paramDic setObject:[[AccountManager shareInstance].currentUser.accesstoken TripleDESIsEncrypt:YES] forKey:@"AccessToken"];
    if (!isDoctor) {
        [paramDic setObject:[patientKeyId TripleDESIsEncrypt:YES] forKey:@"pkeyId"];
    }
    NSString *urlStr = [EncryptionOpen isEqualToString:Auto_Action_Open] ? Qrcode_URL_Encrypt : Qrcode_URL;
    
    [[CRMHttpTool shareInstance] logWithUrlStr:urlStr params:paramDic];
    
    [[CRMHttpTool shareInstance] POST:urlStr parameters:paramDic success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end

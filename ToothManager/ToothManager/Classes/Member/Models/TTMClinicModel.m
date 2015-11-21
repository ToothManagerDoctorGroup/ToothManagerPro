//
//  TTMClinicModel.m
//  ToothManager
//

#import "TTMClinicModel.h"

#define kClinicFilePath [DocumentPath stringByAppendingPathComponent:@"clinic.data"]

@implementation TTMClinicModel
MJCodingImplementation

/**
 *  存入本地
 */
- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:kClinicFilePath];
}

+ (instancetype)unArchive {
    TTMClinicModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:kClinicFilePath];
    return model;
}

+ (void)initialize {
    if (self == [TTMClinicModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

+ (void)queryClinicDetailWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryClinicDetailURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMClinicModel *model = [TTMClinicModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryClinicQRCodeWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getCode" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryClinicDetailURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSDictionary *dict = @{@"imageURL": [DomainName stringByAppendingString:response.result]};
            complete(dict);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryClinicSummaryWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryClinicSummaryURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMClinicModel *model = [TTMClinicModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryClinicBankWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryClinicBankURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            if (rows.count > 0) {
                TTMClinicModel *model = [TTMClinicModel objectWithKeyValues:rows[0]];
                complete(model);
            } else {
                complete(nil);
            }
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryClinicAccountWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryClinicAccountURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMClinicModel *model = [TTMClinicModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)getCashWithMoney:(NSString *)money payPassword:(NSString *)payPassword complete:(CompleteBlock)complete {
    
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getCash" forKey:@"action"];
    [param setObject:payPassword forKey:@"paypassword"];
    [param setObject:money forKey:@"money"];
    
    [TTMNetwork getWithURL:AccountGetCashURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(nil);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)updateWithClinic:(TTMClinicModel *)clinic complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"edit" forKey:@"action"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:user.keyId forKey:@"clinicid"];
    
    // 传递参数
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    
    if (clinic.clinic_name) {
        [dataEntity setObject:clinic.clinic_name forKey:@"clinic_name"];
    }
    if (clinic.clinic_img) {
        [dataEntity setObject:clinic.clinic_img forKey:@"clinic_img"];
    }
    if (clinic.clinic_location) {
        [dataEntity setObject:clinic.clinic_location forKey:@"clinic_location"];
    }
    if (clinic.business_hours) {
        [dataEntity setObject:clinic.business_hours forKey:@"business_hours"];
    }
    if (clinic.clinic_phone) {
        [dataEntity setObject:clinic.clinic_phone forKey:@"clinic_phone"];
    }
    if (clinic.clinic_area) {
        [dataEntity setObject:clinic.clinic_area forKey:@"clinic_area"];
    }
    if (clinic.clinic_summary) {
        [dataEntity setObject:clinic.clinic_summary forKey:@"clinic_summary"];
    }
    
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [TTMNetwork getWithURL:QueryClinicDetailURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(nil);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)updateWithAddress:(NSString *)address complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"editClinicAddress" forKey:@"action"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:address forKey:@"address"];
    
    [TTMNetwork getWithURL:QueryClinicDetailURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(nil);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)editHeadImage:(UIImage *)headImage complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"editClinicImg" forKey:@"action"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:user.keyId forKey:@"clinicid"];

    
    THCUploadFormData *upload = [THCUploadFormData new];
    upload.data = UIImageJPEGRepresentation(headImage, 0.3f);
    NSString *filename = [[NSDate date] fs_stringWithFormat:@"yyyy-MM-dd-hh:mm:ss"];
    upload.filename = [filename stringByAppendingString:@".jpg"];
    upload.mimeType = @"image/jpeg";
    upload.name = @"img_info";
    NSArray *dataArray = @[upload];
    
    [TTMNetwork postDataWithURL:QueryClinicDetailURL
                         params:param
                  formDataArray:dataArray
                        success:^(id responseObject) {
                            TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
                            if (response.code == kSuccessCode) {
                                complete(nil);
                            } else {
                                complete(response.result);
                            }
                        } failure:^(NSError *error) {
                            complete(NetError);
                        }];
}
@end

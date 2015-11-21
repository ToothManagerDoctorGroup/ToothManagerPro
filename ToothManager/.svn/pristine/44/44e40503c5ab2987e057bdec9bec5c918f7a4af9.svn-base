//
//  TTMGTaskCellModel.m
//  ToothManager
//

#import "TTMGTaskCellModel.h"

@implementation TTMGTaskCellModel
+ (void)initialize {
    if (self == [TTMGTaskCellModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

+ (void)queryListWithStatus:(NSInteger)status complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    [param setObject:@(status) forKey:@"is_sign"];
    
    [TTMNetwork getWithURL:QueryGtaskListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMGTaskCellModel *model = [TTMGTaskCellModel objectWithKeyValues:dict];
                [mutArray addObject:model];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryDetailWithId:(NSInteger)ID complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    [param setObject:@(ID) forKeyedSubscript:@"Keyid"];
    
    [TTMNetwork getWithURL:QueryGtaskListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
//            NSArray *rows = response.result;
//            if (rows.count > 0) {
//                NSDictionary *dict = rows[0];
                TTMGTaskCellModel *model = [TTMGTaskCellModel objectWithKeyValues:response.result];
                complete(model);
//            } else {
//                complete(UnknownError);
//            }
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)agreeWithId:(NSInteger)ID complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"agree" forKey:@"action"];
    [param setObject:@(ID) forKeyedSubscript:@"Keyid"];
    
    [TTMNetwork getWithURL:ContractURL params:param success:^(id responseObject) {
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

+ (void)disagreeWithId:(NSInteger)ID complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"disagree" forKey:@"action"];
    [param setObject:@(ID) forKeyedSubscript:@"Keyid"];
    
    [TTMNetwork getWithURL:ContractURL params:param success:^(id responseObject) {
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

+ (void)queryDoctorListWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryDoctorListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMGTaskCellModel *model = [TTMGTaskCellModel objectWithKeyValues:dict];
                model.doctor_hospital = [model.doctor_phone copy];
                [mutArray addObject:model];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryDoctorDetailWithId:(NSInteger)ID complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    [param setObject:@(ID) forKeyedSubscript:@"doctorid"];
    
    [TTMNetwork getWithURL:QueryDoctorListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
//            NSArray *rows = response.result;
//            if (rows.count > 0 ) {
//                NSDictionary *dict = rows[0];
                TTMGTaskCellModel *model = [TTMGTaskCellModel objectWithKeyValues:response.result];
                complete(model);
//            } else {
//                complete(UnknownError);
//            }
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}
@end

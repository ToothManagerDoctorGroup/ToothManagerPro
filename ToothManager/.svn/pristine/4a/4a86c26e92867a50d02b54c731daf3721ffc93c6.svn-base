

#import "TTMBankModel.h"


@implementation TTMBankModel

+ (void)addBankWithModel:(TTMBankModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"add" forKey:@"action"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    [dataEntity setObject:model.bank_card forKey:@"bank_card"];
    [dataEntity setObject:model.cardholder forKey:@"cardholder"];
    [dataEntity setObject:model.bank_name forKey:@"bank_name"];
    [dataEntity setObject:model.subbranch_name forKey:@"subbranch_name"];
    [dataEntity setObject:@"1" forKey:@"is_main"];
    
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [TTMNetwork getWithURL:QueryClinicBankURL params:param success:^(id responseObject) {
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

+ (void)updateBankWithModel:(TTMBankModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"edit" forKey:@"action"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    [dataEntity setObject:model.bank_card forKey:@"bank_card"];
    [dataEntity setObject:model.cardholder forKey:@"cardholder"];
    [dataEntity setObject:model.bank_name forKey:@"bank_name"];
    [dataEntity setObject:model.subbranch_name forKey:@"subbranch_name"];
    [dataEntity setObject:@"1" forKey:@"is_main"];
    
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [TTMNetwork getWithURL:QueryClinicBankURL params:param success:^(id responseObject) {
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

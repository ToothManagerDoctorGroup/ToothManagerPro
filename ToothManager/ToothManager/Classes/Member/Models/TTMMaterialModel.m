

#import "TTMMaterialModel.h"

@implementation TTMMaterialModel

- (id)copyWithZone:(NSZone *)zone {
    TTMMaterialModel *model = [[[self class] allocWithZone:zone] init];
    model.KeyId = self.KeyId;
    model.actual_money = self.actual_money;
    model.actual_num = self.actual_num;
    model.mat_id = self.mat_id;
    model.mat_name = self.mat_name;
    model.mat_price = self.mat_price;
    model.price = self.price;
    model.number = self.number;
    model.countPrice = self.countPrice;
    return model;
}

+ (void)queryMaterialWithStatus:(NSUInteger)status complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:@(status) forKey:@"mat_type"];
    
    [TTMNetwork getWithURL:QueryMaterialListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *result = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            
            for (NSDictionary *dict in result) {
                TTMMaterialModel *model = [TTMMaterialModel objectWithKeyValues:dict];
                model.mat_id = model.KeyId;
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
@end

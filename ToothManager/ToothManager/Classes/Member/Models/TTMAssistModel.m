
#import "TTMAssistModel.h"

@implementation TTMAssistModel

+ (void)queryAssistListWithComplete:(CompleteBlock)complete {
    
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinicid"];
    
    [TTMNetwork getWithURL:QueryAssistListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *result = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                TTMAssistModel *model = [TTMAssistModel objectWithKeyValues:dict];
                model.assist_id = model.KeyId;
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

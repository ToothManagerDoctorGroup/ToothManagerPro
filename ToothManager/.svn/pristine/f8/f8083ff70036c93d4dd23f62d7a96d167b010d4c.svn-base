

#import "TTMWithdrawModel.h"

@implementation TTMWithdrawModel


+ (void)queryWithdrawRecordWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getDrawLog" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryWithdrawRecordListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMWithdrawModel *model = [TTMWithdrawModel objectWithKeyValues:dict];
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

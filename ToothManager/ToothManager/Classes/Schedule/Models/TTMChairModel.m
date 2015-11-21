//
//  TTMChairModel.m
//  ToothManager
//

#import "TTMChairModel.h"

@implementation TTMChairModel

+ (void)initialize {
    if (self == [TTMChairModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

+ (void)queryChairsWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    NSDictionary *param = @{@"action": @"getList",
                            @"clinicid": user.keyId,
                            @"accessToken": user.accessToken
                            };
    
    [TTMNetwork getWithURL:QueryScheduleChairListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMChairModel *model = [TTMChairModel objectWithKeyValues:dict];
                [mutArray addObject:model];
            }
            // 增加一个全部在第一位
            TTMChairModel *allModel = [[TTMChairModel alloc] init];
            allModel.seat_name = @"全部";
            [mutArray insertObject:allModel atIndex:0];
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryChairsForSettingWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    NSDictionary *param = @{@"action": @"getList",
                            @"clinicid": user.keyId,
                            @"accessToken": user.accessToken
                            };
    
    [TTMNetwork getWithURL:QueryScheduleChairListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMChairModel *model = [TTMChairModel objectWithKeyValues:dict];
                model.seat_name = [model.seat_name stringByAppendingString:@"椅位"];
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

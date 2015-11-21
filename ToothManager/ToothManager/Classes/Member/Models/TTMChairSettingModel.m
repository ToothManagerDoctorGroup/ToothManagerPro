
#import "TTMChairSettingModel.h"

@implementation TTMChairSettingModel

+ (void)queryDetailWithID:(NSString *)ID complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getDetailById" forKey:@"action"];
    [param setObject:ID forKey:@"seatid"];
    
    [TTMNetwork getWithURL:QueryScheduleChairListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMChairSettingModel *model = [TTMChairSettingModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)updateWithModel:(TTMChairSettingModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"edit" forKey:@"action"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    [dataEntity setObject:model.seat_id forKey:@"seat_id"];
    [dataEntity setObject:model.seat_brand forKey:@"seat_brand"];
    [dataEntity setObject:model.seat_desc forKey:@"seat_desc"];
    [dataEntity setObject:@(model.seat_tapwater) forKey:@"seat_tapwater"];
    [dataEntity setObject:@(model.seat_distillwater) forKey:@"seat_distillwater"];
    [dataEntity setObject:@(model.seat_ultrasound) forKey:@"seat_ultrasound"];
    [dataEntity setObject:@(model.seat_light) forKey:@"seat_light"];
    [dataEntity setObject:@(model.seat_price) forKey:@"seat_price"];
    [dataEntity setObject:@(model.assistant_price) forKey:@"assistant_price"];
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [TTMNetwork getWithURL:QueryScheduleChairListURL params:param success:^(id responseObject) {
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

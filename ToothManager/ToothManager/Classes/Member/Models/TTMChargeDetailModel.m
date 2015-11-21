
#import "TTMChargeDetailModel.h"
#import "TTMAssistModel.h"
#import "TTMMaterialModel.h"

@implementation TTMChargeDetailModel

+ (void)initialize {
    if (self == [TTMChargeDetailModel class]) {
        [self setupObjectClassInArray:^NSDictionary *{
            return @{@"assist_detail": @"TTMAssistModel",
                     @"material_detail": @"TTMMaterialModel",
                     @"extra_detail": @"TTMMaterialModel"};
        }];
    }
}

+ (void)queryChargeDetailWithAppointmentId:(NSString *)appointmentId
                                  complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getDetailCost" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:appointmentId forKey:@"appointmentid"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSDictionary *dict = response.result;
            TTMLog(@"%@", dict);
            TTMChargeDetailModel *model = [TTMChargeDetailModel objectWithKeyValues:dict];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}
@end

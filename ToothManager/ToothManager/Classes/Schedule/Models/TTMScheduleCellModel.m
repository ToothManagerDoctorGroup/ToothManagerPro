//
//  TTMScheduleCellModel.m
//  ToothManager
//

#import "TTMScheduleCellModel.h"
#import "TTMChairModel.h"
#import "TTMIncomeModel.h"

@implementation TTMScheduleCellModel

+ (void)initialize {
    if (self == [TTMScheduleCellModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
        
        [self setupObjectClassInArray:^NSDictionary *{
            return @{@"assists": @"TTMAssistModel",
                     @"materials": @"TTMMaterialModel"};
        }];
    }
}

+ (void)querySchedulesWithRequest:(TTMScheduleRequestModel *)request
                         complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    
    NSString *action = nil;
    if (request.controlType == TTMScheduleRequestModelControlTypeSchedule) {
        if ([request.chair.seat_name isEqualToString:@"全部"]) { // 查询全部
            if (request.date) {
                action = @"getListByDate";
                [param setObject:[request.date fs_stringWithFormat:@"yyyy-MM-dd"] forKey:@"cdate"];
            } else {
                action = @"getList";
            }
        } else {
            if (request.chair.seat_id) { // 按椅位和日期查询
                action = @"getListBySeatAndDate";
                [param setObject:(request.chair.seat_id ? request.chair.seat_id : @"") forKey:@"seatid"];
            } else { // 按日期查询
                action = @"getListByDate";
            }
            [param setObject:[request.date fs_stringWithFormat:@"yyyy-MM-dd"] forKey:@"cdate"];
        }
    } else if (request.controlType == TTMScheduleRequestModelControlTypeAppointment) {
        if (request.requestType == TTMScheduleRequestTypeStatus) {
            if (request.status == 2) { // 查询全部
                action = @"getList";
            } else if (request.status == 0 || request.status == 1) {
                action = @"getListByStatus";
                [param setObject:@(request.status) forKey:@"status"];
            }
        } else if(request.requestType == TTMScheduleRequestTypeChair) {
            if ([request.chair.seat_name isEqualToString:@"全部"]) { // 查询全部
                action = @"getList";
            } else {
                action = @"getListBySeat";
                [param setObject:(request.chair.seat_id ? request.chair.seat_id : @"")  forKey:@"seatid"];
            }
        }
    }
    if (action) {
        [param setObject:action forKey:@"action"];
    }
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMScheduleCellModel *model = [TTMScheduleCellModel objectWithKeyValues:dict];
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

+ (void)queryScheduleDetailWithId:(NSInteger)appointId complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getalldetail" forKey:@"action"];
    [param setObject:@(appointId) forKey:@"Keyid"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMScheduleCellModel *model = [TTMScheduleCellModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryScheduleOtherDetailWithId:(NSInteger)appointId complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetail" forKey:@"action"];
    [param setObject:@(appointId) forKey:@"Keyid"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMScheduleCellModel *model = [TTMScheduleCellModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryScheduleDetailWithAppointId:(NSString *)appointId complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getdetailbyaid" forKey:@"action"];
    [param setObject:appointId forKey:@"aid"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMScheduleCellModel *model = [TTMScheduleCellModel objectWithKeyValues:response.result];
            complete(model);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

- (TTMIncomeModel *)incomeModelAdapter {
    TTMIncomeModel *incomeModel = [[TTMIncomeModel alloc] init];
    incomeModel.keyId = _keyId;
    incomeModel.time = _appoint_time;
    incomeModel.person = _seat_name;
    incomeModel.mony = _doctor_name;
    incomeModel.appoint_type = _appoint_type;
    incomeModel.isAppointment = YES;
    return incomeModel;
}

@end

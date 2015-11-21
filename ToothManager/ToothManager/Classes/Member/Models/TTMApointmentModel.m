

#import "TTMApointmentModel.h"
#import "TTMChairModel.h"
#import "TTMChargeDetailModel.h"
#import "TTMAssistModel.h"
#import "TTMMaterialModel.h"

@implementation TTMApointmentModel

+ (void)queryCompleteAppointmentComplete:(CompleteBlock)complete {
    
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getListByStatus" forKey:@"action"];
    [param setObject:@"1" forKey:@"status"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMApointmentModel *model = [TTMApointmentModel objectWithKeyValues:dict];
                [mutArray addObject:model];
            }
            
            NSMutableArray *tempArray = [NSMutableArray array];
            NSEnumerator *enumerator = [mutArray reverseObjectEnumerator];
            TTMApointmentModel *tempModel = nil;
            while (tempModel = [enumerator nextObject]) {
                [tempArray addObject:tempModel];
            }
            complete(tempArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}


+ (void)queryAppointmentListWithTimeType:(NSUInteger)timeType
                                complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getListByPeriod" forKey:@"action"];
    [param setObject:@(timeType) forKey:@"period"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMApointmentModel *model = [TTMApointmentModel objectWithKeyValues:dict];
                model.used_time = [model.used_time hourMinutesTimeFormat];
                [mutArray addObject:model];
            }
            
            NSMutableArray *tempArray = [NSMutableArray array];
            NSEnumerator *enumerator = [mutArray reverseObjectEnumerator];
            TTMApointmentModel *tempModel = nil;
            while (tempModel = [enumerator nextObject]) {
                [tempArray addObject:tempModel];
            }
            complete(tempArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)startTimeWithModel:(TTMApointmentModel *)model
                  complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"startTiming" forKey:@"action"];
    [param setObject:@(model.KeyId) forKey:@"appointmentid"];
    [param setObject:[[NSDate date] fs_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"starttime"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
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

+ (void)endTimeWithModel:(TTMApointmentModel *)model
                complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"endTiming" forKey:@"action"];
    [param setObject:@(model.KeyId) forKey:@"appointmentid"];
    [param setObject:[[NSDate date] fs_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"endtime"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
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

+ (void)editPayDetailWithModel:(TTMChargeDetailModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"editDetailCost" forKey:@"action"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    
    [dataEntity setObject:@(model.KeyId) forKey:@"KeyId"];
    [dataEntity setObject:model.seat_price forKey:@"seat_price"];
    [dataEntity setObject:model.seat_money forKey:@"seat_money"];
    [dataEntity setObject:model.assistant_money forKey:@"assistant_money"];
    [dataEntity setObject:model.material_money forKey:@"material_money"];
    [dataEntity setObject:model.extra_money forKey:@"extra_money"];
    [dataEntity setObject:model.appoint_money forKey:@"appoint_money"];
    
    if (model.assist_detail.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TTMAssistModel *m in model.assist_detail) {
            // 判断有没有值，表示有没有对查出来的数据改变过
            if (m.number) {
                m.actual_num = [NSString stringwithNumber:@(m.number)];
            }
            if (m.assist_price) {
                m.price = m.assist_price;
            }
            if (m.countPrice) {
                m.actual_money = m.countPrice;
            }
            NSDictionary *dict = @{@"KeyId": @(model.KeyId),
                                   @"assist_id": m.assist_id,
                                   @"assist_name": m.assist_name,
                                   @"actual_num": m.actual_num,
                                   @"price": m.price,
                                   @"actual_money": m.actual_money};
            [temp addObject:dict];
        }
        [dataEntity setObject:temp forKey:@"assist_detail"];
    }
    
    if (model.material_detail.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TTMMaterialModel *m in model.material_detail) {
            if (m.number) {
                m.actual_num = [NSString stringwithNumber:@(m.number)];
            }
            if (m.mat_price) {
                m.price = m.mat_price;
            }
            if (m.countPrice) {
                m.actual_money = m.countPrice;
            }
            NSDictionary *dict = @{@"KeyId": @(model.KeyId),
                                   @"mat_id": m.mat_id,
                                   @"mat_name": m.mat_name,
                                   @"actual_num": m.actual_num,
                                   @"price": m.price,
                                   @"actual_money": m.actual_money};
            [temp addObject:dict];
        }
        [dataEntity setObject:temp forKey:@"material_detail"];
    }
    if (model.extra_detail.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TTMMaterialModel *m in model.extra_detail) {
            if (m.number) {
                m.actual_num = [NSString stringwithNumber:@(m.number)];
            }
            if (m.mat_price) {
                m.price = m.mat_price;
            }
            if (m.countPrice) {
                m.actual_money = m.countPrice;
            }
            NSDictionary *dict = @{@"KeyId": @(model.KeyId),
                                   @"mat_id": m.mat_id,
                                   @"mat_name": m.mat_name,
//                                   @"actual_num": m.actual_num,
                                   @"price": m.price,
                                   @"actual_money": m.actual_money};
            [temp addObject:dict];
        }
        [dataEntity setObject:temp forKey:@"extra_detail"];
    } else {
        [dataEntity setObject:[NSArray array] forKey:@"extra_detail"];
    }
    
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    [TTMNetwork getWithURL:QueryScheduleListURL params:param success:^(id responseObject) {
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

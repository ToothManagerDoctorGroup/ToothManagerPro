

#import "TTMRealisticModel.h"

@implementation TTMRealisticModel

+ (void)queryImagesWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryRealisticlURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *tempArray = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in tempArray) {
                TTMRealisticModel *model = [TTMRealisticModel objectWithKeyValues:dict];
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

+ (void)deleteImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"delete" forKey:@"action"];
    [param setObject:@(model.KeyId) forKey:@"Keyid"];
    
    [TTMNetwork getWithURL:QueryRealisticlURL params:param success:^(id responseObject) {
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

+ (void)addImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"add" forKey:@"action"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    if (model.remark) {
        [dataEntity setObject:model.remark forKey:@"remark"];
    }
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    THCUploadFormData *upload = [THCUploadFormData new];
    upload.data = UIImageJPEGRepresentation(model.uploadImage, 0.5f);
    NSString *filename = [[NSDate date] fs_stringWithFormat:@"yyyy-MM-dd-hh:mm:ss"];
    upload.filename = [filename stringByAppendingString:@".jpg"];
    upload.mimeType = @"image/jpeg";
    upload.name = @"img_info";
    NSArray *dataArray = @[upload];
    
    [TTMNetwork postDataWithURL:QueryRealisticlURL
                         params:param
                  formDataArray:dataArray
                        success:^(id responseObject) {
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

+ (void)queryImagesWithSeatId:(NSString *)seatId complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getList" forKey:@"action"];
    [param setObject:seatId forKey:@"seatid"];
    
    [TTMNetwork getWithURL:QueryScheduleChairImageListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *tempArray = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in tempArray) {
                TTMRealisticModel *model = [TTMRealisticModel objectWithKeyValues:dict];
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

+ (void)addChairImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"add" forKey:@"action"];
    [param setObject:model.seat_id forKey:@"seatid"];
    
    NSMutableDictionary *dataEntity = [NSMutableDictionary dictionary];
    if (model.remark) {
        [dataEntity setObject:model.remark forKey:@"remark"];
    }
    [param setObject:[dataEntity JSONString] forKey:@"DataEntity"];
    
    THCUploadFormData *upload = [THCUploadFormData new];
    upload.data = UIImageJPEGRepresentation(model.uploadImage, 0.5f);
    NSString *filename = [[NSDate date] fs_stringWithFormat:@"yyyy-MM-dd-hh:mm:ss"];
    upload.filename = [filename stringByAppendingString:@".jpg"];
    upload.mimeType = @"image/jpeg";
    upload.name = @"img_info";
    NSArray *dataArray = @[upload];
    
    [TTMNetwork postDataWithURL:QueryScheduleChairImageListURL
                         params:param
                  formDataArray:dataArray
                        success:^(id responseObject) {
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

+ (void)deleteChairImageWithModel:(TTMRealisticModel *)model complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"delete" forKey:@"action"];
    [param setObject:model.seat_id forKey:@"seatid"];
    [param setObject:@(model.KeyId) forKey:@"Keyid"];
    
    [TTMNetwork getWithURL:QueryScheduleChairImageListURL params:param success:^(id responseObject) {
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

//
//  TTMMessageCellModel.m
//  ToothManager
//

#import "TTMMessageCellModel.h"

@implementation TTMMessageCellModel

+ (void)initialize {
    if (self == [TTMMessageCellModel class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

+ (void)queryMessageListWithStatus:(TTMMessageStatusType)status Complete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getListByStatus" forKey:@"action"];
    [param setObject:@(status) forKey:@"status"];
    
    [TTMNetwork getWithURL:QueryMessageListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            
            NSArray *resultArray = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in resultArray) {
                TTMMessageCellModel *messageModel = [TTMMessageCellModel objectWithKeyValues:dict];
                messageModel.isAppointment = YES;
                [mutArray addObject:messageModel];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)queryNotReadCountWithComplete:(CompleteBlock)complete {
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.keyId forKey:@"clinicid"];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"getcount" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryMessageListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(response.result);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)changeNotReadMessageWithId:(NSInteger)messageId complete:(CompleteBlock)complete {
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(messageId) forKey:@"keyId"];
    [param setObject:@"getdealmessage" forKey:@"action"];
    
    [TTMNetwork getWithURL:QueryMessageListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(response.result);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}
@end

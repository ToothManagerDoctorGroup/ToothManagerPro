//
//  TTMUser.m
//  ToothManager
//

#import "TTMUser.h"

#define kUserFilePath [DocumentPath stringByAppendingPathComponent:@"user.data"]

@implementation TTMUser
MJCodingImplementation

+ (void)initialize {
    if (self == [TTMUser class]) {
        [self setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"keyId": @"KeyId"};
        }];
    }
}

- (void)archiveUser {
    [NSKeyedArchiver archiveRootObject:self toFile:kUserFilePath];
}

+ (TTMUser *)unArchiveUser {
    TTMUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserFilePath];
    return user;
}

+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                 Complete:(CompleteBlock)complete {
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSDictionary *param = @{@"action": @"login",
                            @"username": userName,
                            @"password": password,
                            @"devicetoken": deviceToken ? deviceToken : @"",
                            @"devicetype": @"ios"};
    
    [TTMNetwork getWithURL:UserURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSDictionary *result = response.result;
            TTMUser *user = [TTMUser objectWithKeyValues:result];
            user.accessToken = user.accessToken ? user.accessToken : @"";
            user.password = password;
            [user archiveUser];
            complete(nil);
        } else {
            if (response.result == nil) {
                complete(UnknownError);
            } else {
                complete(response.result);
            }
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)updatePassword:(NSString *)passOld
                   new:(NSString *)passNew
              Complete:(CompleteBlock)complete {
    NSDictionary *param = @{@"action": @"editPassword",
                            @"old": passOld,
                            @"new": passNew,
                            @"keyid": [TTMUser unArchiveUser].keyId};
    [TTMNetwork getWithURL:UserURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            TTMUser *user = [TTMUser unArchiveUser];
            user.password = passNew;
            [user archiveUser];
            complete(nil);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

+ (void)updatePayPassword:(NSString *)passOld
                 Complete:(CompleteBlock)complete {
    NSDictionary *param = @{@"action": @"editPasswordStep1",
                            @"old": passOld,
                            @"keyid": [TTMUser unArchiveUser].keyId};
    [TTMNetwork getWithURL:UpdatePayPasswordURL params:param success:^(id responseObject) {
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

+ (void)updatePayPasswordNew:(NSString *)passNew
                    Complete:(CompleteBlock)complete {
    NSDictionary *param = @{@"action": @"editPasswordStep2",
                            @"new": passNew,
                            @"keyid": [TTMUser unArchiveUser].keyId};
    [TTMNetwork getWithURL:UpdatePayPasswordURL params:param success:^(id responseObject) {
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


+ (void)sendValidateCodeWithMobile:(NSString *)mobile Complete:(CompleteBlock)complete {
    NSDictionary *param = @{@"action": @"getvalidatecode",
                            @"mobile": mobile};
    [TTMNetwork getWithURL:UserURL params:param success:^(id responseObject) {
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

+ (void)forgetPasswordWithMobile:(NSString *)mobile
                    validatecode:(NSString *)validatecode
                         passNew:(NSString *)passNew
                        Complete:(CompleteBlock)complete {
    NSDictionary *param = @{@"action": @"forgetpass",
                            @"mobile": mobile,
                            @"validatecode": validatecode,
                            @"new": passNew};
    [TTMNetwork getWithURL:UserURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            complete(nil);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(nil);
    }];
}
@end

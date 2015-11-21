//
//  THCNetwork.m
//  THCFramework
//
//  Created by Jeffery He on 15/2/11.
//  Copyright (c) 2015年 Jeffery He All rights reserved.
//

#import "TTMNetwork.h"
#import "AFNetworking.h"

@implementation TTMNetwork

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer.timeoutInterval = 30.f; // 请求超时
    [requestManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)headWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager HEAD:url parameters:params success:^(AFHTTPRequestOperation *operation) {
        if (success) {
            success(operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer.timeoutInterval = 30.f; // 请求超时
    [requestManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postDataWithURL:(NSString *)url params:(NSDictionary *)params
                                 formDataArray:(NSArray *)formDataArray
                                       success:(Success)success
                                       failure:(Failure)failure {
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 拼接上传的数据
        for (THCUploadFormData *uploadFormData in formDataArray) {
            [formData appendPartWithFileData:uploadFormData.data
                                        name:uploadFormData.name
                                    fileName:uploadFormData.filename
                                    mimeType:uploadFormData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)putWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)patchWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteWithURL:(NSString *)url params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

@implementation THCUploadFormData
@end

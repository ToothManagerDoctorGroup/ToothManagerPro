//
//  TimRequest.m
//  CRM
//
//  Created by TimTiger on 5/8/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimRequestBase.h"
#import "AccountManager.h"
#import "CRMUserDefalut.h"
#import "NSString+TTMAddtion.h"

@implementation ResponderObject

@end

@implementation TimRequestParam
+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params {
    TimRequestParam *reqParam = [[TimRequestParam alloc]init];
    reqParam.params = [NSMutableDictionary dictionaryWithDictionary:params];
    //所有接口添加 userid 和 accesstoken参数
    if ([[AccountManager shareInstance] isLogin]) {
       // [reqParam.params setObject:[AccountManager shareInstance].currentUser.accesstoken forKey:@"Accesstoken"];
        if ([reqParam.params objectForKey:@"userid"] == nil && [reqParam.params objectForKey:@"userId"] == nil)
        [reqParam.params setObject:[[AccountManager shareInstance].currentUser.userid TripleDESIsEncrypt:YES] forKey:@"userid"];
    }
    [reqParam.params setObject:[@"ios" TripleDESIsEncrypt:YES] forKey:@"devicetype"];
    if ([CRMUserDefalut objectForKey:DeviceToken]) {
        [reqParam.params setObject:[[CRMUserDefalut objectForKey:DeviceToken] TripleDESIsEncrypt:YES] forKey:@"devicetoken"];
    }
    reqParam.requestUrl = requestUrl;
    reqParam.method = RequestMethodPOST;
    reqParam.retryTimes = 1;
    reqParam.timeoutInterval = 20;
    reqParam.retryInterval = 2;
    return reqParam;
}
+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params
                            withPrefix:(NSString *)prefix {
    TimRequestParam *reqParam = [TimRequestParam paramWithURLSting:requestUrl andParams:params];
    
    reqParam.callbackPrefix = prefix;
    return reqParam;
}

+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params
                        additionParams:(NSDictionary *)otherPararms withPrefix:(NSString *)prefix {
    TimRequestParam *reqParam = [TimRequestParam paramWithURLSting:requestUrl andParams:params withPrefix:prefix];
    reqParam.additionalParams = otherPararms;
    return reqParam;
}
@end

@implementation TimRequestBase

- (id)init {
    self = [super init];
    if (self) {
        _responders = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

//添加 网络回调响应者
- (void)addResponder:(id)responder {
    @synchronized(_responders) {
        for (ResponderObject *obj in _responders) {
            if (obj.object == responder) {
                return;
            }
        }
        ResponderObject *responderObj = [[ResponderObject alloc]init];
        responderObj.object = responder;
        [_responders addObject:responderObj];
    }
}

//移除 网络回调响应者
- (void)removeResponder:(id)responder{
    @synchronized(_responders) {
        for (ResponderObject *obj in _responders) {
            if (obj.object == responder) {
                [_responders removeObject:obj];
                break;
            }
        }
    }
}

- (void)removeAllResponder {
    @synchronized(_responders) {
        [_responders removeAllObjects];
    }
}

@end

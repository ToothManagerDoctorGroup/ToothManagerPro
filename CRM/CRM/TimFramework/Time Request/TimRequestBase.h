//
//  TimRequest.h
//  CRM
//
//  Created by TimTiger on 5/8/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET = 1,
    RequestMethodPOST = 2,
    RequestMethodPUT = 3,
};

@interface TimRequestParam : NSObject

@property (nonatomic,copy) NSString *requestUrl;
@property (nonatomic,copy) NSString *callbackPrefix;
@property (nonatomic,retain) NSMutableDictionary *params;  //参数
@property (nonatomic,retain) NSDictionary *additionalParams;  //附加参数（上传图片，上传文字）
@property (nonatomic,readwrite) NSInteger retryTimes;     // 剩余重试次数
@property (nonatomic,readwrite) NSInteger retryInterval;   // 重试间隔
@property (nonatomic,readwrite) NSInteger timeoutInterval;
@property (nonatomic,readwrite) RequestMethod method;  //请求方式，GET或者POST

+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params;

+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params withPrefix:(NSString *)prefix;

+ (TimRequestParam *)paramWithURLSting:(NSString *)requestUrl andParams:(NSDictionary *)params additionParams:(NSDictionary *)otherPararms withPrefix:(NSString *)prefix;

@end

/**
 *  响应对象
 */
@interface ResponderObject : NSObject
@property (nonatomic,weak) id object;
@end

/**
 *  基本网络请求对象
 */
@interface TimRequestBase : NSObject
/**
 *  网络对象的所有响应者
 */
@property (nonatomic,readonly)  NSMutableArray *responders;
/**
 *  基础的URL
 */
@property (nonatomic,copy) NSURL *BaseURL;

//添加、移除 网络回调响应者
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponder;

@end

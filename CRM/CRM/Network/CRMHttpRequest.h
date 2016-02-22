//
//  TimRequest.h
//  CRM
//
//  Created by TimTiger on 5/14/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimRequestHeader.h"
#import "CommonMacro.h"

@class AFHTTPRequestOperation;
@interface CRMHttpRequest : TimRequestBase
{
    
}
@property (nonatomic,readonly) TimRequest *responderManager;

Declare_ShareInstance(CRMHttpRequest);

/*
 *@brief 发起一个网络请求 默认POST方式
 *@param params 请求参数
 */
- (void)requestWithParams:(TimRequestParam *)params;

/*
 *@brief 发起一个网络请求 默认POST方式
 *@param params 请求参数
 */
- (AFHTTPRequestOperation *)requestResultWithParams:(TimRequestParam *)params;

/*
 *@brief 发起一个网络请求
 *@param params 请求参数
 *@param method 请求方式
 */
- (void)requestWithParams:(TimRequestParam *)params withMethod:(RequestMethod)method;

/**
 *  通知所有网络响应者
 *
 *  @param selector 要执行的方法
 *  @param object1  参数
 *  @param object2  参数
 */
- (void)responderPerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2;

/**
 *  取消所有网络请求
 */
- (void)cancelAllOperations;



@property (nonatomic, assign)BOOL isAutoSync;//是否是自动同步

@end

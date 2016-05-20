//
//  XLPayManager.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//


#import "CommonMacro.h"
#import <Foundation/Foundation.h>

@class XLPayParam;
@interface XLPayManager : NSObject
Declare_ShareInstance(XLPayManager);

/**
 *  微信支付（所有参数由客户端生成）
 *
 *  @param param 支付param
 */
- (void)payWithParam:(XLPayParam *)param;

/**
 *  微信支付 （所有参数由服务器生成）
 *
 *  @param param 服务器返回的字典
 */
- (void)payWithDic:(NSDictionary *)dic;

@end

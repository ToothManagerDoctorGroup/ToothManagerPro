//
//  XLPayTool.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPayUtils : NSObject

///产生随机字符串
+ (NSString *)generateTradeNO;
//将订单号使用md5加密
+ (NSString *) md5:(NSString *)str;
//产生随机数
+ (NSString *)getOrderNumber;
//获取设备的ip
+(NSString *)getIPAddress;

@end

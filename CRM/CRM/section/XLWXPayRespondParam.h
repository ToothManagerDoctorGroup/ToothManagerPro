//
//  XLPayRespondParam.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  商户系统先调用该接口在微信支付服务后台生成预支付交易单，返回正确的预支付交易回话标识后再在APP里面调起支付。
 */
@interface XLWXPayRespondParam : NSObject
/**
 *  应用APPID
 */
@property (nonatomic, copy)NSString *appid;
/**
 *  商户号
 */
@property (nonatomic, copy)NSString *mch_id;
/**
 *  设备号
 */
@property (nonatomic, copy)NSString *device_info;
/**
 *  随机字符串
 */
@property (nonatomic, copy)NSString *nonce_str;
/**
 *  签名
 */
@property (nonatomic, copy)NSString *sign;
/**
 *  业务结果
 */
@property (nonatomic, copy)NSString *result_code;
/**
 *  错误代码
 */
@property (nonatomic, copy)NSString *err_code;
/**
 *  错误代码描述
 */
@property (nonatomic, copy)NSString *err_code_des;
/**
 *  交易类型
 */
@property (nonatomic, copy)NSString *trade_type;
/**
 *  预支付交易会话标识
 */
@property (nonatomic, copy)NSString *prepay_id;

@end

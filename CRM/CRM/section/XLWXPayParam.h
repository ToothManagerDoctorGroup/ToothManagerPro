//
//  XLPayParam.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLWXPayParam : NSObject

/**
 *  应用的AppId
 */
@property (nonatomic, copy)NSString *appid;
/**
 *  微信支付商户号
 */
@property (nonatomic, copy)NSString *mch_id;
/**
 *  产生随机字符串，用于校验
 */
@property (nonatomic, copy)NSString *nonce_str;
/**
 *  sign签名，用于支付校验
 */
@property (nonatomic, copy)NSString *sign;
/**
 *  商品描述
 */
@property (nonatomic, copy)NSString *body;
/**
 *  商品订单号，一般由服务器生成
 */
@property (nonatomic, copy)NSString *out_trade_no;
/**
 *  本单交易的价格
 */
@property (nonatomic, copy)NSString *total_fee;
/**
 *  获取当前手机的ip地址
 */
@property (nonatomic, copy)NSString *spbill_create_ip;
/**
 *  交易结果通知网站
 */
@property (nonatomic, copy)NSString *notify_url;
/**
 *  调用类型（网站调用，或者app调用）
 */
@property (nonatomic, copy)NSString *trade_type;
/**
 *  商户支付密钥
 */
@property (nonatomic, copy)NSString *partner;

/**
 *  初始化(用于客户端生成相关参数)
 *
 *  @param nonce_str    产生随机字符串，用于校验
 *  @param sign         sign签名，用于支付校验
 *  @param body         商品描述
 *  @param out_trade_no 商品订单号，一般由服务器生成
 *  @param total_fee    本单交易的价格
 *  @param notify_url   交易结果通知网站
 *
 *  @return self
 */
- (instancetype)initWithNonceStr:(NSString *)nonce_str
                            body:(NSString *)body
                      outTradeNo:(NSString *)out_trade_no
                        totalFee:(NSString *)total_fee
                       notifyUrl:(NSString *)notify_url;

///获取MD5签名
- (NSString *)getSignForMD5;
///创建发起支付时的sige签名
- (NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key;
//获取XML格式字符串
- (NSString *)xmlStr;
@end

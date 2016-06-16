//
//  XLPayParam.m
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLWXPayParam.h"
#import "XMLDictionary.h"
#import "XLPayUtils.h"
#import <CommonCrypto/CommonDigest.h>

#define kPayParamAppId @"wx43875d1f976c1ded"
#define kPayParamMchId @""
#define kPayParamPartner @"4483e96ed4a22d82ac4cc98bee072f3c"

@implementation XLWXPayParam

- (instancetype)initWithNonceStr:(NSString *)nonce_str
                            body:(NSString *)body
                      outTradeNo:(NSString *)out_trade_no
                        totalFee:(NSString *)total_fee
                       notifyUrl:(NSString *)notify_url{
    if (self = [super init]) {
        _appid = kPayParamAppId;
        _mch_id = kPayParamMchId;
        _spbill_create_ip = [XLPayUtils getIPAddress];
        _partner = kPayParamPartner;
        _nonce_str = nonce_str;
        _body = body;
        _out_trade_no = out_trade_no;
        _total_fee = total_fee;
        _notify_url = notify_url;
        _trade_type = @"APP";
        
        //设置sign
        _sign = [self getSignForMD5];
    }
    return self;
}

///获取MD5签名
- (NSString *)getSignForMD5{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_appid forKey:@"appid"];
    [dic setValue:_mch_id forKey:@"mch_id"];
    [dic setValue:_nonce_str forKey:@"nonce_str"];
    [dic setValue:_body forKey:@"body"];
    [dic setValue:_out_trade_no forKey:@"out_trade_no"];
    [dic setValue:_total_fee forKey:@"total_fee"];
    [dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];
    [dic setValue:_notify_url forKey:@"notify_url"];
    [dic setValue:_trade_type forKey:@"trade_type"];
    return [self createMd5Sign:dic];
}

//创建签名
- (NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@", _partner];
    //得到MD5 sign签名
    NSString *md5Sign =[XLPayUtils md5:contentString];
    
    return md5Sign;
}

///创建发起支付时的sige签名
- (NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    //[contentString appendFormat:@"key=%@", @"此处填入商家密钥"];
    [contentString appendFormat:@"key=%@",@""];
    //    NSString *signString =[self md5:contentString];
    NSString *result = [XLPayUtils md5:contentString];
    return result;
}


- (NSString *)xmlStr{
    //设置参数并转化成xml格式
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_appid forKey:@"appid"];//公众账号ID
    [dic setValue:_mch_id forKey:@"mch_id"];//商户号
    [dic setValue:_nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:_sign forKey:@"sign"];//签名
    [dic setValue:_body forKey:@"body"];//商品描述
    [dic setValue:_out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:_total_fee forKey:@"total_fee"];//金额
    [dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:_notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:_trade_type forKey:@"trade_type"];//交易类型
    return [dic XMLString];
}

@end

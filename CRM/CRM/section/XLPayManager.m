//
//  XLPayManager.m
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPayManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "WXApi.h"
#import "XMLDictionary.h"
#import "XLPayUtils.h"
#import "XLWXPayParam.h"
#import "XLAlipayOrder.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation XLPayManager
Realize_ShareInstance(XLPayManager);

#pragma mark - ********************* 微信支付 ***********************
/**
 *  微信支付（所有参数由客户端）
 *
 *  @param param 支付param
 */
- (void)wxPayWithParam:(XLWXPayParam *)param{
    //将param转换成XML格式字符串
    [self wxPayWithXML:[param xmlStr]];
}

/**
 *  微信支付 （所有参数由服务器生成）
 *
 *  @param param 支付param
 */
- (void)wxPayWithDic:(NSDictionary *)dic{
    //发起微信支付，设置参数
    PayReq *request = [[PayReq alloc] init];
    request.openID = [dic objectForKey:@"appid"];
    request.partnerId = [dic objectForKey:@"partnerid"];
    request.prepayId= [dic objectForKey:@"prepayid"];
    request.package = [dic objectForKey:@"package"];
    request.nonceStr= [dic objectForKey:@"noncestr"];
    //将当前时间转化成时间戳
//    NSDate *datenow = [NSDate date];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[dic[@"timestamp"] intValue];
    request.timeStamp= timeStamp;
    request.sign= [dic objectForKey:@"sign"];
    //调用微信
    [WXApi sendReq:request];
}

- (void)wxPayWithXML:(NSString *)xmlStr{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xmlStr;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xmlStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.openID = [dic objectForKey:@"open_id"];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            XLWXPayParam *param = [[XLWXPayParam alloc] init];
            request.sign=[param createMD5SingForPay:@"wx43875d1f976c1ded" partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            //调用微信
            [WXApi sendReq:request];
        }else{
            NSLog(@"参数不正确，请检查参数");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

#pragma mark - ********************* 支付宝支付 ***********************
/**
 *  支付宝支付
 *
 *  @param dic 服务器返回的字典
 */
- (void)aliPayWithOrderString:(NSString *)orderString payCallback:(void(^)(NSDictionary *dic))payCallBack{
    NSString *appScheme = @"alipaycomtrasendevCRM";
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if (payCallBack) {
            payCallBack(resultDic);
        }
    }];
}

@end

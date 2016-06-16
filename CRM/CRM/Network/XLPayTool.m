//
//  XLPayTool.m
//  CRM
//
//  Created by Argo Zhang on 16/5/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPayTool.h"
#import "XLPayUtils.h"
#import "CRMHttpTool.h"
#import "NSString+TTMAddtion.h"
#import "JSONKit.h"
#import "CRMHttpRespondModel.h"
#import "CRMUnEncryptedHttpTool.h"
#import "XLWXPayRespondParam.h"

@implementation XLPayTool

/**
 *  支付
 *
 *  @param orderParam 订单模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)payWithOrderParam:(XLOrderParam *)orderParam success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure{
     NSString *urlStr = [NSString stringWithFormat:@"%@%@/WxPayHandler.ashx",DomainName,Method_Ashx];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = [@"GetAppPayModel" TripleDESIsEncrypt:YES];
    params[@"order"] = [[orderParam.keyValues JSONString] TripleDESIsEncrypt:YES];
    [[CRMHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"支付订单信息%@",dic);
        if (success) {
            success(dic);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  支付宝支付
 *
 *  @param subject  商品名称
 *  @param body     商品描述
 *  @param totalFee 总价格
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)alipayWithSubject:(NSString *)subject body:(NSString *)body totalFee:(NSString *)totalFee billId:(NSString *)billId billType:(NSString *)billType success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/AliPayHandler.ashx",DomainName,@"ashx"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"mobilepay";
    params[@"subject"] = subject;
    params[@"body"] = body;
    params[@"total_fee"] = totalFee;
    params[@"bill_id"] = billId;
    params[@"bill_type"] = billType;
    
    [[CRMUnEncryptedHttpTool shareInstance] POST:urlStr parameters:params success:^(id responseObject) {
        
        CRMHttpRespondModel *respond = [CRMHttpRespondModel objectWithKeyValues:responseObject];
        
        if (success) {
            success(respond);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end


@implementation XLOrderParam

- (instancetype)initWithBody:(NSString *)body
                      detail:(NSString *)detail
                      attach:(NSString *)attach
                    totalFee:(NSString *)totalFee
                    goodsTag:(NSString *)goodsTag{
    if (self = [super init]) {
        self.body = body;
        self.detail = detail;
        self.attach = attach;
        self.total_fee = totalFee;
        self.goods_tag = goodsTag;
        self.spbill_create_ip = [XLPayUtils getIPAddress];
    }
    return self;
}

@end
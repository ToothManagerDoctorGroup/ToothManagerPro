//
//  XLPayTool.h
//  CRM
//
//  Created by Argo Zhang on 16/5/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  支付
 */
@class XLOrderParam,CRMHttpRespondModel;
@interface XLPayTool : NSObject

/**
 *  (微信)支付
 *
 *  @param orderParam 订单模型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)payWithOrderParam:(XLOrderParam *)orderParam success:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;
/**
 *  支付宝支付
 *
 *  @param subject  商品名称
 *  @param body     商品描述
 *  @param totalFee 总价格
 *  @param billId   订单id
 *  @param billType 订单类型
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+ (void)alipayWithSubject:(NSString *)subject body:(NSString *)body totalFee:(NSString *)totalFee billId:(NSString *)billId billType:(NSString *)billType success:(void(^)(CRMHttpRespondModel *result))success failure:(void(^)(NSError *error))failure;
@end



@interface XLOrderParam : NSObject
/**
 *  商品名称
 */
@property (nonatomic, copy)NSString *body;
/**
 *  商品描述
 */
@property (nonatomic, copy)NSString *detail;
/**
 *  附加数据
 */
@property (nonatomic, copy)NSString *attach;
/**
 *  总金额
 */
@property (nonatomic, copy)NSString *total_fee;
/**
 *  本设备ip
 */
@property (nonatomic, copy)NSString *spbill_create_ip;
/**
 *  商品标签
 */
@property (nonatomic, copy)NSString *goods_tag;


- (instancetype)initWithBody:(NSString *)body
                      detail:(NSString *)detail
                      attach:(NSString *)attach
                    totalFee:(NSString *)totalFee
                    goodsTag:(NSString *)goodsTag;

@end

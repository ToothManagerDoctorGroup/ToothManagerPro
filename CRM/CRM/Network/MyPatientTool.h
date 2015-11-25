//
//  MyPatientTool.h
//  CRM
//
//  Created by Argo Zhang on 15/11/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRMHttpRespondModel;
@interface MyPatientTool : NSObject
/**
 *  获取患者是否绑定微信
 *
 *  @param patientName  患者姓名
 *  @param patientPhone 患者电话
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)getWeixinStatusWithPatientName:(NSString *)patientName patientPhone:(NSString *)patientPhone success:(void(^)(CRMHttpRespondModel *respondModel))success failure:(void(^)(NSError *error))failure;

@end

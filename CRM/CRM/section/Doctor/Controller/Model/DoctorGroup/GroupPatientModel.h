//
//  GroupPatientModel.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupPatientModel : NSObject

/**
 *  KeyId
 */
@property (nonatomic,assign)NSInteger keyId;
/**
 *  患者主键id
 */
@property (nonatomic, copy)NSString *ckeyid;
/**
 *  介绍人id
 */
@property (nonatomic,copy) NSString *introducer_id;
/**
 *  患者姓名
 */
@property (nonatomic,copy) NSString *patient_name;
/**
 *  患者状态
 */
@property (nonatomic,assign) NSInteger patient_status;
/**
 *  介绍人姓名
 */
@property (nonatomic,copy) NSString *intr_name;
/**
 *  种植数量
 */
@property (nonatomic,assign) NSInteger countMaterial;
/**
 *  是否被选中
 */
@property (nonatomic, assign)BOOL isChoose;

/**
 *  是否是组员
 */
@property (nonatomic, assign)BOOL isMember;

/**
 *  患者状态字符串
 */
@property (nonatomic, copy)NSString *statusStr;


- (instancetype)initWithDic:(NSDictionary *)dic;



@end

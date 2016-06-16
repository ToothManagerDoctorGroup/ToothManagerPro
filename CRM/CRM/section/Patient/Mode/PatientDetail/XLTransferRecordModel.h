//
//  XLTransferRecordModel.h
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

/**
 *  转诊记录模型
 */
@interface XLTransferRecordModel : NSObject

@property (nonatomic, assign)NSInteger number;//序号
@property (nonatomic, copy)NSString *doctor_id;//转诊的医生id
@property (nonatomic, copy)NSString *intr_time;//转诊时间
@property (nonatomic, copy)NSString *doctor_name;//转诊的医生名称
@property (nonatomic, copy)NSString *doctor_image;//转诊的医生头像

+ (instancetype)transferRecordModelWithResultSet:(FMResultSet *)resultSet;

@end

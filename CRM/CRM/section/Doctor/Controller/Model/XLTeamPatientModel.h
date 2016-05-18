//
//  XLTeamPatientModel.h
//  CRM
//
//  Created by Argo Zhang on 16/3/10.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  团队下患者的信息
 */
@interface XLTeamPatientModel : NSObject

/**
 *   "patient_id": "1020_20160108210434",
 "patient_name": "陈哈哈刚刚",
 "patient_status": 3,
 "implant_count": 0,
 "status": 0,
 "create_time": "2016-01-13 11:37:18"
 */
@property (nonatomic, copy)NSString *patient_id;
@property (nonatomic, copy)NSString *patient_name;
@property (nonatomic, strong)NSNumber *patient_status;//患者治疗状态
@property (nonatomic, strong)NSNumber *implant_count;
@property (nonatomic, strong)NSNumber *status;//付款状态
@property (nonatomic, copy)NSString *create_time;

@end

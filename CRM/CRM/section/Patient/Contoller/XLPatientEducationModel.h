//
//  XLPatientEducationModel.h
//  CRM
//
//  Created by Argo Zhang on 16/4/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLPatientEducationModel : NSObject

/**
*  主键
*/
@property (nonatomic, strong)NSNumber *keyId;
/**
 *  名称
 */
@property (nonatomic, copy)NSString *u_name;
/**
 *  类型
 */
@property (nonatomic, copy)NSString *u_type;
/**
 *  url
 */
@property (nonatomic, copy)NSString *u_url;
/**
 *  描述
 */
@property (nonatomic, copy)NSString *desc;
/**
 *  创建时间
 */
@property (nonatomic, copy)NSString *creation_time;
/**
 *  排序字段
 */
@property (nonatomic, strong)NSNumber *sort_num;
@end

//
//  XLAdviceDetailModel.h
//  CRM
//
//  Created by Argo Zhang on 16/4/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  医嘱详情
 */
@interface XLAdviceDetailModel : NSObject
/**
 *  主键
 */
@property (nonatomic, copy)   NSString *ckeyid;
/**
 *  医嘱名称
 */
@property (nonatomic, copy)   NSString *a_name;
/**
 *  医嘱类型的id
 */
@property (nonatomic, strong) NSNumber *advice_type_id;

/**
 *  医嘱类型的名称
 */
@property (nonatomic, copy)   NSString *advice_type_name;
/**
 *  医嘱内容的类型
 */
@property (nonatomic, copy)   NSString *content_type;
/**
 *  医嘱内容
 */
@property (nonatomic, copy)   NSString *a_content;
/**
 *  创建时间
 */
@property (nonatomic, copy)   NSString *creation_time;
/**
 *  医生的id
 */
@property (nonatomic, strong) NSString *doctor_id;


- (instancetype)initWithName:(NSString *)name adviceTypeId:(NSNumber *)adviceTypeId adviceTypeName:(NSString *)adviceTypeName contentType:(NSString *)contentType content:(NSString *)content;

@end

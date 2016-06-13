//
//  XLBehaviourModel.h
//  CRM
//
//  Created by Argo Zhang on 16/6/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLBehaviourModel : NSObject

@property (nonatomic, copy)NSString *keyId;//行为主键
@property (nonatomic, copy)NSString *doctor_id;//医生id
@property (nonatomic, copy)NSString *action_type;//行为类型
@property (nonatomic, copy)NSString *data_type;//数据类型
@property (nonatomic, copy)NSString *data_id;//数据id
@property (nonatomic, copy)NSString *device_token;
@property (nonatomic, copy)NSString *json_str;//完整数据json串

- (instancetype)initWithActionType:(NSString *)actionType
                          dataType:(NSString *)dataType
                            dataId:(NSString *)dataId
                           jsonStr:(NSString *)jsonStr;

- (NSString *)paramToJosnString;

@end

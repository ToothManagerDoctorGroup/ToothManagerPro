//
//  XLMessageTemplateParam.h
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  新增消息模板时用到的参数模型
 */
@class XLMessageTemplateModel;
@interface XLMessageTemplateParam : NSObject

/**
 *  DataEntity={KeyId=1,doctor_id=1,template_id,message_type,send_type,message_content,amr_file,message_name,disp_order=1,enabled=1}
 */
@property (nonatomic, copy)NSString *KeyId;
@property (nonatomic, copy)NSString *doctor_id;
@property (nonatomic, copy)NSString *template_id;
@property (nonatomic, copy)NSString *message_type;
@property (nonatomic, strong)NSNumber *send_type;
@property (nonatomic, copy)NSString *message_content;
@property (nonatomic, copy)NSString *amr_file;
@property (nonatomic, copy)NSString *message_name;
@property (nonatomic, strong)NSNumber *disp_order;
@property (nonatomic, strong)NSNumber *enabled;

- (instancetype)initWithDoctorId:(NSString *)doctor_id messageType:(NSString *)message_type messageContent:(NSString *)message_content;

- (instancetype)initWithMessageTemplateModel:(XLMessageTemplateModel *)model;

@end

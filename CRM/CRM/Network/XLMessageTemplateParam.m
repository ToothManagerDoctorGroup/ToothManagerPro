//
//  XLMessageTemplateParam.m
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMessageTemplateParam.h"
#import "XLMessageTemplateModel.h"
#import "AccountManager.h"

@implementation XLMessageTemplateParam
/**
 *  DataEntity={KeyId=1,doctor_id=1,template_id,message_type,send_type,message_content,amr_file,message_name,disp_order=1,enabled=1}
 */
- (instancetype)initWithDoctorId:(NSString *)doctor_id messageType:(NSString *)message_type messageContent:(NSString *)message_content{
    if (self = [super init]) {
        self.KeyId = @"0";
        self.doctor_id = doctor_id;
        self.template_id = @"U_DIY";
        self.message_type = message_type;
        self.send_type = @(0);
        self.message_content = message_content;
        self.amr_file = @"";
        self.message_name = message_type;
        self.disp_order = @(1);
        self.enabled = @(1);
    }
    return self;
}

- (instancetype)initWithMessageTemplateModel:(XLMessageTemplateModel *)model{
    if (self = [super init]) {
        self.KeyId = [NSString stringWithFormat:@"%ld",[model.keyId integerValue]];
        self.doctor_id = [AccountManager currentUserid];
        self.template_id = model.template_id;
        self.message_type = model.message_type;
        self.send_type = model.send_type;
        self.message_content = model.message_content;
        self.amr_file = model.amr_file;
        self.message_name = model.message_name;
        self.disp_order = model.disp_order;
        self.enabled = model.enabled;
    }
    return self;
}

@end

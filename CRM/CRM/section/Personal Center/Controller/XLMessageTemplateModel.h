//
//  XLMessageTemplateModel.h
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLMessageTemplateModel : NSObject
/**
 *  "KeyId": 8950,
 "template_id": null,
 "message_type": "定方案",
 "send_type": 0,
 "message_content": "您好！您已经成功预约{5}医生，就诊时间是{6}，届时将为您制定治疗计划，请准时就诊。如有疑问或时间变动请提前联系。",
 "amr_file": "",
 "message_name": "定方案预约通知",
 "disp_order": 0,
 "enabled": 1
 */

@property (nonatomic, strong)NSNumber *keyId;//主键
@property (nonatomic, copy)NSString *template_id;//模板信息id
@property (nonatomic, copy)NSString *message_type;//预约类型
@property (nonatomic, strong)NSNumber *send_type;//发送类型
@property (nonatomic, copy)NSString *message_content;//模板内容
@property (nonatomic, copy)NSString *amr_file;//文件
@property (nonatomic, copy)NSString *message_name;//预约信息名称
@property (nonatomic, strong)NSNumber *disp_order;
@property (nonatomic, strong)NSNumber *enabled;
@end

//
//  XLTemplateDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/26.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

typedef NS_ENUM(NSInteger, TemplateType) {
    TemplateTypePatientId, //0:患者Id
    TemplateTypePatientName, //1:患者名称
    TemplateTypeOperateDoctorId, //2:操作医生Id
    TemplateTypeOperateDoctorName, //3:操作医生名称
    TemplateTypeTreatDoctorId, //4:治疗医生Id
    TemplateTypeTreatDoctorName, //5:治疗医生名称
    TemplateTypeTime,           //6:时间
    TemplateTypeMessageType,    //7:事项
    TemplateTypeHospital,       //8:医院
    TemplateTypeMedicalChair,   //9:椅位
    TemplateTypePhone,          //10:电话
};
/**
 *  预约模板详情
 */
@class XLMessageTemplateModel;
@interface XLTemplateDetailViewController : TimDisplayViewController

@property (nonatomic, strong)XLMessageTemplateModel *model;

@property (nonatomic, assign)BOOL hindTintView;//隐藏提示文本

@property (nonatomic, assign)BOOL isEdit;//是编辑模式

@property (nonatomic, assign)BOOL isSystem;//表明是系统模板，不可删除

@end

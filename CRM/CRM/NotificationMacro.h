//
//  NotificationMacro.h
//  CRM
//
//  Created by Argo Zhang on 16/2/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

#pragma mark - NOtification


#define ConnectionStatusChangedNotification (@"ConnectionStatusChangedNotification") //网络状态发生变化
#define IsHaveLocalDataNotPostNotification (@"IsHaveLocalDataNotPostNotification") //有未上传的本地数据通知

#define SignInSuccessNotification (@"SignInSuccessNotification")  //登陆成功
#define SignUpSuccessNotification (@"SignUpSuccessNotification")  //注册成功
#define SignOutSuccessNotification (@"SignOutSuccessNotification")  //注册成功

#define SyncGetSuccessNotification (@"SyncGetSuccessNotification")//同步数据成功

#define MedicalCaseCreatedNotification (@"MedicalCaseCreatedNotification")   //病例创建
#define MedicalCaseNeedCreateNotification (@"MedicalCaseNeedCreateNotification")  //需要创建病例
#define MedicalCaseEditedNotification (@"MedicalCaseEditedNotification")       //病例被编辑
#define MedicalCaseCancleSuccessNotification (@"MedicalCaseCancleSuccessNotification")  //病历删除成功

#define PatientCreatedNotification (@"PatientCreatedNotification")             //创建了患者
#define PatientEditedNotification (@"PatientEditedNotification")               //编辑了患者
#define PatientTransferNotification (@"PatientTransferNotification")           //病人被转诊
#define PatientDeleteNotification (@"PatientDeleteNotification") //患者被删除

#define IntroducerCreatedNotification (@"IntroducerCreatedNotification")  //介绍人被创建
#define IntroducerEditedNotification (@"IntroducerEditedNotification")    //介绍人被编辑

#define MaterialCreatedNotification (@"MaterialCreatedNotification")   //创建了种植体
#define MaterialEditedNotification (@"MaterialEditedNotification")     //种植体被编辑了

#define NotificationCreated @"NotificationCreated"   //创建了新的提醒
#define NOtificationUpdated @"NotificationUpdated"   //更新了提醒
#define NotificationDeleted @"NotificationDeleted"   //删除了提醒

//支付通知
#define WeixinPayedNotification @"WeixinPayedNotification"
#define AlipayPayedNotification @"AlipayPayedNotification"
#define PayedResultSuccess @"SUCCESS"
#define PayedResultFailed @"FAILED"

/**********************医嘱****************************/
#define ChooseAdviceNotification @"ChooseAdviceNotification"   //选择了医嘱
#define MedicalAdviceAddSuccessNotification @"MedicalAdviceAddSuccessNotification"//创建医嘱成功
#define MedicalAdviceUpdateSuccessNotification @"MedicalAdviceUpdateSuccessNotification"//更新医嘱成功
#define MedicalAdviceDeleteSuccessNotification @"MedicalAdviceDeleteSuccessNotification"//删除医嘱成功

/**********************耗材信息****************************/
#define MedicalExpenseDeleteNotification @"MedicalExpenseDeleteNotification" //耗材信息被删除

/**********************耗材信息****************************/
#define YuyuePatientNotification @"YuyuePatientNotification" //选择了预约患者

#define RepairDoctorCreatedNotification (@"RepairDoctorCreatedNotification") //创建了修复医生
#define RepairDoctorEditedNotification (@"RepairDoctorEditedNotification")  //修复医生被编辑了

//预约成功后的通知
#define DoctorApplyForClinicSuccessNotification @"DoctorApplyForClinicSuccessNotification"
//医生添加组成员成功后的通知
#define DoctorAddGroupMemberSuccessNotification @"DoctorAddGroupMemberSuccessNotification"
//医生修改组名后通知
#define DoctorUpdateGroupNameSuccessNotification @"DoctorUpdateGroupNameSuccessNotification"
//医生删除分组后的通知
#define DoctorDeleteGroupSuccessNotification @"DoctorUpdateGroupNameSuccessNotification"
//医生删除组员成功后的通知
#define DoctorDeleteGroupMemberSuccessNotification @"DoctorDeleteGroupMemberSuccessNotification"
//医生付款成功后的通知
#define DoctorPaySuccessNotification @"DoctorPaySuccessNotification"
//查看一条未读消息成功后的通知
#define ReadUnReadMessageSuccessNotification @"ReadUnReadMessageSuccessNotification"

//预约事项通知
#define MessageTemplateAddNotification @"MessageTemplateAddNotification"//添加
#define MessageTemplateEditNotification @"MessageTemplateEditNotification"//修改
#define MessageTemplateDeleteNotification @"MessageTemplateDeleteNotification"//删除
/**********************治疗方案****************************/
#define TreatePlanAddNotification @"TreatePlanAddNotification" //添加治疗方案
#define TreatePlanEditNotification @"TreatePlanEditNotification" //修改治疗方案
#define TreatePlanDeleteNotification @"TreatePlanDeleteNotification" //删除治疗方案
/**********************服务团队****************************/
#define TeamMemberAddSuccessNotification @"TeamMemberAddSuccessNotification"//团队成员添加成功
#define TeamMemberDeleteSuccessNotification @"TeamMemberDeleteSuccessNotification"//团队成员删除成功


#endif /* NotificationMacro_h */

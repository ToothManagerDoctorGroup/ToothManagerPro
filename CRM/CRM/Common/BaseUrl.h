//
//  BaseUrl.h
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

// 域名
//#define DomainName @"http://122.114.62.57/"

#define DomainName @"http://118.244.234.207/"

#define Method_His_Crm @"his.crm"
#define Method_Weixin @"NewWeixin"
#define Method_ClinicServer @"clinicServer"
#define Method_Sys @"sys"

#define MyImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]
#define ImageFilePath(a,b) ([NSString stringWithFormat:@"%@%@_%@", MyImageDown, a, b])
//通用设置通知
#define AutoSyncTimeChangeNotification @"AutoSyncTimeChangeNotification"
#define AutoSyncStateChangeNotification @"AutoSyncStateChangeNotification"
#define AutoSyncOpenKey ([NSString stringWithFormat:@"%@_autoSyncOpen",[AccountManager currentUserid]])
#define AutoSyncTimeKey ([NSString stringWithFormat:@"%@_autoSyncTime",[AccountManager currentUserid]])
#define AutoAlertKey ([NSString stringWithFormat:@"%@_autoAlertKey",[AccountManager currentUserid]])
#define AutoReserveRecordKey ([NSString stringWithFormat:@"%@_autoReserveRecordKey",[AccountManager currentUserid]])
#define ResetAutoSyncTimeKey ([NSString stringWithFormat:@"%@_resetAutoSyncTimeKey",[AccountManager currentUserid]])

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


//通用设置状态
#define Auto_Action_Open @"open"
#define Auto_Action_Close @"close"
//通用设置时间
#define AutoSyncTime_Five @"5分钟"
#define AutoSyncTime_Ten @"10分钟"
#define AutoSyncTime_Twenty @"20分钟"

//分页时每页显示的总个数
#define CommonPageSize @(100)


//预约事项通知
#define MessageTemplateAddNotification @"MessageTemplateAddNotification"//添加
#define MessageTemplateEditNotification @"MessageTemplateEditNotification"//修改
#define MessageTemplateDeleteNotification @"MessageTemplateDeleteNotification"//删除


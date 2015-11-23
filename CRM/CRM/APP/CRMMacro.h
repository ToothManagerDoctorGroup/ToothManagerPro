//
//  CRMMacro.h
//  CRM
//
//  Created by TimTiger on 5/12/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#ifndef CRM_Macro_h
#define CRM_Macro_h

#pragma mark - Font 

#define TABLE_SECTION_HEADER_TITLE_FONT_SIZE (16.0f)
#define TABLE_SECTION_HEADER_TITLE_FONT ([UIFont boldSystemFontOfSize:TABLE_SECTION_HEADER_TITLE_FONT_SIZE])

#pragma mark - Color

#define TABLE_SECTION_HEADER_TITLE_COLOR ([UIColor whiteColor])
#define SEARCH_BAR_BACKGROUNDCOLOR (0xf8f8f8)
#define NAVIGATIONBAR_BACKGROUNDCOLOR (0x00a0ea)
#define MENU_BAR_BACKGROUND_COLOR (0xeaeaea)
#define CUSTOM_RED (0x9b0404)
#define CUSTOM_GREEN (0x209538)
#define CUSTOM_YELLOW (0x9b8301)

#pragma mark -  Size
#define TEXTFIELD_WIDTH (200.0f)
#define TEXTFIELD_HEIGHT (30.0f)
#define TEXTFIELD_EDGE_LEFT (60.0f)

#pragma mark - NOtification

#define SignInSuccessNotification (@"SignInSuccessNotification")  //登陆成功
#define SignUpSuccessNotification (@"SignUpSuccessNotification")  //注册成功
#define SignOutSuccessNotification (@"SignOutSuccessNotification")  //注册成功

#define MedicalCaseCreatedNotification (@"MedicalCaseCreatedNotification")   //病例创建
#define MedicalCaseNeedCreateNotification (@"MedicalCaseNeedCreateNotification")  //需要创建病例
#define MedicalCaseEditedNotification (@"MedicalCaseEditedNotification")       //病例被编辑
#define MedicalCaseCancleSuccessNotification (@"MedicalCaseCancleSuccessNotification")  //病历删除成功

#define PatientCreatedNotification (@"PatientCreatedNotification")             //创建了患者
#define PatientEditedNotification (@"PatientEditedNotification")               //编辑了患者
#define PatientTransferNotification (@"PatientTransferNotification")           //病人被转诊

#define IntroducerCreatedNotification (@"IntroducerCreatedNotification")  //介绍人被创建
#define IntroducerEditedNotification (@"IntroducerEditedNotification")    //介绍人被编辑

#define MaterialCreatedNotification (@"MaterialCreatedNotification")   //创建了种植体
#define MaterialEditedNotification (@"MaterialEditedNotification")     //种植体被编辑了

#define NotificationCreated @"NotificationCreated"   //创建了新的提醒
#define NOtificationUpdated @"NotificationUpdated"   //更新了提醒

#define RepairDoctorCreatedNotification (@"RepairDoctorCreatedNotification") //创建了修复医生
#define RepairDoctorEditedNotification (@"RepairDoctorEditedNotification")  //修复医生被编辑了

#define UMENG_APPKEY @"5394748f56240b2eff0e9ae9"   //友盟Appkey
#define APPLEID @"901754828"  //apple id

#endif

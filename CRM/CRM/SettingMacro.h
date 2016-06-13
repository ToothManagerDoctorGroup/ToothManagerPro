//
//  SettingMacro.h
//  CRM
//
//  Created by Argo Zhang on 16/2/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#ifndef SettingMacro_h
#define SettingMacro_h

/**
 *  通用设置
 */
#define AutoSyncTimeChangeNotification @"AutoSyncTimeChangeNotification"
#define AutoSyncStateChangeNotification @"AutoSyncStateChangeNotification"

#define AutoSyncOpenKey ([NSString stringWithFormat:@"%@_autoSyncOpen",[AccountManager currentUserid]])
#define AutoSyncTimeKey ([NSString stringWithFormat:@"%@_autoSyncTime",[AccountManager currentUserid]])
#define AutoAlertKey ([NSString stringWithFormat:@"%@_autoAlertKey",[AccountManager currentUserid]])
#define AutoReserveRecordKey ([NSString stringWithFormat:@"%@_autoReserveRecordKey",[AccountManager currentUserid]])
#define ResetAutoSyncTimeKey ([NSString stringWithFormat:@"%@_resetAutoSyncTimeKey",[AccountManager currentUserid]])
#define PatientToAddressBookKey ([NSString stringWithFormat:@"%@_patientToAddressBookKey",[AccountManager currentUserid]])

//通用设置状态
#define Auto_Action_Open @"open"
#define Auto_Action_Close @"close"
//通用设置时间
#define AutoSyncTime_Five @"5分钟"
#define AutoSyncTime_Ten @"10分钟"
#define AutoSyncTime_Twenty @"20分钟"

//分页时每页显示的总个数
#define CommonPageSize 200

//引导页面是否显示
#define Schedule_IsShowedKey @"Schedule_IsShowedKey"
//患者分组页面提示是否显示
#define GroupNew_IsShowedKey @"GroupNew_IsShowedKey"
//分组下添加患者页面提示是否显示
#define GroupMemberNew_IsShowedKey @"GroupMemberNew_IsShowedKey"
//当用户关闭通讯录权限的时候，提醒用户打开权限
#define AddressBook_IsShowKey @"AddressBook_IsShowKey"
//是否手动点击同步
#define HandleToSyncGetKey @"HandleToSyncGetKey"

/*************************提示更新设置*********************/
#define NewVersionUpdate_TimeKey @"NewVersionUpdate_TimeKey"
static const NSTimeInterval NewVersionUpdateTimeInterval = 60 * 60 * 24 * 3;

#define QRCODE_URL_KEY [NSString stringWithFormat:@"%@_doctor_qrcode_url",[AccountManager currentUserid]]

#endif /* SettingMacro_h */

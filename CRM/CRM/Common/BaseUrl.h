//
//  BaseUrl.h
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

// 域名
#define DomainName @"http://122.114.62.57/"

//#define DomainName @"http://118.244.234.207/"

#define Method_His_Crm @"his.crm"
#define Method_Weixin @"NewWeixin"
#define Method_ClinicServer @"clinicServer"
#define Method_Sys @"sys"

#define MyImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]
#define ImageFilePath(a,b) ([NSString stringWithFormat:@"%@%@_%@", MyImageDown, a, b])

//通用设置导入
#import "NotificationMacro.h"
#import "SettingMacro.h"

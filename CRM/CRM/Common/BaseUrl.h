//
//  BaseUrl.h
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//



#define MyImageDown [NSString stringWithFormat:@"%@%@/UploadFiles/",DomainName,Method_His_Crm]
#define ImageFilePath(a,b) ([NSString stringWithFormat:@"%@%@_%@", MyImageDown, a, b])

//通用设置导入
#import "NotificationMacro.h"
#import "SettingMacro.h"
#import "NetworkConfigMacro.h"
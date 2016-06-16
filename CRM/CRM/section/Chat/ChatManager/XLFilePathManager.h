//
//  XLFilePathManager.h
//  CRM
//
//  Created by Argo Zhang on 16/5/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacro.h"

@interface XLFilePathManager : NSObject
Declare_ShareInstance(XLFilePathManager);

- (void)saveFileWithFileName:(NSString *)fileName;

//创建文件夹
- (NSString *)createDirWithPatientId:(NSString *)patientId;
//文件是否存在
- (BOOL)fileExistsWithFilePath:(NSString *)filePath;
//下载语音文件
- (void)downLoadFileWithUrl:(NSString *)urlStr
              fileLocalPath:(NSString *)localPath
                    success:(void (^)())success
                    failure:(void (^)(NSError *error))failure;

@end


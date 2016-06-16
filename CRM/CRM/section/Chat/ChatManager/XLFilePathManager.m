//
//  XLFilePathManager.m
//  CRM
//
//  Created by Argo Zhang on 16/5/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLFilePathManager.h"
#import "AFNetworking.h"

@implementation XLFilePathManager
Realize_ShareInstance(XLFilePathManager);

- (void)saveFileWithFileName:(NSString *)fileName{
    
}

- (NSString *)createDirWithPatientId:(NSString *)patientId{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取cache文件夹
    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //获取要创建的文件夹目录
    NSString *createPath = [NSString stringWithFormat:@"%@/ChatRecord/%@",pathCache,patientId];
    //判断文件夹是否存在
    if (![fileManager fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return createPath;
}

- (BOOL)fileExistsWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

- (void)downLoadFileWithUrl:(NSString *)urlStr
              fileLocalPath:(NSString *)localPath
                    success:(void (^)())success
                    failure:(void (^)(NSError *error))failure{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [operation start];
}


@end

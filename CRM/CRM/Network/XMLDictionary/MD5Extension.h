//
//  MD5Extension.h
//  umCoreLib
//
//  Created by yxb on 12-12-27.
//  Copyright (c) 2012年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 // usage:
 
 NSString *filePath = ...; // Let's assume filePath is defined...
 CFStringRef md5hash =
 FileMD5HashCreateWithPath((CFStringRef)filePath,
 FileHashDefaultChunkSizeForReadingData);
 NSLog(@"MD5 hash of file at path \"%@\": %@",
 filePath, (NSString *)md5hash);
 CFRelease(md5hash);
 
 */

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData);

@interface MD5Extension : NSObject
/*
 使用标准文件读写操作来读输入的文件
 */
+(NSString*)stdfileMD5:(NSString*)path;

/*
 使用NSFileHandler来读取输入的文件
 */
+(NSString*)fileMD5:(NSString*)path;
@end

@interface NSString (MyExtensions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end
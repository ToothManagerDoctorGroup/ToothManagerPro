//
//  MyUploadParam.h
//  CRM
//
//  Created by Argo Zhang on 15/11/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MyUploadParam : NSObject<MJKeyValue>

/**
 *  上传图片的二进制数据
 */
@property (nonatomic, strong)NSData *data;
/**
 *  上传图片的参数名称
 */
@property (nonatomic, copy)NSString *name;
/**
 *  保存到服务器的文件名称
 */
@property (nonatomic, copy)NSString *fileName;
/**
 *  文件的类型
 */
@property (nonatomic, copy)NSString *mimeType;

@end

//
//  TTMUpLoadParam.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMUpLoadParam : NSObject<MJKeyValue>
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

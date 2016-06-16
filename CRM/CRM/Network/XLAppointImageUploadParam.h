//
//  XLAppointImageUploadParam.h
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  预约图片上传参数模型
 */
@interface XLAppointImageUploadParam : NSObject

/**
 *  {"reserver_id":"123","file_name":"123_232.jpg","file_type":"ct","doctor_id":12,"creation_time":"2016-05-18 19:18:24"}
 */

@property (nonatomic, copy)NSString *imageUrl;//图片的url

@property (nonatomic, strong)UIImage *thumbnailImage;//压缩图片
/**
*  预约id
*/
@property (nonatomic, copy)NSString *reserver_id;
/**
 *  文件名称
 */
@property (nonatomic, copy)NSString *file_name;
/**
 *  文件类型（ct，）
 */
@property (nonatomic, copy)NSString *file_type;
/**
 *  医生id
 */
@property (nonatomic, copy)NSString *doctor_id;
/**
 *  创建时间
 */
@property (nonatomic, copy)NSString *creation_time;

/**
 *  上传图片时的二进制数据
 */
@property (nonatomic, strong)NSData *imageData;

- (instancetype)initWithThumbnailImage:(UIImage *)thumbnailImage
                           fileType:(NSString *)fileType
                          imageData:(NSData *)imageData;

@end

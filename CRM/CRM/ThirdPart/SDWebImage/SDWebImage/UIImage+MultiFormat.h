//
//  UIImage+MultiFormat.h
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MultiFormat)

+ (UIImage *)sd_imageWithData:(NSData *)data;

//压缩图片，当加载的图片大于1M的时候进行等比例压缩，解决使用MJPhotoBrowser产生的内存警告
+(UIImage *)compressImageWith:(UIImage *)image;

@end

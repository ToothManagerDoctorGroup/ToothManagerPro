//
//  UIImage+THCAddtion.h
//  MerchantClient
//
//  Created by Jeffery He on 15/4/1.
//  Copyright (c) 2015年 Chongqing Huizhan Networking Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (THCAddtion)

/*!
 @method
 @abstract 根据设备创建对应的Image，主要用在引导页
 @discussion 根据设备创建对应的Image，主要用在引导页
 
 @param name 文件的名字
 
 @result 返回创建的UIImage对象
 */
+ (UIImage *)imageDeviceVersionWithName:(NSString *)name;

/*!
 @method
 @abstract 拉伸图片
 @discussion 拉伸图片
 
 @param name 需要拉伸的图片名字
 
 @result 返回拉伸好的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/*!
 @method
 @abstract 获取一张圆形的UIImage
 @discussion 获取一张圆形的UIImage
 
 @param name 图片的名字
 
 @result 返回圆形的UIImage
 */
+ (UIImage *)circleImageWithName:(NSString *)name;

/*!
 @method
 @abstract 模糊Image
 @discussion 模糊Image
 
 @param blur 模糊的比例
 
 @result 返回模糊后的UIImage
 */
- (UIImage *)imageWithBlur:(CGFloat)blur;

/*!
 @method
 @abstract 对图片进行压缩
 @discussion 对图片进行压缩
 
 @param image 原始图片
 @param size 需要压缩的大小
 
 @result 返回压缩后的UIImage
 */
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 *  对图片指定宽度按比例缩放
 *
 *  @param sourceImage 原图片
 *  @param defineWidth 指定宽度
 *
 *  @return 压缩后的图片
 */
- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

- (UIImage *)maskImage:(UIColor *)maskColor;

/**
 *  绘制一张圆形图片，里面带有数字
 *
 *  @param content 数字
 *  @param color   颜色
 *  @param font    字体大小
 *  @param radius  半径
 *
 *  @return 绘制好的圆
 */
+ (UIImage *)drowRoundImageWithContent:(NSInteger)num;
/**
 *  加载图片
 *
 *  @param fileName 图片名称
 *
 *  @return 加载后的图片
 */
+ (UIImage *)imageWithFileName:(NSString *)fileName;

/**
 *  防止图片被自动旋转90度
 *
 *  @param aImage 原始图片
 *
 *  @return 正常图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

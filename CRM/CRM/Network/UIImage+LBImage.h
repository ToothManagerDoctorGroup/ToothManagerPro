//
//  UIImage+LBImage.h
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 徐晓龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBImage)
//获取未被系统自动渲染的图片
+ (instancetype)getOriginImageWithImageName:(NSString *)imageName;
//拉伸图片
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

//下载图片
+ (UIImage *) getImageFromURL:(NSString *)fileURL;
@end

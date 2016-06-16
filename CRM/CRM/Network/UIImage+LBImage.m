//
//  UIImage+LBImage.m
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 徐晓龙. All rights reserved.
//

#import "UIImage+LBImage.h"

@implementation UIImage (LBImage)

+ (instancetype)getOriginImageWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    //返回未被系统渲染的图片
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//返回被拉伸之后的图片
+ (instancetype)imageWithStretchableName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

@end

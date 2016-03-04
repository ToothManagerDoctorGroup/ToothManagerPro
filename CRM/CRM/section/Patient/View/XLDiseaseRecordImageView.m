//
//  XLDiseaseRecordImageView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordImageView.h"

@implementation XLDiseaseRecordImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setImages:(NSArray *)images{
    _images = images;
    
    //创建多个图片视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat margin = 10;
    CGFloat imageW = 60;
    CGFloat imageH = imageW;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    //获取一行最多显示几张图片(列)
    NSInteger cols = self.frame.size.width / (imageW + margin);
    //计算总共显示几行（行）
    NSInteger rows = images.count % cols == 0 ? images.count / cols : images.count / cols + 1;
    
    for (int i = 0; i < images.count; i++) {
        NSInteger row = i / cols;
        NSInteger col = i % cols;
        
        imageX = margin + (margin + imageW) * col;
        imageY = margin + (margin + imageH) * row;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imageView.image = [UIImage imageNamed:@"user"];
        imageView.layer.cornerRadius = 4;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 100 + i;
        [self addSubview:imageView];
    }
}

@end

//
//  XLLongImageScrollView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLLongImageScrollView.h"
#import "UIImage+TTMAddtion.h"

@interface XLLongImageScrollView ()

@property (nonatomic, weak)UIImageView *imageView;

@property (nonatomic, assign)long currentScale;

@end

@implementation XLLongImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    // 隐藏水平滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.multipleTouchEnabled = YES;
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    self.currentScale = 1.0;
}

- (void)setImage:(UIImage *)image{
    
    _image = [image imageCompressForWidth:image targetWidth:kScreenWidth];
    self.imageView.image = _image;
}

- (void) scaleImage:(UIPinchGestureRecognizer*)gesture

{
    
    CGFloat scale = gesture.scale;
    
    // 如果捏合手势刚刚开始
    if (gesture.state == UIGestureRecognizerStateBegan)
        
    {
        // 计算当前缩放比
        self.currentScale = self.imageView.image.size.width / _image.size.width;
    }
    
    // 根据手势处理器的缩放比例计算图片缩放后的目标大小
    CGSize targetSize = CGSizeMake(_image.size.width * scale * self.currentScale,
                                   
                                   _image.size.height * scale * self.currentScale);
    
    // 对图片进行缩放
    self.imageView.image = [UIImage imageCompressForSize:_image targetSize:targetSize];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imgW = self.imageView.image.size.width; // 图片的宽度
    CGFloat imgH = self.imageView.image.size.height; // 图片的高度
    self.imageView.frame = CGRectMake(0, 0, imgW, imgH);
    
    // 3.设置scrollView的属性
    // 设置UIScrollView的滚动范围（内容大小）
    self.contentSize = self.imageView.image.size;

}



@end

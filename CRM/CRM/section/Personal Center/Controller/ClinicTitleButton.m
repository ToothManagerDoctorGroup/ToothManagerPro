//
//  ClinicTitleButton.m
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicTitleButton.h"
#import "UIImage+LBImage.h"

@implementation ClinicTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置按钮的文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置按钮高亮时的背景图片
//        [self setBackgroundImage:[UIImage imageWithStretchableName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    }
    return self;
}

#pragma mark - 修改控件的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    //如果没有图片，就返回
    if(self.currentImage == nil) return;
    
    //调整图片和标题的位置
    //标题
    self.titleLabel.left = self.imageView.left;
    //图片
    self.imageView.left = CGRectGetMaxX(self.titleLabel.frame);
}


//重写按钮属性的set方法，扩展自适应的功能
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}


@end

//
//  XLLongImageView.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLLongImageView.h"

@interface XLLongImageView ()<UIActionSheetDelegate>

@end

@implementation XLLongImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色和填充模式
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor blackColor];
        
        //当imageView创建的时候添加手势
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 放大图片视图方法
- (void)zoomInView{
    // 1.创建scrollView
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    //设置scrollView的背景透明
    _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //添加到window上
    [self.window addSubview:_scrollView];
    
    // 2.创建放大后的imageView
    if (_originImageView == nil) {
        //开始时不设置frame
        _originImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //设置填充模式
        _originImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    //设置_originImageView的frame
    _originImageView.frame = [self convertRect:self.bounds toView:self.window];
    //设置默认的图片
    _originImageView.image = self.image;
    //添加到scrollView上
    [_scrollView addSubview:_originImageView];
    
    // 3.添加动画
    [UIView animateWithDuration:.35 animations:^{
        //设置scrollView的透明度
        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        //计算图片的高度（等比例）
        CGFloat imgH = _originImageView.image.size.height / _originImageView.image.size.width * kScreenWidth;
        
        //判断图片的高度
        if (imgH > _scrollView.height) {
            _originImageView.frame = CGRectMake(0, 0, kScreenWidth, imgH);
            //设置_scrollView偏移位置
            _scrollView.contentSize = CGSizeMake(kScreenWidth, imgH);
            
        }else{
            _originImageView.frame = _scrollView.bounds;
            
            //设置偏移位置
            _scrollView.contentSize = _scrollView.frame.size;
            
        }
    } completion:^(BOOL finished) {
//        if(self.bgImageUrl != nil){
//        }
    }];
}

#pragma mark - 图片长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    //判断，只点击一次
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //创建提示视图
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"保存图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        [sheet showInView:_scrollView];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(_originImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存成功");
}

#pragma mark - 图片单击缩小事件
- (void)zoomOutView:(UITapGestureRecognizer *)tap{
    
//    //设置填充模式
//    [UIView animateWithDuration:.35 animations:^{
//        //缩小图片
//        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//        _originImageView.frame = [self convertRect:self.bounds toView:self.window];
//        
//    } completion:^(BOOL finished) {
//        [_scrollView removeFromSuperview];
//        [_originImageView removeFromSuperview];
//    }];
    
}

@end

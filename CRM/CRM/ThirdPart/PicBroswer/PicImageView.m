//
//  PicImageView.m
//  CRM
//
//  Created by Argo Zhang on 16/3/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "PicImageView.h"
#import "UIImageView+WebCache.h"

@interface PicImageView (){
    UIImageView *_imageView;
    UIImageView *_targetImageView;
}

@end

@implementation PicImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

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
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode     = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor blackColor];
    [self addSubview:_imageView];
    
    _targetImageView = [[UIImageView alloc] init];
    [self addSubview:_targetImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
    if (self.targetImage) {
        _targetImageView.frame = CGRectMake(kScreenWidth - 66, 44, 66, 66);
        _targetImageView.image = self.targetImage;
    }
}

- (void)setTargetImage:(UIImage *)targetImage{
    _targetImage = targetImage;
    [self setNeedsLayout];
}

- (void)setTargetImageHidden:(BOOL)targetImageHidden{
    _targetImageHidden = targetImageHidden;
    
    _targetImageView.hidden = targetImageHidden;
}

- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    
//    [_imageView sd_setImageLoadingWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:urlStr]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:urlStr] options:SDWebImageRetryFailed | SDWebImageRefreshCached];
}

@end

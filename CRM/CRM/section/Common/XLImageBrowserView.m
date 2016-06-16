//
//  XLImageBrowserView.m
//  CRM
//
//  Created by Argo Zhang on 16/5/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLImageBrowserView.h"
#import "UIImageView+WebCache.h"

#define LeftTag   (100)
#define CenterTag (101)
#define RightTag  (102)
#define ImageViewTag (103)
#define LeftFrame CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
#define CenterFrame CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, _scrollView.bounds.size.height)
#define RightFrame CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, _scrollView.bounds.size.height)

@interface XLImageBrowserView () <UIScrollViewDelegate>
@end

@implementation XLImageBrowserView

- (void)setupImageViews:(NSInteger)imageNum {
    self.topBar.alpha = 0.8;
    self.bottomBar.alpha = 0.8f;
    UITapGestureRecognizer  *tapgesture = [[UITapGestureRecognizer alloc]init];
    [tapgesture addTarget:self action:@selector(tapAction:)];
    tapgesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapgesture];
    
    UIScrollView *leftScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    leftScrollView.delegate         = self;
    leftScrollView.tag              = LeftTag;
    leftScrollView.bounces          = NO;
    leftScrollView.bouncesZoom      = NO;
    leftScrollView.maximumZoomScale = 3.0f;
    leftScrollView.minimumZoomScale = 1.0f;
    UIImageView *imageViewLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    imageViewLeft.contentMode = UIViewContentModeScaleAspectFit;
    imageViewLeft.backgroundColor     = [UIColor blackColor];
    imageViewLeft.tag                 = ImageViewTag;
    [leftScrollView addSubview:imageViewLeft];
    [self.scrollView addSubview:leftScrollView];
    UIScrollView *centerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, _scrollView.bounds.size.height)];
    centerScrollView.delegate         = self;
    centerScrollView.tag              = CenterTag;
    centerScrollView.bounces          = NO;
    centerScrollView.bouncesZoom      = NO;
    centerScrollView.maximumZoomScale = 3.0f;
    centerScrollView.minimumZoomScale = 1.0f;
    UIImageView *imageViewCenter = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _scrollView.bounds.size.height)];
    imageViewCenter.contentMode = UIViewContentModeScaleAspectFit;
    imageViewCenter.backgroundColor = [UIColor blackColor];
    imageViewCenter.tag = ImageViewTag;
    [centerScrollView addSubview:imageViewCenter];
    [self.scrollView addSubview:centerScrollView];
    UIScrollView *rightScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, _scrollView.bounds.size.height)];
    rightScrollView.delegate    = self;
    rightScrollView.tag         = RightTag;
    rightScrollView.bounces     = NO;
    rightScrollView.bouncesZoom = NO;
    rightScrollView.maximumZoomScale = 3.0f;
    rightScrollView.minimumZoomScale = 1.0f;
    UIImageView *imageViewRight = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _scrollView.bounds.size.height)];
    imageViewRight.contentMode     = UIViewContentModeScaleAspectFit;
    imageViewRight.backgroundColor = [UIColor blackColor];
    imageViewRight.tag             = ImageViewTag;
    [rightScrollView addSubview:imageViewRight];
    [self.scrollView addSubview:rightScrollView];
    self.scrollView.contentSize    = CGSizeMake(self.bounds.size.width*3,0);
    self.scrollView.contentOffset  = CGPointMake(self.bounds.size.width,0);
    self.scrollView.bouncesZoom    = NO;
    self.deleteButton.enabled      = YES;
    self.scrollView.delegate       = self;
    self.scrollView.bounces        = NO;
}

- (void)setLeftImage:(XLBrowserPicture *)pic {
    UIScrollView *leftView = (UIScrollView *)[self.scrollView viewWithTag:LeftTag];
    UIImageView *leftImageView = (UIImageView *)[leftView viewWithTag:ImageViewTag];
    if (pic.image) {
        leftImageView.image = pic.image;
    }else{
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:pic.url] placeholderImage:[UIImage imageNamed:@"schedule_placeholder_loading"] options:SDWebImageRetryFailed | SDWebImageRefreshCached];
    }
}

- (void)setCenterImage:(XLBrowserPicture *)pic {
    UIScrollView *centerView = (UIScrollView *)[self.scrollView viewWithTag:CenterTag];
    UIImageView *centerImageView = (UIImageView *)[centerView viewWithTag:ImageViewTag];
    if (pic.image) {
        centerImageView.image = pic.image;
    }else{
        [centerImageView sd_setImageWithURL:[NSURL URLWithString:pic.url] placeholderImage:[UIImage imageNamed:@"schedule_placeholder_loading"] options:SDWebImageRetryFailed | SDWebImageRefreshCached];
    }
}

- (void)setRightImage:(XLBrowserPicture *)pic {
    UIScrollView *rightView = (UIScrollView *)[self.scrollView viewWithTag:RightTag];
    UIImageView *rightImageView  = (UIImageView *)[rightView viewWithTag:ImageViewTag];
    if (pic.image) {
        rightImageView.image = pic.image;
    }else{
        [rightImageView sd_setImageWithURL:[NSURL URLWithString:pic.url] placeholderImage:[UIImage imageNamed:@"schedule_placeholder_loading"] options:SDWebImageRetryFailed | SDWebImageRefreshCached];
    }
    
}

- (IBAction)dismissAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAction:)]) {
        [self.delegate dismissAction:sender];
    }
}

- (IBAction)pageupAction:(id)sender {
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width,0);
    [self pageUp];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageupAction:)]) {
        [self.delegate pageupAction:sender];
    }
}

- (IBAction)pagedownAction:(id)sender {
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width,0);
    [self pageDown];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagedownAction:)]) {
        [self.delegate pagedownAction:self.scrollView];
    }
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAction:)]) {
        [self.delegate deleteAction:sender];
    }
}

- (void)tapAction:(id)sender {
    UIScrollView *centerView = (UIScrollView *)[self.scrollView viewWithTag:CenterTag];
    if (centerView.zoomScale > centerView.minimumZoomScale) {
        [centerView setZoomScale:centerView.minimumZoomScale animated:YES];
        self.topBar.hidden = NO;
        self.bottomBar.hidden = NO;
    }
}

- (void)setBarTintColor:(UIColor *)tintColor {
    [self.topBar setTintColor:tintColor];
    self.topBar.alpha = 0.8;
    [self.bottomBar setTintColor:tintColor];
    self.bottomBar.alpha = 0.8;
}

- (void)pageDown {
    UIScrollView *centerView = (UIScrollView *)[self.scrollView viewWithTag:CenterTag];
    [centerView setFrame:RightFrame];
    UIScrollView *rightView = (UIScrollView *)[self.scrollView viewWithTag:RightTag];
    [rightView setFrame:CenterFrame];
    rightView.tag      = CenterTag;
    centerView.tag     = RightTag;
}

- (void)pageUp {
    UIScrollView *leftView = (UIScrollView *)[self.scrollView viewWithTag:LeftTag];
    [leftView setFrame:CenterFrame];
    UIScrollView *centerView = (UIScrollView *)[self.scrollView viewWithTag:CenterTag];
    [centerView setFrame:LeftFrame];
    centerView.tag      = LeftTag;
    leftView.tag        = CenterTag;
}

#pragma mark - Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.deleteButton.enabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        static int lastOffsetx = 1;
        if (((int)(scrollView.contentOffset.x) % (int)(scrollView.bounds.size.width) == 0)) {
            int index = scrollView.contentOffset.x / scrollView.bounds.size.width;
            if (index > lastOffsetx) {
                [self pagedownAction:scrollView];
            }
            if (index < lastOffsetx) {
                [self pageupAction:scrollView];
            }
        }
        self.deleteButton.enabled = NO;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollView.scrollEnabled = NO;
    self.topBar.hidden            = YES;
    self.bottomBar.hidden         = YES;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == scrollView.minimumZoomScale) {
        self.scrollView.scrollEnabled = YES;
        self.topBar.hidden            = NO;
        self.bottomBar.hidden         = NO;
        scrollView.contentSize = CGSizeMake(self.bounds.size.width,0);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        return nil;
    }
    return [scrollView.subviews objectAtIndex:0];
}

@end

@implementation XLBrowserPicture


@end

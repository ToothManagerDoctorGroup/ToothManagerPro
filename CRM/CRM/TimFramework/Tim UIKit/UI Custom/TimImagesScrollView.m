//
//  TimImagesScrollView.m
//  CRM
//
//  Created by TimTiger on 1/25/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimImagesScrollView.h"
#import "UIView+Category.h"
#import "NSString+Conversion.h"
#import "UIImageView+WebCache.h"

@implementation TimImage


@end

@implementation TimImagesScrollView

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
//    self.contentSize = CGSizeMake(self.imageViewWidth*self.imageArray.count, 0);
    [self removeAllSubviews];
    self.contentSize = CGSizeMake(self.imageArray.count * (self.imageViewWidth + 5), self.height);
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        TimImage *image = [self.imageArray objectAtIndex:i];
        if ([NSString isNotEmptyString:image.url]) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(self.imageViewWidth + 5), 0, self.imageViewWidth, self.bounds.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            [imageView sd_setImageLoadingWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:image.url]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:image.url] options:SDWebImageRetryFailed | SDWebImageRefreshCached];
            
            imageView.userInteractionEnabled = YES;
            imageView.clipsToBounds = YES;
            UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]init];
            [tapgesture addTarget:self action:@selector(imageTouchAction:)];
            tapgesture.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tapgesture];
            imageView.tag = 100+i;
            [self addSubview:imageView];
            if ([NSString isNotEmptyString:image.title] && self.showTitle) {
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*self.imageViewWidth, 0, self.imageViewWidth, 20)];
                titleLabel.backgroundColor = [UIColor blackColor];
                titleLabel.alpha = 0.8;
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.font = [UIFont systemFontOfSize:14.0f];
                titleLabel.text = image.title;
                [self addSubview:titleLabel];
            }
        }
    }

}

- (void)imageTouchAction:(UITapGestureRecognizer *)sender {
    
    UIImageView *imageView = (UIImageView *)sender.view;
    NSLog(@"%@",imageView.image);
    
    if (self.sdelegate && [self.sdelegate respondsToSelector:@selector(imagesScrollView:didTouchImage:)]) {
        [self.sdelegate imagesScrollView:self didTouchImage:sender.view.tag-100];
    }
}

@end

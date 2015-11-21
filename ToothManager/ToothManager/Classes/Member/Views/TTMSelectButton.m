

#import "TTMSelectButton.h"

@implementation TTMSelectButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleW = 40.f;
    CGFloat titleH = self.height;
    CGFloat titleX = 10.f;
    CGFloat titleY = (self.height - titleH) / 2;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = 17.f  / 2;
    CGFloat imageH = 14.f / 2;
    CGFloat imageX = self.width - imageW;
    CGFloat imageY = (self.height - imageH - 6.f);
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end

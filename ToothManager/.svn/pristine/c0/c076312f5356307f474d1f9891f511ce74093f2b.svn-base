
#import "TTMPhotoSelectorView.h"
#import "UIImage+TTMAddtion.h"

#define kColumn 3
#define kDeleteButtonWH 25.0f
#define kMarginY 10.0f

@interface TTMPhotoSelectorView ()

@property (nonatomic, weak) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *photoImages;

@end

@implementation TTMPhotoSelectorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (NSMutableArray *)photoImages {
    if (!_photoImages) {
        _photoImages = [NSMutableArray array];
    }
    return _photoImages;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *reverseViews = [[self.subviews reverseObjectEnumerator] allObjects];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat marginX = (self.width - kPhotoSelectorButtonW * kColumn) / (kColumn + 1);
    CGFloat marginY = kMarginY;
    CGFloat subViewWH = MIN(kPhotoSelectorButtonW, self.height);

    for (NSInteger i = 0; i < count; i++) {
        UIView *subView = reverseViews[i];
        CGRect tempFrame = subView.frame;
        CGFloat subViewX = marginX + i % kColumn * (marginX + subViewWH);
        CGFloat subViewY = i / kColumn * (marginY + subViewWH);
        CGFloat subViewW = subViewWH;
        CGFloat subViewH = subViewWH;
        tempFrame = CGRectMake(subViewX, subViewY, subViewW, subViewH);
        subView.frame = tempFrame;
        
        if (self.isAddButtonDisappear) {
            if (i != 0 && i == self.maxImageNumber) {
                subView.hidden = YES;
            } else {
                subView.hidden = NO;
            }
        } else {
            // 达到最大值，加号按钮不可用
            if (self.maxImageNumber == (count - 1)) {
                self.addButton.enabled = NO;

            } else {
                self.addButton.enabled = YES;
            }
        }
    }
}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _maxImageNumber = kColumn;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    self.addButton = addButton;
}

- (void)addImage:(UIImage *)image {
    CGSize imageSize = CGSizeMake(640.0f, 960.0f);
    image = [image imageCompressForSize:image targetSize:imageSize];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85f);
    NSString *imageBase64str = [imageData base64EncodedStringWithOptions:0];
    
    [self.photoImages addObject:imageBase64str];
    
    CGFloat subViewWH = MIN(kPhotoSelectorButtonW, self.height);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 5.0f;
    imageView.frame = CGRectMake(0.0f, 0.0f, subViewWH, subViewWH);
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat deleteButtonX = subViewWH - kDeleteButtonWH;
    [deleteButton setImage:[UIImage imageNamed:@"order_camera_delete"] forState:UIControlStateNormal];
    deleteButton.frame = CGRectMake(deleteButtonX, 0.0f, kDeleteButtonWH, kDeleteButtonWH);
    [deleteButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deleteButton];
    [self addSubview:imageView];
}

- (void)setBackgroundImage:(NSString *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self.addButton setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
}

- (void)setHightlightBackgroundImage:(NSString *)hightlightBackgroundImage {
    _hightlightBackgroundImage = hightlightBackgroundImage;
    [self.addButton setBackgroundImage:[UIImage imageNamed:hightlightBackgroundImage] forState:UIControlStateHighlighted];
}

- (void)setDisableBackgroundImage:(NSString *)disableBackgroundImage {
    _disableBackgroundImage = disableBackgroundImage;
    [self.addButton setBackgroundImage:[UIImage imageNamed:disableBackgroundImage] forState:UIControlStateDisabled];
}

- (void)buttonAction:(UIButton *)button {
    if (button == self.addButton) {// 添加的按钮
        if ([self.delegate respondsToSelector:@selector(photoSelectorView:didSelected:)]) {
            [self.delegate photoSelectorView:self didSelected:button];
        }
    } else {
        UIImageView *imageView = (UIImageView *)[button superview];
        NSData *imageData = UIImagePNGRepresentation(imageView.image);
        NSString *imageBase64str = [imageData base64EncodedStringWithOptions:0];
        [self.photoImages removeObject:imageBase64str];
        [imageView removeFromSuperview];
    }
}

- (NSArray *)photos {
    return [self.photoImages copy];
}

@end

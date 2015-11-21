
#import "TTMAddImageView.h"
#import "UIButton+WebCache.h"

#define kPadding 5
#define kCornRadius 2
#define kColumns 4 // 列数

@interface TTMAddImageView ()



@end

@implementation TTMAddImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.photoArray = [NSMutableArray array];
}

- (void)reloadView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 图片张数等于最大了，就不放加号图片
    NSUInteger allCount = self.photoArray.count + 1;
    NSUInteger columns = kColumns;
    
    for (NSInteger i = 0; i < allCount; i ++) {
        CGFloat width = (self.frame.size.width - (kPadding * (columns + 1))) / columns ;
        CGFloat height = width;
        
        CGFloat row = i / columns;
        CGFloat col = i % columns;
        
        UIButton *imageButton = [[UIButton alloc] init];
        imageButton.frame = CGRectMake(col * (kPadding + width) + kPadding, row * (height + kPadding), width, height);
        imageButton.tag = i; // 用来记录照片index
        [imageButton addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.layer.cornerRadius = kCornRadius;
        imageButton.clipsToBounds = YES;
        [self addSubview:imageButton];
        
        if (i == self.photoArray.count) { // 在数组最后添加加号图片
            [imageButton setBackgroundImage:[UIImage imageNamed:@"clinic_plus"] forState:UIControlStateNormal];
        } else {
            TTMRealisticModel *model = self.photoArray[i];
            [imageButton sd_setImageWithURL:[NSURL URLWithString:model.img_info] forState:UIControlStateNormal];
            
            // 添加删除按钮
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *deleteImage = [UIImage imageNamed:@"delete"];
            [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
            deleteButton.tag = i;
            [imageButton addSubview:deleteButton];
            [deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat deleteImageWH = deleteImage.size.width;
            deleteButton.frame = CGRectMake(imageButton.width - deleteImageWH - 5.f, 5.f, deleteImageWH, deleteImageWH);
        }
    }
}


/**
 *  点击图片
 */
- (void)clickImage:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(addImageView:clickedWithModel:button:)]) {
        TTMRealisticModel *model = nil;
        if (self.photoArray.count > button.tag) {
            model = self.photoArray[button.tag];
        }
        [self.delegate addImageView:self clickedWithModel:model button:button];
    }
}

/**
 *  删除按钮
 *
 *  @param button button description
 */
- (void)clickDeleteButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(addImageView:deleteWithModel:)]) {
        TTMRealisticModel *model = nil;
        if (self.photoArray.count > button.tag) {
            model = self.photoArray[button.tag];
        }
        [self.delegate addImageView:self deleteWithModel:model];
    }
}

@end

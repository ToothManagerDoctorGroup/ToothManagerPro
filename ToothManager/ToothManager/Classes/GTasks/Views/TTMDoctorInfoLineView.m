//
//  TTMDoctorInfoLineView.m
//  ToothManager
//

#import "TTMDoctorInfoLineView.h"

#define kFontSize 14
#define kTitleColor [UIColor lightGrayColor]
#define kMargin 10.f
#define kMaxTitleW 150.f
#define kMaxTitleH 30.f
#define kLabelH 30.f
#define kMaxContentW (ScreenWidth - 2 * kMargin)
#define kMaxContentH 150.f

@interface TTMDoctorInfoLineView ()

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *content;
@end

@implementation TTMDoctorInfoLineView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kFontSize];
    titleLabel.textColor = kTitleColor;
    CGSize titleSize = [self.title measureFrameWithFont:[UIFont systemFontOfSize:kFontSize]
                                                   size:CGSizeMake(kMaxTitleW, kMaxTitleH)].size;
    titleLabel.frame = CGRectMake(kMargin, 0, titleSize.width + kMargin, kLabelH);
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.numberOfLines = 0;
    CGSize contentSize = [self.content measureFrameWithFont:titleLabel.font
                                                       size:CGSizeMake(kMaxContentW, kMaxContentH)].size;
    [self addSubview:contentLabel];
    if (contentSize.width > (kMaxContentW - titleLabel.width)) {
        contentLabel.frame = CGRectMake(kMargin, kLabelH, contentSize.width, contentSize.height);
    } else {
        contentLabel.frame = CGRectMake(titleLabel.right, 0, (kMaxContentW - titleLabel.width), kLabelH);
    }
    self.size = CGSizeMake(ScreenWidth, contentLabel.bottom);
    
    contentLabel.text = self.content;
    titleLabel.text = [NSString stringWithFormat:@"%@:", self.title];
}
@end

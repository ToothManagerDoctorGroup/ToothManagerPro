//
//  TTMShowTextView.m
//  ToothManager
//

#import "TTMShowTextView.h"

#define kMargin 10.f
#define kFontSize 14

@interface TTMShowTextView ()

@property (nonatomic, copy)   NSString *content;
@end
@implementation TTMShowTextView

- (instancetype)initWithContent:(NSString *)content {
    if (self = [super init]) {
        self.content = content;
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    CGSize contentSize = [self.content measureFrameWithFont:[UIFont systemFontOfSize:kFontSize]
                                    size:CGSizeMake(ScreenWidth - 2 * kMargin, CGFLOAT_MAX)].size;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kFontSize];
    contentLabel.text = self.content;
    contentLabel.numberOfLines = 0;
    contentLabel.origin = CGPointMake(kMargin, kMargin);
    contentLabel.size = contentSize;
    [self addSubview:contentLabel];
    
    self.size = CGSizeMake(ScreenWidth, contentSize.height + 2 * kMargin);
}

@end

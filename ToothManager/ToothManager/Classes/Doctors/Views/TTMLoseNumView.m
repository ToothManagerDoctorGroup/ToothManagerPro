//
//  TTMLoseNumView.m
//  ToothManager
//

#import "TTMLoseNumView.h"
#import "TTMGTaskCellModel.h"

#define kFontSize 18
#define kLabelW 40.f
#define kLabelH kLabelW
#define kMargin 20.f

@interface TTMLoseNumView ()

@property (nonatomic, strong) TTMGTaskCellModel *model;

@end

@implementation TTMLoseNumView

- (instancetype)initWithModel:(TTMGTaskCellModel *)model {
    if (self = [super init]) {
        _model = model;
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:kFontSize];
    numLabel.textColor = MainColor;
    numLabel.layer.borderColor = MainColor.CGColor;
    numLabel.layer.borderWidth = TableViewCellSeparatorHeight;
    numLabel.layer.cornerRadius = kLabelW / 2;
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numLabel];
    
    numLabel.center = CGPointMake(ScreenWidth / 2 - kLabelW / 2, kMargin);
    numLabel.size = CGSizeMake(kLabelW, kLabelH);
    self.size = CGSizeMake(ScreenWidth, kLabelH + 2 * kMargin);
    numLabel.text = [NSString stringWithFormat:@"%@", @(self.model.failure_rate)];
}


@end

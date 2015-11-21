//
//  TTMOperationNumView.m
//  ToothManager
//

#import "TTMOperationNumView.h"
#import "TTMShortContentLineView.h"
#import "TTMGTaskCellModel.h"

@interface TTMOperationNumView ()
@property (nonatomic, strong) TTMGTaskCellModel *model;
@end

@implementation TTMOperationNumView

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
    TTMShortContentLineView *line = [[TTMShortContentLineView alloc] initWithTitle:@"移植手术"
                                     content:[NSString stringWithFormat:@"%@", @(self.model.transplant_operation)]];
    [self addSubview:line];
    self.size = CGSizeMake(ScreenWidth, line.bottom);
}


@end


#import "TTMCompleteApointmentCellModel.h"

#define kLineViewH 80.f
#define kMargin 10.f

@implementation TTMCompleteApointmentCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoList = [NSMutableArray array];
    }
    return self;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = self.infoList.count * kLineViewH + 6 * kMargin;
    }
    return _cellHeight;
}

@end

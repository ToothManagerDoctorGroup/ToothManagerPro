
#import "TTMAppointmentingCellModel.h"

#define kLineViewH 80.f
#define kMargin 10.f
#define kTitleH 44.f

@implementation TTMAppointmentingCellModel

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
        _cellHeight = self.infoList.count * kLineViewH + kMargin + kTitleH;
    }
    return _cellHeight;
}
@end

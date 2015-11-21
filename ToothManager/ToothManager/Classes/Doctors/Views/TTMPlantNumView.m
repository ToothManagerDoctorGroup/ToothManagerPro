//
//  TTMPlantNumView.m
//  ToothManager
//

#import "TTMPlantNumView.h"
#import "TTMShortContentLineView.h"
#import "TTMGTaskCellModel.h"

#define kLineH 30.f

@interface TTMPlantNumView ()

@property (nonatomic, weak) TTMShortContentLineView *frontToothLine; // 前牙
@property (nonatomic, weak) TTMShortContentLineView *behindToothLine; // 后牙
@property (nonatomic, weak) TTMShortContentLineView *oneToothNumLine; // 单颗种植
@property (nonatomic, weak) TTMShortContentLineView *allToothLine; // 全口种植
@property (nonatomic, strong) TTMGTaskCellModel *model;
@end

@implementation TTMPlantNumView

- (instancetype)initWithModel:(TTMGTaskCellModel *)model {
    if (self = [super init]) {
        _model = model;
        [self setup];
    }
    return self;
}
/**
 *  加载子视图
 */
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    TTMShortContentLineView *frontToothLine = [[TTMShortContentLineView alloc] initWithTitle:@"前牙"
                                             content:[NSString stringWithFormat:@"%@", @(self.model.anterior_teeth)]];
    [self addSubview:frontToothLine];
    self.frontToothLine = frontToothLine;
    
    TTMShortContentLineView *behindToothLine = [[TTMShortContentLineView alloc] initWithTitle:@"后牙"
                                             content:[NSString stringWithFormat:@"%@", @(self.model.posterior_teeth)]];
    [self addSubview:behindToothLine];
    self.behindToothLine = behindToothLine;
    
    TTMShortContentLineView *oneToothNumLine = [[TTMShortContentLineView alloc] initWithTitle:@"单颗种植"
                                             content:[NSString stringWithFormat:@"%@", @(self.model.signle_teeth)]];
    [self addSubview:oneToothNumLine];
    self.oneToothNumLine = oneToothNumLine;
    
    TTMShortContentLineView *allToothLine = [[TTMShortContentLineView alloc] initWithTitle:@"全口种植"
                                             content:[NSString stringWithFormat:@"%@", @(self.model.whole_teeth)]];
    [self addSubview:allToothLine];
    self.allToothLine = allToothLine;
    
    CGFloat startX = ScreenWidth / 2;
    frontToothLine.origin = CGPointMake(0, 0);
    behindToothLine.origin = CGPointMake(0, kLineH);
    oneToothNumLine.origin = CGPointMake(startX, 0);
    allToothLine.origin = CGPointMake(startX, kLineH);
    
    self.size = CGSizeMake(ScreenWidth, 2 * kLineH);
}


@end

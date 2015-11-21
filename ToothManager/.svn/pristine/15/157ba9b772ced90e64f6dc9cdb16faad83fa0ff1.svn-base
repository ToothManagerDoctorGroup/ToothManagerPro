//
//  TTMDoctorInfoView.m
//  ToothManager
//

#import "TTMDoctorInfoView.h"
#import "TTMDoctorInfoLineView.h"
#import "TTMDoctorInfoModel.h"

@interface TTMDoctorInfoView ()

@property (nonatomic, strong) TTMDoctorInfoModel *model;

@end

@implementation TTMDoctorInfoView

- (instancetype)initWithModel:(TTMDoctorInfoModel *)model {
    if (self = [super init]) {
        self.model = model;
        [self setup];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    TTMDoctorInfoLineView *sexLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"性别"
                                                                              content:self.model.sex];
    sexLineView.origin = CGPointMake(0, 0);
    [self addSubview:sexLineView];
    
    TTMDoctorInfoLineView *specialLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"擅长项目"
                                                                                  content:self.model.special];
    specialLineView.origin = CGPointMake(0, sexLineView.bottom);
    [self addSubview:specialLineView];
    
    TTMDoctorInfoLineView *introduceLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"个人简介"
                                                                                    content:self.model.introduce];
    introduceLineView.origin = CGPointMake(0, specialLineView.bottom);
    [self addSubview:introduceLineView];
    
//    TTMDoctorInfoLineView *recommandReasonLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"推荐理由"
//                                                                                content:self.model.recommandReason];
//    recommandReasonLineView.origin = CGPointMake(0, introduceLineView.bottom);
//    [self addSubview:recommandReasonLineView];
    
    self.size = CGSizeMake(ScreenWidth, introduceLineView.bottom);
}


@end

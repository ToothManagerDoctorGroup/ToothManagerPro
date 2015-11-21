//
//  TTMScheduleDetailInfoView.m
//  ToothManager
//

#import "TTMScheduleDetailInfoView.h"
#import "TTMScheduleCellModel.h"
#import "TTMDoctorInfoLineView.h"
#import "TTMMaterialModel.h"
#import "TTMAssistModel.h"

@interface TTMScheduleDetailInfoView ()

@property (nonatomic, strong) TTMScheduleCellModel *model;

@end

@implementation TTMScheduleDetailInfoView

- (instancetype)initWithModel:(TTMScheduleCellModel *)model {
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
    
    TTMDoctorInfoLineView *timeLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"时间"
                                                                               content:self.model.reserve_time];
    timeLineView.origin = CGPointMake(0, 0);
    [self addSubview:timeLineView];
    
    TTMDoctorInfoLineView *patientNameView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"患者"
                                                                               content:self.model.patient_name];
    patientNameView.origin = CGPointMake(0, timeLineView.bottom);
    [self addSubview:patientNameView];
    
    TTMDoctorInfoLineView *toothPositionView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"牙位"
                                                                               content:self.model.tooth_position];
    toothPositionView.origin = CGPointMake(0, patientNameView.bottom);
    [self addSubview:toothPositionView];
    
    TTMDoctorInfoLineView *projectlLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"项目"
                                                                                   content:self.model.reserve_type];
    projectlLineView.origin = CGPointMake(0, toothPositionView.bottom);
    [self addSubview:projectlLineView];
    
    NSString *duration = [NSString stringWithFormat:@"%@小时", self.model.reserve_duration];
    TTMDoctorInfoLineView *durationLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"时长"
                                                                                   content:duration];
    durationLineView.origin = CGPointMake(0, projectlLineView.bottom);
    [self addSubview:durationLineView];
    
    TTMDoctorInfoLineView *chairLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"椅位"
                                                                                content:self.model.seat_name];
    chairLineView.origin = CGPointMake(0, durationLineView.bottom);
    [self addSubview:chairLineView];
    
    NSMutableString *materialString = [NSMutableString string];
    for (TTMMaterialModel *material in self.model.materials) {
        if (material == self.model.materials[self.model.materials.count - 1]) {
            [materialString appendFormat:@"%@种植体%@颗", material.mat_name, material.actual_num];
        } else {
            [materialString appendFormat:@"%@种植体%@颗,", material.mat_name, material.actual_num];
        }
    }
    TTMDoctorInfoLineView *materialLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"耗材"
                                                                                content:materialString];
    materialLineView.origin = CGPointMake(0, chairLineView.bottom);
    [self addSubview:materialLineView];
    
    NSMutableString *assistString = [NSMutableString string];
    for (TTMAssistModel *assist in self.model.assists) {
        if (assist == self.model.assists[self.model.assists.count - 1]) {
            [assistString appendFormat:@"%@%@名", assist.assist_name, assist.actual_num];
        } else {
            [assistString appendFormat:@"%@%@名,", assist.assist_name, assist.actual_num];
        }
    }
    TTMDoctorInfoLineView *assistLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"助理"
                                                                                content:assistString];
    assistLineView.origin = CGPointMake(0, materialLineView.bottom);
    [self addSubview:assistLineView];
    
    TTMDoctorInfoLineView *remarkLineView = [[TTMDoctorInfoLineView alloc] initWithTitle:@"备注"
                                                                                content:self.model.remark];
    remarkLineView.origin = CGPointMake(0, assistLineView.bottom);
    [self addSubview:remarkLineView];
    
    self.size = CGSizeMake(ScreenWidth, remarkLineView.bottom);
}

@end

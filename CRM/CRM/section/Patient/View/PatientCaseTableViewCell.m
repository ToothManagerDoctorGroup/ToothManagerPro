//
//  PatientCaseTableViewCell.m
//  CRM
//
//  Created by TimTiger on 2/5/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "PatientCaseTableViewCell.h"
#import "TimImagesScrollView.h"
#import "DBTableMode.h"
#import "DBManager.h"
#import "DBManager+RepairDoctor.h"

@interface PatientCaseTableViewCell () <TimImagesScrollViewDelegate>

@end

@implementation PatientCaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.bounces = NO;
    [self.imageScrollView setImageViewWidth:320];
    self.imageScrollView.showTitle = NO;  //去掉图片上方的title
}

- (void)setImages:(NSArray *)images {
    self.imageScrollView.contentSize = CGSizeMake(320*images.count, 0);
    self.imageScrollView.sdelegate = self;
    NSMutableArray *muarray = [NSMutableArray arrayWithCapacity:0];
    for (CTLib *lib in images) {
        TimImage *image = [[TimImage alloc]init];
        image.url = lib.ct_image;
        image.title = lib.ct_desc;
        [muarray addObject:image];
    }
    [self.imageScrollView setImageArray:muarray];
}
- (void)setMedicalCaseInfomation:(MedicalCase *)medicalcase{
    if (medicalcase.repair_doctor != nil) {
        RepairDoctor *rDoctor = [[DBManager shareInstance] getRepairDoctorWithCkeyId:medicalcase.repair_doctor];
        self.repairDoctorLabel.text = rDoctor.doctor_name;
        if(rDoctor.doctor_name.length == 0){
            self.repairDoctorLabel.text = @"修复医生";
        }else{
            self.repairDoctorLabel.text = [NSString stringWithFormat:@"修复医生:%@",rDoctor.doctor_name];
        }
    }
    self.implantTimeLabel.text = [NSString stringWithFormat:@"种植时间:%@",medicalcase.implant_time];
    if(medicalcase.implant_time.length == 0){
        self.implantTimeLabel.text = [NSString stringWithFormat:@"种植时间"];
    }
    self.repairTimeLabel.text = medicalcase.repair_time;
    self.repairTimeLabel.text = [NSString stringWithFormat:@"修复时间:%@",medicalcase.repair_time];
    if(medicalcase.repair_time.length == 0){
        self.repairTimeLabel.text = [NSString stringWithFormat:@"修复时间"];
    }
    self.reserveTimeLabel.text = medicalcase.next_reserve_time;
    self.reserveTimeLabel.text = [NSString stringWithFormat:@"预约时间:%@",medicalcase.next_reserve_time];
    if(medicalcase.next_reserve_time.length == 0){
        self.reserveTimeLabel.text = [NSString stringWithFormat:@"预约时间"];
    }
    
    if(![NSString isEmptyString:medicalcase.implant_time]){
        NSRange range1 = [medicalcase.implant_time rangeOfString:@" "];
        NSString *string = [medicalcase.implant_time substringToIndex:range1.location];
        self.implantTimeLabel.text = [NSString stringWithFormat:@"种植时间:%@",string];
    }
    if(![NSString isEmptyString:medicalcase.repair_time]){
        NSRange range1 = [medicalcase.repair_time rangeOfString:@" "];
        NSString *string = [medicalcase.repair_time substringToIndex:range1.location];
        //self.repairTimeLabel.text = string;
        self.repairTimeLabel.text = [NSString stringWithFormat:@"修复时间:%@",string];
    }
    if(![NSString isEmptyString:medicalcase.next_reserve_time]){
        NSRange range1 = [medicalcase.next_reserve_time rangeOfString:@" "];
        NSString *string = [medicalcase.next_reserve_time substringToIndex:range1.location];
       // self.reserveTimeLabel.text = string;
        self.reserveTimeLabel.text = [NSString stringWithFormat:@"预约时间:%@",string];
    }
    
}
- (void)imagesScrollView:(TimImagesScrollView *)scrollView didTouchImage:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:)]) {
        [self.delegate didSelectCell:self];
    }
}

@end

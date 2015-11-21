//
//  PatientCaseTableViewCell.h
//  CRM
//
//  Created by TimTiger on 2/5/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"


@class TimImagesScrollView;
@protocol PatientCaseTableViewCellDelegate;
@interface PatientCaseTableViewCell : UITableViewCell

@property (weak, nonatomic) id <PatientCaseTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet TimImagesScrollView *imageScrollView;
- (void)setImages:(NSArray *)images;
- (void)setMedicalCaseInfomation:(MedicalCase *)medicalcase;

@property (weak, nonatomic) IBOutlet UILabel *repairDoctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *implantTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveTimeLabel;

@end

@protocol PatientCaseTableViewCellDelegate <NSObject>

- (void)didSelectCell:(PatientCaseTableViewCell *)cell;

@end

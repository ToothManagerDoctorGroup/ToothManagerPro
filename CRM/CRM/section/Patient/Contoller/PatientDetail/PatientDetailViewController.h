//
//  PatientDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
@class PatientsCellMode;

@protocol PatientDetailViewControllerDelegate <NSObject>

@optional
- (void)didLoadDataSuccessWithModel:(PatientsCellMode *)model;

@end
@interface PatientDetailViewController : TimViewController


@property (nonatomic,retain) PatientsCellMode *patientsCellMode;

@property (nonatomic, weak)id<PatientDetailViewControllerDelegate> delegate;

@end


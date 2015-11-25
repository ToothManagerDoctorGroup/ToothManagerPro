//
//  PatientHeadMedicalRecordView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  患者详情页面上的头视图病历详情页面
 */
@class MedicalCase;
@protocol PatientHeadMedicalRecordViewDelegate <NSObject>

@optional
- (void)didClickAddMedicalButton;
- (void)didClickeditMedicalButtonWithMedicalCase:(MedicalCase *)medicalCase;

@end
@interface PatientHeadMedicalRecordView : UIImageView

@property (nonatomic, strong)NSArray *medicalCases;

@property (nonatomic, strong)MedicalCase *selectCase;

@property (nonatomic, weak)id<PatientHeadMedicalRecordViewDelegate> delegate;

@end

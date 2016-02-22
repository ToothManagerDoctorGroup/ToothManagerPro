//
//  EditPatientDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
#import "TimPickerTextField.h"

@class Patient;
@interface EditPatientDetailViewController : TimDisplayViewController


@property (nonatomic,retain) Patient *patient;
@property (weak, nonatomic) IBOutlet UILabel *patientNameField;
@property (weak, nonatomic) IBOutlet UILabel *patientPhoneField;
@property (weak, nonatomic) IBOutlet UILabel *patientGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientAgeField;
@property (weak, nonatomic) IBOutlet UILabel *patientIdCardField;
@property (weak, nonatomic) IBOutlet UILabel *patientAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergyLabel;
@property (weak, nonatomic) IBOutlet UILabel *anamnesisLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLabel;

@property (nonatomic, assign)BOOL isGroup;//是从分组跳转

@end

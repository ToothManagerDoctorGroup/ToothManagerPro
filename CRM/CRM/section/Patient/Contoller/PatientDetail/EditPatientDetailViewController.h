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
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientPhoneField;
@property (weak, nonatomic) IBOutlet UILabel *patientGenderLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UITextField *patientIdCardField;
@property (weak, nonatomic) IBOutlet UITextField *patientAddressField;
@property (weak, nonatomic) IBOutlet UILabel *allergyLabel;
@property (weak, nonatomic) IBOutlet UILabel *anamnesisLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkNameLabel;

@property (nonatomic, assign)BOOL isGroup;//是从分组跳转

@end

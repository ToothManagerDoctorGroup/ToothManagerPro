//
//  EditPatientDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

@class Patient;
@interface EditPatientDetailViewController : TimDisplayViewController


@property (nonatomic,retain) Patient *patient;
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientPhoneField;
@property (weak, nonatomic) IBOutlet UITextField *patientGenderLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UITextField *patientIdCardField;
@property (weak, nonatomic) IBOutlet UITextField *patientAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *allergyLabel;
@property (weak, nonatomic) IBOutlet UITextField *anamnesisLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarkNameLabel;

@property (nonatomic, assign)BOOL isGroup;//是从分组跳转

@end

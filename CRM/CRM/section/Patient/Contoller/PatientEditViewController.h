//
//  PatientEditViewController.h
//  CRM
//
//  Created by lsz on 15/7/8.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "TimPickerTextField.h"

@interface PatientEditViewController : TimViewController

@property (nonatomic,retain) PatientsCellMode *patientsCellMode;

@property (weak, nonatomic) IBOutlet TimPickerTextField *patientNameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *patientPhoneTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *introducerNameTextField;

@end

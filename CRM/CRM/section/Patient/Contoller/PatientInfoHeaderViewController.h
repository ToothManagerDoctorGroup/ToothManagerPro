//
//  PatientInfoHeaderViewController.h
//  CRM
//
//  Created by TimTiger on 10/23/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimPickerTextField;
@interface PatientInfoHeaderViewController : UITableViewController

@property (weak, nonatomic) IBOutlet TimPickerTextField *patientNameLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *patientPhoneLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *introducerNameLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *transferTextField;


@end

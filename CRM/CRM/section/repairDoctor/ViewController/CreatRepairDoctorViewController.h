//
//  CreatRepairDoctorViewController.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
#import "TimPickerTextField.h"
#import "TimPickerView.h"

@interface CreatRepairDoctorViewController : TimTableViewController

@property (nonatomic,readwrite) BOOL edit;
@property (nonatomic,copy) NSString *repairDoctorId;
@property (strong, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (strong, nonatomic) IBOutlet TimPickerTextField *phoneTextField;

@end

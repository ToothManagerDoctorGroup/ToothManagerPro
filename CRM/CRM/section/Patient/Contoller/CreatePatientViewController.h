//
//  CreatePatientViewController.h
//  CRM
//
//  Created by mac on 14-5-16.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimFramework.h"
#import "TimPickerTextField.h"


@interface CreatePatientViewController : TimTableViewController
{

}

@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *introducerTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *phoneTextField;


//当该界面充当编辑患者界面时，需要设置patientid
@property (nonatomic,copy) NSString *patientId;
@property (nonatomic,readwrite) BOOL edit;

@end

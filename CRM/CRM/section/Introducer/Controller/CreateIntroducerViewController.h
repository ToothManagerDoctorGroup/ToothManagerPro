//
//  CreateIntroducerViewController.h
//  CRM
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimFramework.h"
#import "TimPickerView.h"
#import "TimStarTextField.h"

@interface CreateIntroducerViewController : TimTableViewController
{
    
}

@property (nonatomic,readwrite) BOOL edit;
@property (nonatomic,copy) NSString *introducerId;
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (weak, nonatomic) IBOutlet TimStarTextField *starTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *phoneTextField;

@end

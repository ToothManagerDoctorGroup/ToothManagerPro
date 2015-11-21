//
//  RepairDocHeaderTableViewController.h
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimPickerTextField.h"

@interface RepairDocHeaderTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet TimPickerTextField *nameTextField;
@property (strong, nonatomic) IBOutlet TimPickerTextField *phoneTextField;
@property (strong,nonatomic) UIImageView *iconImageView;
@end

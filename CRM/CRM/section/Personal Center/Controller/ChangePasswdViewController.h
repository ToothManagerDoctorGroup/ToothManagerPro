//
//  ChangePasswdViewController.h
//  CRM
//
//  Created by TimTiger on 9/7/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

@interface ChangePasswdViewController : TimTableViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldpasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkpassedTextField;
- (IBAction)updateProfileAction:(id)sender;

@end

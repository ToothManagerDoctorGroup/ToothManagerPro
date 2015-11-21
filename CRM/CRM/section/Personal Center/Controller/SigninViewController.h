//
//  SigninViewController.h
//  CRM
//
//  Created by TimTiger on 14-9-4.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"

@interface SigninViewController : TimTableViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *storepasswdButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

- (IBAction)signinAction:(id)sender;
- (IBAction)misspasswdAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)storepasswdAction:(id)sender;

@end

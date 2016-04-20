//
//  XLSignUpViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  注册页面
 */
@class JKCountDownButton;
@interface XLSignUpViewController : TimTableViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (strong, nonatomic) IBOutlet UITextField *recommenderTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *validateButton;

- (IBAction)signupAction:(id)sender;
- (IBAction)readlisenseAction:(id)sender;
@end

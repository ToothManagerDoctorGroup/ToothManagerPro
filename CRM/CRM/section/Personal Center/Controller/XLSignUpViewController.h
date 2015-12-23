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
@interface XLSignUpViewController : TimTableViewController{
    NSTimer *myTimer;
    int timeCount;
}
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *lisensebutton;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (strong, nonatomic) IBOutlet UITextField *recommenderTextField;
@property (weak, nonatomic) IBOutlet UIButton *validateButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)signupAction:(id)sender;
- (IBAction)lisenseAction:(id)sender;
- (IBAction)readlisenseAction:(id)sender;
@end

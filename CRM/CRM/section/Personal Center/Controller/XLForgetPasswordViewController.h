//
//  XLForgetPasswordViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  忘记密码
 */
@class JKCountDownButton;
@interface XLForgetPasswordViewController : TimTableViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *validateButton;

@end

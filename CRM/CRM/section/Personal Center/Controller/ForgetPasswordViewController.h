//
//  ForgetPasswordViewController.h
//  CRM
//
//  Created by lsz on 15/7/1.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"

@interface ForgetPasswordViewController : TimViewController{
    NSTimer *myTimer;
    int timeCount;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (weak, nonatomic) IBOutlet UIButton *validateButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

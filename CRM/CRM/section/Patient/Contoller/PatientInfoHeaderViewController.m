//
//  PatientInfoHeaderViewController.m
//  CRM
//
//  Created by TimTiger on 10/23/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientInfoHeaderViewController.h"
#import "TimPickerTextField.h"

@interface PatientInfoHeaderViewController () <UITabBarDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation PatientInfoHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.patientNameLabel.mode = TextFieldInputModeKeyBoard;
    self.patientNameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.patientNameLabel setBorderStyle:UITextBorderStyleNone];
    self.patientPhoneLabel.mode = TextFieldInputModeKeyBoard;
    [self.patientPhoneLabel setBorderStyle:UITextBorderStyleNone];
    self.patientPhoneLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.patientPhoneLabel.keyboardType = UIKeyboardTypeNumberPad;
    self.introducerNameLabel.mode = TextFieldInputModeExternal;
    self.introducerNameLabel.delegate = self;
    self.introducerNameLabel.borderStyle = UITextBorderStyleNone;
    
    self.transferTextField.mode = TextFieldInputModeExternal;
    self.transferTextField.delegate = self;
    self.transferTextField.borderStyle = UITextBorderStyleNone;
    self.transferTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.transferTextField.enabled = NO;
    /*
    self.introducerNameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.introducerNameLabel.enabled = NO;
     */
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.introducerNameLabel) {
        [self.patientPhoneLabel resignFirstResponder];
        [self.patientNameLabel resignFirstResponder];
    }
    return YES;
}
- (IBAction)tel:(id)sender {
    if(![NSString isEmptyString:self.patientPhoneLabel.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"患者未留电话"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
            
        }else{
            NSString *number = self.patientPhoneLabel.text;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
//    self.createCaseButton.layer.cornerRadius = 18.0f;
}



@end
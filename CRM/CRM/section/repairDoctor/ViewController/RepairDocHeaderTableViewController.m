//
//  RepairDocHeaderTableViewController.m
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "RepairDocHeaderTableViewController.h"
#import "AvatarView.h"

@interface RepairDocHeaderTableViewController ()
@property (nonatomic,retain) AvatarView *avatar;
@end

@implementation RepairDocHeaderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsSelection = NO;
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    
//    _avatar = [[AvatarView alloc] initWithURLString:@""];
//    _avatar.frame = CGRectMake(20, 14, 60, 60);
//    [self.view addSubview:_avatar];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 60, 60)];
    [self.view addSubview:self.iconImageView];
}

- (IBAction)tel:(id)sender {
    if(![NSString isEmptyString:self.phoneTextField.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"未找到修复医生电话"];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
            
        }else{
            NSString *number = self.phoneTextField.text;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RepairDocHeaderTableViewController.m
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "RepairDocHeaderTableViewController.h"
#import "AvatarView.h"
#import "XLAvatarBrowser.h"
#import "UIColor+Extension.h"

@interface RepairDocHeaderTableViewController ()
@property (nonatomic,retain) AvatarView *avatar;
@end

@implementation RepairDocHeaderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 60, 60)];
    self.iconImageView.image = [UIImage imageNamed:@"user_icon"];
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.iconImageView addGestureRecognizer:tap];
    [self.view addSubview:self.iconImageView];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [XLAvatarBrowser showImage:self.iconImageView];
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

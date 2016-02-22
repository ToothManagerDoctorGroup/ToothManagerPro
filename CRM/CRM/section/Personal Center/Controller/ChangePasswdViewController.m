//
//  ChangePasswdViewController.m
//  CRM
//
//  Created by TimTiger on 9/7/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "ChangePasswdViewController.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "SVProgressHUD.h"

@interface ChangePasswdViewController () <CRMHttpRequestPersonalCenterDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ChangePasswdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"更改密码";
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.oldpasswdTextField becomeFirstResponder];
}

-(void)viewTapped{
    [self.oldpasswdTextField resignFirstResponder];
    [self.newpasswdTextField resignFirstResponder];
    [self.checkpassedTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateProfileAction:(id)sender {
    
    [[AccountManager shareInstance]updatePasswdWithOldpwd:self.oldpasswdTextField.text newpwd:self.newpasswdTextField.text comfirmPwd:self.checkpassedTextField.text userId:[AccountManager shareInstance].currentUser.userid successBlock:^{
        [SVProgressHUD showWithStatus:@"正在修改..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showTextWithStatus:error.localizedDescription];
    }];
}

#pragma mark - CRMHttpRequestPersonalCenterDelegate
- (void)updatePasswdSucessWithResult:(NSDictionary *)result {
    [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    [self popViewControllerAnimated:YES];
}

- (void)updatePasswdFailedWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end

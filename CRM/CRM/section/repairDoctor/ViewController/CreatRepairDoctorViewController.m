//
//  CreatRepairDoctorViewController.m
//  CRM
//
//  Created by doctor on 15/4/24.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "CreatRepairDoctorViewController.h"
#import "CRMMacro.h"
#import "DBManager+RepairDoctor.h"
#import "PickerTextTableViewCell.h"

@interface CreatRepairDoctorViewController ()

@property (nonatomic,readonly) RepairDoctor *repairDoctor;

@end

@implementation CreatRepairDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self.tableView setAllowsSelection:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.edit) {
        self.title = @"编辑修复医生";
    } else {
        self.title = @"添加修复医生";
    }
    
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initData {
    [super initData];
    _repairDoctor = [[RepairDoctor alloc]init];
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    if ([NSString isEmptyString:self.nameTextField.text]) {
        [SVProgressHUD  showImage:nil status:@"医生名称不能为空"];
        return;
    }
    if ([NSString isEmptyString:self.phoneTextField.text]) {
        [SVProgressHUD  showImage:nil status:@"医生电话不能为空"];
        return;
    }
    self.repairDoctor.doctor_name = self.nameTextField.text;
    self.repairDoctor.doctor_phone = self.phoneTextField.text;
    self.repairDoctor.data_flag = @"0";
    BOOL ret = [[DBManager shareInstance] insertRepairDoctor:self.repairDoctor];
    NSString *message = nil;
    if (ret) {
        if (self.edit) {
            message = @"修改成功";
            [self postNotificationName:RepairDoctorEditedNotification object:nil];
        } else {
            message = @"创建成功";
            [self postNotificationName:RepairDoctorCreatedNotification object:nil];
        }
        [self.view makeToast:message duration:1.0f position:@"Center"];
        [self popViewControllerAnimated:YES];
    } else {
        if (self.edit) {
            message = @"修改失败";
        } else {
            message = @"创建失败";
        }
        [self.view makeToast:message duration:1.0f position:@"Center"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

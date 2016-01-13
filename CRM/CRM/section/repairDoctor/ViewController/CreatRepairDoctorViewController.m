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
#import "JSONKit.h"
#import "MJExtension.h"
#import "DBManager+AutoSync.h"

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
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD  showImage:nil status:@"电话号码无效，请重新输入"];
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
            //自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_RepairDoctor postType:Update dataEntity:[self.repairDoctor.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            
            [self postNotificationName:RepairDoctorEditedNotification object:nil];
        } else {
            message = @"创建成功";
            
            //获取修复医生信息
            RepairDoctor *tempRepairDoc = [[DBManager shareInstance] getRepairDoctorWithCkeyId:self.repairDoctor.ckeyid];
            if (tempRepairDoc != nil) {
                //自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_RepairDoctor postType:Insert dataEntity:[tempRepairDoc.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                [self postNotificationName:RepairDoctorCreatedNotification object:nil];
            }
            
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

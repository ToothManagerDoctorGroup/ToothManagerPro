//
//  XLPersonalStepOneViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/22.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLPersonalStepOneViewController.h"
#import "XLPersonalStepTwoViewController.h"
#import "TimPickerTextField.h"

@interface XLPersonalStepOneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel; //步骤1
@property (weak, nonatomic) IBOutlet UILabel *step2CountLabel;//步骤2
@property (weak, nonatomic) IBOutlet UITextField *userNameField;//姓名
@property (weak, nonatomic) IBOutlet TimPickerTextField *hospitalNameField;//医院
@property (weak, nonatomic) IBOutlet TimPickerTextField *departmentField;//科室
@property (weak, nonatomic) IBOutlet TimPickerTextField *professionalField;//职称
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;//下一步按钮

@end

@implementation XLPersonalStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息完善";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:nil];
    
    //设置控件属性
    [self setViewAttr];
    
    
}
- (void)onBackButtonAction:(id)sender{}

#pragma mark - 设置控件属性
- (void)setViewAttr{
    self.stepCountLabel.layer.cornerRadius = 12;
    self.stepCountLabel.layer.masksToBounds = YES;
    self.step2CountLabel.layer.cornerRadius = 12;
    self.step2CountLabel.layer.masksToBounds = YES;
    
    self.step2CountLabel.layer.borderWidth = 1;
    self.step2CountLabel.layer.borderColor = [MyColor(187, 187, 187) CGColor];
    
    self.nextStepButton.layer.cornerRadius = 5;
    self.nextStepButton.layer.masksToBounds = YES;
    
    NSMutableArray *selectRepeatArray2 = [NSMutableArray arrayWithObjects:@"口腔综合科",@"口腔科",@"正畸科",@"儿童口腔科",@"颌面外科",@"牙周科",@"牙体牙髓科",@"口腔黏膜科",@"种植科",@"口腔预防科",@"其他", nil];
    self.departmentField.mode = TextFieldInputModePicker;
    self.departmentField.pickerDataSource = selectRepeatArray2;
    
    NSMutableArray *selectRepeatArray1 = [NSMutableArray arrayWithObjects:@"医师",@"主治医师",@"副主任医师",@"主任医师", nil];
    self.professionalField.mode = TextFieldInputModePicker;
    self.professionalField.pickerDataSource = selectRepeatArray1;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 下一步
- (IBAction)nextStepAction:(id)sender {
    if (self.userNameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
        return;
    }
    if (self.hospitalNameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"职业医院不能为空"];
        return;
    }
    if (self.departmentField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"科室不能为空"];
        return;
    }
    if (self.professionalField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"职称不能为空"];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    XLPersonalStepTwoViewController *twoVc = [storyboard instantiateViewControllerWithIdentifier:@"XLPersonalStepTwoViewController"];
    twoVc.userName = self.userNameField.text;
    twoVc.hospitalName = self.hospitalNameField.text;
    twoVc.departMentName = self.departmentField.text;
    twoVc.professionalName = self.professionalField.text;
    [self.navigationController pushViewController:twoVc animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

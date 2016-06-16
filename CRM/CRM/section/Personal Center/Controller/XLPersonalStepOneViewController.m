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
#import "XLDataSelectViewController.h"

@interface XLPersonalStepOneViewController ()<XLDataSelectViewControllerDelegate,XLPersonalStepTwoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel; //步骤1
@property (weak, nonatomic) IBOutlet UILabel *step2CountLabel;//步骤2
@property (weak, nonatomic) IBOutlet TimPickerTextField *userNameField;//姓名
@property (weak, nonatomic) IBOutlet TimPickerTextField *hospitalNameField;//医院
@property (weak, nonatomic) IBOutlet TimPickerTextField *departmentField;//科室
@property (weak, nonatomic) IBOutlet TimPickerTextField *professionalField;//职称
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;//下一步按钮

@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *age;
@property (nonatomic, copy)NSString *degree;

@end

@implementation XLPersonalStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息完善";
    [self setBackBarButtonWithImage:nil];
    
    //设置控件属性
    [self setViewAttr];
}

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
    
    NSMutableArray *selectRepeatArray2 = [NSMutableArray arrayWithObjects:@"口腔科",@"颌面外科",@"修复科",@"种植科",@"正畸科",@"牙体牙髓科",@"牙周科",@"口腔黏膜科",@"儿童口腔科",@"口腔综合科",@"特诊科",@"特需科",@"口腔预防科",@"老年口腔科",@"关节科",@"急诊科",@"其它", nil];
    self.departmentField.mode = TextFieldInputModePicker;
    self.departmentField.pickerDataSource = selectRepeatArray2;
    
    NSMutableArray *selectRepeatArray1 = [NSMutableArray arrayWithObjects:@"医师",@"主治医师",@"副主任医师",@"主任医师", nil];
    self.professionalField.mode = TextFieldInputModePicker;
    self.professionalField.pickerDataSource = selectRepeatArray1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
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
    
    if ([self.userNameField.text charaterCount] > 32) {
        [SVProgressHUD showErrorWithStatus:@"姓名过长"];
        return;
    }
    
    if (self.hospitalNameField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"医院不能为空"];
        return;
    }
    //判断输入的姓名的长度是否合格
    if ([self.hospitalNameField.text charaterCount] > 100) {
        [SVProgressHUD showImage:nil status:@"医院名称过长，请重新输入"];
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
    twoVc.delegate = self;
    twoVc.userName = self.userNameField.text;
    twoVc.hospitalName = self.hospitalNameField.text;
    twoVc.departMentName = self.departmentField.text;
    twoVc.professionalName = self.professionalField.text;
    twoVc.sex = self.sex;
    twoVc.age = self.age;
    twoVc.degree = self.degree;
    [self pushViewController:twoVc animated:YES];
}

#pragma mark - 键盘监听事件
- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    
    if ([self.departmentField isFirstResponder]) {
        [self.departmentField resignFirstResponder];
        
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerDepartment;
        dataSelectVc.currentContent = self.departmentField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
    }else if ([self.professionalField isFirstResponder]){
        [self.professionalField resignFirstResponder];
        
        XLDataSelectViewController *dataSelectVc = [[XLDataSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        dataSelectVc.type = XLDataSelectViewControllerProfressional;
        dataSelectVc.currentContent = self.professionalField.text;
        dataSelectVc.delegate = self;
        [self pushViewController:dataSelectVc animated:YES];
        
    }
    flag = NO;
}

#pragma mark - XLDataSelectViewControllerDelegate
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type{
    if (type == XLDataSelectViewControllerDepartment) {
        self.departmentField.text = content;
    }else if (type == XLDataSelectViewControllerProfressional){
        self.professionalField.text = content;
    }
}

#pragma mark -XLPersonalStepTwoViewControllerDelegate
- (void)personalStepTwoVC:(XLPersonalStepTwoViewController *)stepOneVc didWriteAge:(NSString *)age sex:(NSString *)sex degree:(NSString *)degree{
    self.age = age;
    self.sex = sex;
    self.degree = degree;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

//
//  XLCreatePatientViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLCreatePatientViewController.h"
#import "TimPickerTextField.h"
#import "DBManager+Patients.h"
#import "CRMUserDefalut.h"
#import "AddressBoolTool.h"
#import "DBTableMode.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "UIView+Toast.h"
#import "DBManager+Introducer.h"
#import "PatientDetailViewController.h"
#import "XLIntroducerViewController.h"
#import "DoctorGroupModel.h"
#import "DoctorGroupTool.h"
#import "GroupMemberEntity.h"

@interface XLCreatePatientViewController ()<XLIntroducerViewControllerDelegate>{
    Introducer *selectIntroducer;
    Patient *patient;
}
@property (weak, nonatomic) IBOutlet TimPickerTextField *nameField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *phoneField;
@property (weak, nonatomic) IBOutlet UILabel *intrNameLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *nickNameField;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (nonatomic, strong)NSArray *currentGroups;

@end

@implementation XLCreatePatientViewController

-(void)dealloc{
    selectIntroducer = nil;
    patient = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initView
{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.title = @"手工录入患者";
    
    self.nameField.mode = TextFieldInputModeKeyBoard;
    self.nameField.clearButtonMode = UITextFieldViewModeNever;
    
    self.nickNameField.mode = TextFieldInputModeKeyBoard;
    self.nickNameField.clearButtonMode = UITextFieldViewModeNever;
    
    self.phoneField.mode = TextFieldInputModeKeyBoard;
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.clearButtonMode = UITextFieldViewModeNever;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped{
    [self.nameField resignFirstResponder];
    [self.phoneField resignFirstResponder];
}
- (void)initData
{
    [super initData];
    //创建患者
    patient = [[Patient alloc] init];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //判断是否显示提醒框
    NSString *isShow = [CRMUserDefalut objectForKey:AddressBook_IsShowKey];
    if (isShow == nil) {
        isShow = Auto_Action_Open;
        [CRMUserDefalut setObject:Auto_Action_Open forKey:AddressBook_IsShowKey];
    }
    if ([isShow isEqualToString:Auto_Action_Open]) {
        //判断当前用户是否开启通讯录权限
        BOOL canShow = [[AddressBoolTool shareInstance] userAllowToAddress];
        if (!canShow) {
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"温馨提示" message:@"种牙管家没有访问手机通讯录的权限，请到系统设置->隐私->通讯录中开启；开启后患者来电即可看到ta的CT片和治疗情况" cancel:@"确定" certain:@"不再提醒" cancelHandler:^{
            } comfirmButtonHandlder:^{
                [CRMUserDefalut setObject:Auto_Action_Close forKey:AddressBook_IsShowKey];
            }];
            [alertView show];
        }
    }
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if(self.nameField.text.length == 0){
        [SVProgressHUD showImage:nil status:@"请输入患者姓名"];
        return;
    }
    if ([self.nameField.text charaterCount] > 32) {
        [SVProgressHUD showImage:nil status:@"患者姓名过长"];
        return;
    }
    
    if(self.phoneField.text.length == 0 || ![NSString checkAllPhoneNumber:self.phoneField.text]){
        [SVProgressHUD showImage:nil status:@"手机号无效，请重新输入"];
        return;
    }
    
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    
    patient.patient_name = self.nameField.text;
    patient.patient_phone = self.phoneField.text;
    patient.nickName = self.nickNameField.text;
    patient.patient_age = @"0";
    patient.patient_gender = @"2";
    
    if (selectIntroducer && selectIntroducer.ckeyid) {
        patient.introducer_id = selectIntroducer.ckeyid;
    }
    
    if([[DBManager shareInstance] patientIsExist:patient]){
        [SVProgressHUD showImage:nil status:@"手机号已存在，请重新输入"];
        return;
    }
    
    if (![patient.patient_name isEmpty] && ![patient.patient_phone isEmpty]){
        NSString * message = nil;
        if ([[DBManager shareInstance] insertPatient:patient]) {
            
            Patient *tempPatient = [[DBManager shareInstance] getPatientCkeyid:patient.ckeyid];
            if (tempPatient != nil) {
                //添加自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Insert dataEntity:[tempPatient.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                /*
                //添加分组的自动同步信息
                if (self.currentGroups.count > 0) {
                    NSMutableArray *selectMemberArr = [NSMutableArray array];
                    for (DoctorGroupModel *group in self.currentGroups) {
                        //新增患者
                        GroupMemberEntity *member = [[GroupMemberEntity alloc] initWithGroupName:group.group_name groupId:group.ckeyid doctorId:group.doctor_id patientId:tempPatient.ckeyid patientName:tempPatient.patient_name ckeyId:group.ckeyid];
                        [selectMemberArr addObject:member.keyValues];
                    }
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_AddPatientToGroups postType:Insert dataEntity:[selectMemberArr JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                }
                 */
            }
            //如果是创建患者界面
            message = @"新建患者成功";
            if (selectIntroducer!= nil && self.intrNameLabel.text.length > 0) {
                //新建介绍人，添加到本地数据库同时保存自动同步信息
                PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
                map.intr_id = selectIntroducer.ckeyid;
                map.intr_source = @"B";
                map.patient_id = patient.ckeyid;
                map.doctor_id = [AccountManager shareInstance].currentUser.userid;
                map.intr_time = [NSString currentDateString];
                if([[DBManager shareInstance] insertPatientIntroducerMap:map]){
                    //获取患者介绍人信息
                    PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:map.patient_id doctorId:map.doctor_id intrId:map.intr_id];
                    if (tempMap != nil) {
                        //添加自动同步信息
                        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
                        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                    }
                }
            }
            
            //周知各vc 创建了新患者
            [self postNotificationName:PatientCreatedNotification object:nil];
            //将患者插入手机通讯录
            [self savePatientPhontToAddressBookWithPatient:patient];
            
            //跳转到患者详细信息页面
            PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
            PatientsCellMode *model = [[PatientsCellMode alloc] init];
            model.patientId = patient.ckeyid;
            detailVc.patientsCellMode = model;
            detailVc.isNewPatient = YES;
            [self pushViewController:detailVc animated:YES];
            
        } else {
            //如果是创建患者界面
            message = @"新建患者失败";
            [self.view makeToast:message duration:1.0f position:@"Center"];
        }
    } else {
        [self.view makeToast:@"请填入患者完整信息" duration:1.0f position:@"Center"];
    }
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            XLIntroducerViewController *introducerVC = [[XLIntroducerViewController alloc] init];
            introducerVC.delegate = self;
            introducerVC.Mode = IntroducePersonViewSelect;
            [self pushViewController:introducerVC animated:YES];
        }
    }
}


#pragma mark - IntroducePersonViewController Delegate
- (void)didSelectedIntroducer:(Introducer *)intro {
    selectIntroducer = nil;
    selectIntroducer = [Introducer intoducerFromIntro:intro];
    self.intrNameLabel.text = selectIntroducer.intr_name;
}

#pragma mark - 将新建的患者保存到通讯录
- (void)savePatientPhontToAddressBookWithPatient:(Patient *)patientTmp{
    //判断设置里面的开关是否打开
    NSString *open = [CRMUserDefalut objectForKey:PatientToAddressBookKey];
    if (open == nil) {
        //默认开启
        open = Auto_Action_Open;
        [CRMUserDefalut setObject:open forKey:PatientToAddressBookKey];
    }
    if ([open isEqualToString:Auto_Action_Open]) {
        [[AddressBoolTool shareInstance] addContactToAddressBook:patientTmp];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

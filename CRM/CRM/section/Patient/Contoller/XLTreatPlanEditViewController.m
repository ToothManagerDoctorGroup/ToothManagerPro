//
//  XLTreatPlanEditViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanEditViewController.h"
#import "XLHengYaViewController.h"
#import "XLRuYaViewController.h"
#import "XLReserveTypesViewController.h"
#import "XLDoctorLibraryViewController.h"
#import "TimPickerTextField.h"
#import "DBTableMode.h"
#import "XLTeamTool.h"
#import "XLCureProjectParam.h"
#import "AccountManager.h"
#import "XLCommonEditViewController.h"
#import "XLTeamMemberParam.h"
#import "MJExtension.h"

@interface XLTreatPlanEditViewController ()<XLHengYaDeleate,XLRuYaDelegate,XLReserveTypesViewControllerDelegate,XLDoctorLibraryViewControllerDelegate,XLCommonEditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *toothLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *timeField;

@property (nonatomic,retain) XLHengYaViewController *hengYaVC;
@property (nonatomic,retain) XLRuYaViewController *ruYaVC;

@property (nonatomic, strong)Doctor *selectDoc;//当前选中的医生

@end

@implementation XLTreatPlanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加治疗方案";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    
    self.timeField.mode = TextFieldInputModeDatePicker;
    self.timeField.dateMode = TextFieldDateModeDate;
    self.timeField.isBirthDay = YES;
    self.timeField.clearButtonMode = UITextFieldViewModeNever;
    
}

- (void)onRightButtonAction:(id)sender{
    
    if (![self.typeLabel.text isNotEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请填写治疗事项"];
        return;
    }
    //判断是否选择了治疗医生
    NSNumber *therapistId = nil;
    NSString *therapistName = nil;
    if (self.selectDoc == nil) {
        therapistId = @([[AccountManager currentUserid] integerValue]);
        therapistName = [AccountManager shareInstance].currentUser.name;
    }else{
        therapistId = @([self.selectDoc.ckeyid integerValue]);
        therapistName = self.selectDoc.doctor_name;
    }
    
    //创建治疗方案
    [SVProgressHUD showWithStatus:@"正在创建"];
    __weak typeof(self) weakSelf = self;
    XLCureProjectParam *param = [[XLCureProjectParam alloc] initWithCaseId:self.mCase.ckeyid patientId:self.mCase.patient_id therapistId:therapistId therapistName:therapistName toothPosition:self.toothLabel.text medicalItem:self.typeLabel.text endDate:self.timeField.text goldCount:@(0) status:@(0)];
    [XLTeamTool addNewCureProWithParam:param success:^(XLCureProjectModel *model) {
        //将医生插入到群组中，同时设置为治疗医生
        XLTeamMemberParam *param = [[XLTeamMemberParam alloc] initWithCaseId:weakSelf.mCase.ckeyid patientId:weakSelf.mCase.patient_id teamNickName:@"" memberId:@([weakSelf.selectDoc.ckeyid integerValue]) nickName:@"" memberName:weakSelf.selectDoc.doctor_name isConsociation:YES createUserId:@([[AccountManager currentUserid] integerValue])];
        [XLTeamTool addTeamMemberWithArray:@[param.keyValues] success:^(CRMHttpRespondModel *respond) {} failure:^(NSError *error) {}];
        
        [SVProgressHUD showSuccessWithStatus:@"治疗方案创建成功"];
        [weakSelf postNotificationName:TreatePlanAddNotification object:nil];
        [weakSelf popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"治疗方案创建失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

    #pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.timeField isFirstResponder]) {
        [self.timeField resignFirstResponder];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //牙位
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
            self.hengYaVC.delegate = self;
            self.hengYaVC.hengYaString = self.toothLabel.text;
            [self.navigationController addChildViewController:self.hengYaVC];
            [self.navigationController.view addSubview:self.hengYaVC.view];
            
        }else if (indexPath.row == 1){
            //填写治疗项目
            XLCommonEditViewController *editVc = [[XLCommonEditViewController alloc] init];
            editVc.placeHolder = @"请填写治疗事项";
            editVc.rightButtonTitle = @"确定";
            editVc.delegate = self;
            editVc.content = self.typeLabel.text;
            [self pushViewController:editVc animated:YES];
            
        }else if (indexPath.row == 2){
            //分配给
            //选择治疗医生
            XLDoctorLibraryViewController *docLibrary = [[XLDoctorLibraryViewController alloc] init];
            docLibrary.isTherapyDoctor = YES;
            docLibrary.delegate = self;
            [self pushViewController:docLibrary animated:YES];
        }else{
            //截止时间
            [self.timeField becomeFirstResponder];
        }
    }
}

#pragma mark - XLReserveTypesViewControllerDelegate
- (void)reserveTypesViewController:(XLReserveTypesViewController *)vc didSelectReserveType:(NSString *)type{
    self.typeLabel.text = type;
}

#pragma mark - XLDoctorLibraryViewControllerDelegate
- (void)doctorLibraryVc:(XLDoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor{
    self.nameLabel.text = doctor.doctor_name;
    self.selectDoc = doctor;
}

#pragma mark - XLCommonEditViewControllerDelegate
- (void)commonEditViewController:(XLCommonEditViewController *)editVc content:(NSString *)content title:(NSString *)title{
    self.typeLabel.text = content;
}

#pragma mark - 选择牙位
-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothLabel.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.toothLabel.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.toothLabel.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.toothLabel.text = toothStr;
    }
    [self removeRuYaVC];
}

-(void)removeRuYaVC{
    [self.ruYaVC willMoveToParentViewController:nil];
    [self.ruYaVC.view removeFromSuperview];
    [self.ruYaVC removeFromParentViewController];
}
-(void)changeToRuYaVC{
    [self removeHengYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLRuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.toothLabel.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.toothLabel.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

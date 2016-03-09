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

@interface XLTreatPlanEditViewController ()<XLHengYaDeleate,XLRuYaDelegate,XLReserveTypesViewControllerDelegate,XLDoctorLibraryViewControllerDelegate>
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
    [self setRightBarButtonWithTitle:@"完成"];
    
    self.timeField.mode = TextFieldInputModeDatePicker;
    self.timeField.dateMode = TextFieldDateModeDate;
    self.timeField.isBirthDay = YES;
    self.timeField.clearButtonMode = UITextFieldViewModeNever;
    
}

- (void)onRightButtonAction:(id)sender{
    //创建治疗方案
    [SVProgressHUD showWithStatus:@"正在创建"];
    XLCureProjectParam *param = [[XLCureProjectParam alloc] initWithCaseId:self.mCase.ckeyid patientId:self.mCase.patient_id therapistId:@([self.selectDoc.ckeyid integerValue]) therapistName:self.selectDoc.doctor_name toothPosition:self.toothLabel.text medicalItem:self.typeLabel.text endDate:self.timeField.text goldCount:@(0) status:@(0)];
    [XLTeamTool addNewCureProWithParam:param success:^(XLCureProjectModel *model) {
        [SVProgressHUD showSuccessWithStatus:@"治疗方案创建成功"];
        [self postNotificationName:TreatePlanAddNotification object:nil];
        [self popViewControllerAnimated:YES];
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
            //选择治疗项目
            XLReserveTypesViewController *reserceVC = [[XLReserveTypesViewController alloc] initWithStyle:UITableViewStylePlain];
            reserceVC.reserve_type = self.typeLabel.text;
            reserceVC.delegate = self;
            [self pushViewController:reserceVC animated:YES];
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

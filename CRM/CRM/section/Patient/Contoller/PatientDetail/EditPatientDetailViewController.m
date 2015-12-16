//
//  EditPatientDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "EditPatientDetailViewController.h"
#import "DBManager+Patients.h"
#import "DBTableMode.h"
#import "EditAllergyViewController.h"

#define CommenBgColor MyColor(245, 246, 247)

@interface EditPatientDetailViewController ()

@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, strong)NSArray *contentList;

@end

@implementation EditPatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = @[@[@"姓名",@"电话",@"性别",@"年龄",@"身份证号",@"家庭住址"],@[@"过敏史",@"既往病史",@"备注"]];
    
    //设置导航栏
    [self initNavBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patient.ckeyid];
    NSString *genderStr = [patient.patient_gender isEqualToString:@"0"]?@"女" : @"男";
    if (patient != nil) {
        self.contentList = @[@[patient.patient_name,patient.patient_phone,genderStr,patient.patient_age,patient.idCardNum,patient.patient_address],@[patient.patient_allergy,patient.anamnesis,patient.patient_remark]];
        
        [self.tableView reloadData];
    }
}

- (void)initNavBar{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
    [self setRightBarButtonWithTitle:@"保存"];
    self.view.backgroundColor = CommenBgColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)onRightButtonAction:(id)sender{
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    [self popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        divider.backgroundColor = MyColor(206, 206, 206);
        [cell.contentView addSubview:divider];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor grayColor];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.contentList[indexPath.section][indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"过敏史";
            allergyVc.content = self.contentList[indexPath.section][indexPath.row];
            allergyVc.type = EditAllergyViewControllerAllergy;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }else if(indexPath.row == 1){
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"既往病史";
            allergyVc.content = self.contentList[indexPath.section][indexPath.row];
            allergyVc.type = EditAllergyViewControllerAnamnesis;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }else{
            EditAllergyViewController *allergyVc = [[EditAllergyViewController alloc] init];
            allergyVc.title = @"备注";
            allergyVc.content = self.contentList[indexPath.section][indexPath.row];
            allergyVc.type = EditAllergyViewControllerRemark;
            allergyVc.patient = self.patient;
            [self pushViewController:allergyVc animated:YES];
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

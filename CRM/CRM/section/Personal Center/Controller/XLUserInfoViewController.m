//
//  XLUserInfoViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLUserInfoViewController.h"
#import "DBTableMode.h"
#import "DoctorTool.h"
#import "DoctorInfoModel.h"

@interface XLUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName; //姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;//电话
@property (weak, nonatomic) IBOutlet UILabel *userDepartment;//科室
@property (weak, nonatomic) IBOutlet UILabel *userPosition;//职位
@property (weak, nonatomic) IBOutlet UILabel *userHospital;//医院
@property (weak, nonatomic) IBOutlet UITextView *userDesc;//个人简介
@property (weak, nonatomic) IBOutlet UITextView *userSkill;//擅长项目

@end

@implementation XLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",self.doctor.doctor_name];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //加载数据
    [self initData];
}

- (void)dealloc{
    [SVProgressHUD dismiss];
}

- (void)initData{
    [super initData];
    
    if (self.needGet) {
        [SVProgressHUD showWithStatus:@"正在加载"];
        [DoctorTool requestDoctorInfoWithDoctorId:self.doctor.ckeyid success:^(DoctorInfoModel *dcotorInfo) {
            [SVProgressHUD dismiss];
            self.userName.text = dcotorInfo.doctor_name;
            self.userPhone.text = dcotorInfo.doctor_phone;
            self.userDepartment.text = dcotorInfo.doctor_dept;
            self.userPosition.text = dcotorInfo.doctor_position;
            self.userHospital.text = dcotorInfo.doctor_hospital;
            self.userDesc.text = dcotorInfo.doctor_cv;
            self.userSkill.text = dcotorInfo.doctor_skill;
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }else{
        self.userName.text = self.doctor.doctor_name;
        self.userPhone.text = self.doctor.doctor_phone;
        self.userDepartment.text = self.doctor.doctor_dept;
        self.userPosition.text = self.doctor.doctor_position;
        self.userHospital.text = self.doctor.doctor_hospital;
        self.userDesc.text = self.doctor.doctor_cv;
        self.userSkill.text = self.doctor.doctor_skill;
    }
    
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return 10;
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

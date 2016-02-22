//
//  ShuJuFenXiViewController.m
//  CRM
//
//  Created by lsz on 15/9/14.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "ShuJuFenXiViewController.h"
#import "PatientsDisplayViewController.h"
#import "XLPatientSelectViewController.h"

@interface ShuJuFenXiViewController ()

@end

@implementation ShuJuFenXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"数据分析";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}


- (IBAction)weizhongzhi:(id)sender {
    XLPatientSelectViewController *patientVC = [[XLPatientSelectViewController alloc] init];
    patientVC.patientStatus = PatientStatusUntreatUnPlanted;
    [self pushViewController:patientVC animated:YES];
}

- (IBAction)yizhongweixiu:(id)sender {
    XLPatientSelectViewController *patientVC = [[XLPatientSelectViewController alloc] init];
    patientVC.patientStatus = PatientStatusUnrepaired;
    [self pushViewController:patientVC animated:YES];
}
- (IBAction)yizhongzhi:(id)sender {
    
    XLPatientSelectViewController *patientVC = [[XLPatientSelectViewController alloc] init];
    patientVC.patientStatus = PatientStatusRepaired;
    [self pushViewController:patientVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

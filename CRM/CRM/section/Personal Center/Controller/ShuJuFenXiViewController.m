//
//  ShuJuFenXiViewController.m
//  CRM
//
//  Created by lsz on 15/9/14.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "ShuJuFenXiViewController.h"
#import "PatientsDisplayViewController.h"

@interface ShuJuFenXiViewController ()

@end

@implementation ShuJuFenXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"数据分析";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor clearColor];
}


- (IBAction)weizhongzhi:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
    patientVC.patientStatus = PatientStatusUntreatUnPlanted;
    [self pushViewController:patientVC animated:YES];
}

- (IBAction)yizhongweixiu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
    patientVC.patientStatus = PatientStatusUnrepaired;
    [self pushViewController:patientVC animated:YES];
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

//
//  TwoViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TwoViewController.h"
#import "DoctorGroupViewController.h"
#import "CustomAlertView.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我的分组" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonAction{
    DoctorGroupViewController *dVc = [[DoctorGroupViewController alloc] initWithStyle:UITableViewStylePlain];
    dVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:dVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

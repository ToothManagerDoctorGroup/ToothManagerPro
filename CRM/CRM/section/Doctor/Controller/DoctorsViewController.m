//
//  DoctorsViewController.m
//  CRM
//
//  Created by TimTiger on 10/22/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "DoctorsViewController.h"
#import "DoctorTableViewCell.h"

@interface DoctorsViewController ()

@end

@implementation DoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initView {
    [super initView];
    self.title = @"添加介绍人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}

@end

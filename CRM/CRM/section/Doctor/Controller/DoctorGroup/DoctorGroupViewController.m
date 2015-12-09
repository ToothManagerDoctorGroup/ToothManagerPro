//
//  DoctorGroupViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "DoctorGroupViewController.h"
#import "DoctorGroupTableCell.h"
#import "CustomAlertView.h"
#import "GroupPatientDisplayController.h"

@interface DoctorGroupViewController ()<CustomAlertViewDelegate>

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation DoctorGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的分组";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"addgroup"]];
    self.view.backgroundColor = MyColor(248, 248, 248);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataList = @[@"未分组",@"凯旋城",@"东城区"];
}
- (void)onRightButtonAction:(id)sender{
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithAlertTitle:@"新建分组" cancleTitle:@"取消" certainTitle:@"保存"];
    alertView.type = CustomAlertViewTextField;
    alertView.delegate = self;
    [alertView show];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorGroupTableCell *cell = [DoctorGroupTableCell cellWithTableView:tableView];
    cell.name = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    GroupPatientDisplayController *patientVc = [storyboard instantiateViewControllerWithIdentifier:@"GroupPatientDisplayController"];
    patientVc.patientStatus = PatientStatuspeAll;
    patientVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:patientVc animated:YES];
}


#pragma mark - CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    NSLog(@"添加分组");
    if (content.length == 0 || [content isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"分组名不能为空"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

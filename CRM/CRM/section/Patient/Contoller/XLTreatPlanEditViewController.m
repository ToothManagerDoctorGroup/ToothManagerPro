//
//  XLTreatPlanEditViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanEditViewController.h"

@interface XLTreatPlanEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *toothLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation XLTreatPlanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加治疗方案";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"完成"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

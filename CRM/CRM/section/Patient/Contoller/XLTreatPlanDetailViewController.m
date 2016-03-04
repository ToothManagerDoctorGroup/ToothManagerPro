//
//  XLTreatPlanDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanDetailViewController.h"
#import "UIColor+Extension.h"

@interface XLTreatPlanDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *toothLabel;//牙位
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//类型
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;//分配给
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//状态(已完成:0x44bb5c 已过期:0xff5050)

@end

@implementation XLTreatPlanDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //设置子视图
    [self setUpViews];
}

- (void)setUpViews{
    self.title = @"治疗方案详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

#pragma mark - UITableViewDataSource/Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end

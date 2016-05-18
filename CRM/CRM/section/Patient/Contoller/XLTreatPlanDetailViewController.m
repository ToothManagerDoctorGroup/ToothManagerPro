//
//  XLTreatPlanDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatPlanDetailViewController.h"
#import "UIColor+Extension.h"
#import "XLCureProjectModel.h"
#import "MyDateTool.h"

#define FinishedColor [UIColor colorWithHex:0x3dbd57]
#define UnFinishColor [UIColor colorWithHex:0xff4e4a]
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
    //设置数据
    [self setUpData];
}

- (void)setUpViews{
    self.title = @"治疗方案详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

- (void)setUpData{
    self.toothLabel.text = self.model.tooth_position;
    self.typeLabel.text = self.model.medical_item;
    self.doctorNameLabel.text = self.model.therapist_name;
    self.timeLabel.text = [MyDateTool stringWithDateNoTime:[MyDateTool dateWithStringWithSec:self.model.end_date]];
    NSString *finish = nil;
    UIColor *finishColor = nil;
    if ([self.model.status integerValue] == CureProjectWaitHandle) {
        //判断是否逾期
        if ([MyDateTool lateThanToday:self.model.end_date]) {
            self.stateLabel.hidden = NO;
            //逾期
            finish = @"已过期";
            finishColor = UnFinishColor;
        }else{
            //未逾期
            self.stateLabel.hidden = YES;
            finishColor = [UIColor whiteColor];
        }
    }else{
        finish = @"已完成";
        self.stateLabel.hidden = NO;
        finishColor = FinishedColor;
    }
    self.stateLabel.text = finish;
    self.stateLabel.textColor = finishColor;
}

#pragma mark - UITableViewDataSource/Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end

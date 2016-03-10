//
//  XLTreatePatientCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLTreatePatientCell.h"
#import "UIColor+Extension.h"
#import "XLTeamPatientModel.h"
#import "XLCureProjectModel.h"
#import "MyDateTool.h"
#import "DBTableMode.h"

@interface XLTreatePatientCell ()
@property (weak, nonatomic) IBOutlet UIView *functionView;//父视图
@property (weak, nonatomic) IBOutlet UIButton *payButton;//付款按钮（默认隐藏）
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;//患者姓名
@property (weak, nonatomic) IBOutlet UILabel *treateStatus;//治疗状态
@property (weak, nonatomic) IBOutlet UILabel *expenseNumLabel;//种植数量
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;//付款状态

@end
@implementation XLTreatePatientCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    XLTreatePatientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLTreatePatientCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XLTreatePatientCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"XLTreatePatientCell" bundle:nil] forCellReuseIdentifier:@"XLTreatePatientCell"];
    }
    return cell;
}

- (void)awakeFromNib {
    
    self.functionView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.functionView.layer.borderWidth = .5;
    self.functionView.layer.cornerRadius = 4;
    self.functionView.layer.masksToBounds = YES;
    
    self.payButton.layer.borderColor = [UIColor colorWithHex:0x00a0ea].CGColor;
    self.payButton.layer.borderWidth = .5;
    self.payButton.layer.cornerRadius = 4;
    self.payButton.layer.masksToBounds = YES;
    
}

- (void)setModel:(XLTeamPatientModel *)model{
    _model = model;
    
    self.timeLabel.text = model.create_time;
    self.patientNameLabel.text = model.patient_name;
    self.expenseNumLabel.text = [NSString stringWithFormat:@"%ld颗",(long)[model.implant_count integerValue]];
    
    if ([model.status integerValue] == CureProjectPayed) {
        //已付款
        self.payStatusLabel.text = @"已收款";
        self.payStatusLabel.textColor = [UIColor colorWithHex:0x888888];
    }else{
        //未付款
        self.payStatusLabel.text = @"未收款";
        self.payStatusLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    
    //就诊状态
    switch ([model.patient_status integerValue]) {
        case PatientStatusUntreatment:
            [self.treateStatus setTextColor:[UIColor colorWithHex:0x00a0ea]];
            break;
        case PatientStatusUnplanted:
            [self.treateStatus setTextColor:[UIColor colorWithHex:0xff3b31]];
            break;
        case PatientStatusUnrepaired:
            [self.treateStatus setTextColor:[UIColor colorWithHex:0x37ab4e]];
            break;
        case PatientStatusRepaired:
            [self.treateStatus setTextColor:[UIColor colorWithHex:0x888888]];
            break;
        default:
            break;
    }
    self.treateStatus.text = [Patient statusStrWithIntegerStatus:[model.patient_status integerValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

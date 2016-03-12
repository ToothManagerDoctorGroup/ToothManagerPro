//
//  XLJoinTreateCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLJoinTreateCell.h"
#import "XLAvatarView.h"
#import "MyDateTool.h"
#import "XLJoinTeamModel.h"

@interface XLJoinTreateCell ()

@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet XLAvatarView *avatarView;


@end

@implementation XLJoinTreateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    XLJoinTreateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLJoinTreateCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XLJoinTreateCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"XLJoinTreateCell" bundle:nil] forCellReuseIdentifier:@"XLJoinTreateCell"];
    }
    return cell;
}

- (void)setModel:(XLJoinTeamModel *)model{
    _model = model;
    
    self.endDateLabel.text = [NSString stringWithFormat:@"截止日期：%@",[MyDateTool stringWithDateNoTime:[MyDateTool dateWithStringWithSec:model.end_date]]];
    self.patientLabel.text = [NSString stringWithFormat:@"患者：%@",model.patient_name];
    self.doctorNameLabel.text = model.doctor_name;
    self.avatarView.urlStr = model.doctor_image;
    self.avatarView.targetImage = [UIImage imageNamed:@"team_biao_shou"];
}

- (void)awakeFromNib {
    // Initialization code
    self.avatarView.targetImage = [UIImage imageNamed:@"team_biao_jie"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

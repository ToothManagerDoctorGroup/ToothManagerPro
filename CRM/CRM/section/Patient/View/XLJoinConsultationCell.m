//
//  XLJoinConsultationCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLJoinConsultationCell.h"
#import "XLAvatarView.h"
#import "XLJoinTeamModel.h"

@interface XLJoinConsultationCell ()

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet XLAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

@end
@implementation XLJoinConsultationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    XLJoinConsultationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLJoinConsultationCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XLJoinConsultationCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"XLJoinConsultationCell" bundle:nil] forCellReuseIdentifier:@"XLJoinConsultationCell"];
    }
    return cell;
}

- (void)setModel:(XLJoinTeamModel *)model{
    _model = model;
    
    self.patientNameLabel.text = [NSString stringWithFormat:@"患者：%@",model.patient_name];
    self.avatarView.urlStr = model.doctor_image;
    self.avatarView.targetImage = [UIImage imageNamed:@"team_biao_shou"];
    self.doctorNameLabel.text = model.doctor_name;
    
}

- (void)awakeFromNib {
    
    self.avatarView.targetImage = [UIImage imageNamed:@"team_biao_shou"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

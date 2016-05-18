//
//  XLDoctorSelectCell.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDoctorSelectCell.h"
#import "UIColor+Extension.h"
#import "UIImageView+WebCache.h"
#import "DBTableMode.h"

@interface XLDoctorSelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@end
@implementation XLDoctorSelectCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    XLDoctorSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLDoctorSelectCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XLDoctorSelectCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"XLDoctorSelectCell" bundle:nil] forCellReuseIdentifier:@"XLDoctorSelectCell"];
    }
    return cell;
}

//初始化
- (void)awakeFromNib {
    self.iconImageView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
}

- (void)setDoctor:(Doctor *)doctor{
    _doctor = doctor;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctor.doctor_image] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    self.doctorNameLabel.text = doctor.doctor_name;
    self.doctorDetailLabel.text = [NSString stringWithFormat:@"%@ %@",doctor.doctor_hospital,doctor.doctor_position];
    if (doctor.isExist) {
        self.selectButton.enabled = NO;
    }else{
        self.selectButton.enabled = YES;
        self.selectButton.selected = doctor.isSelect;
    }
    
}


- (IBAction)selectAction:(id)sender {
    self.selectButton.selected = !self.selectButton.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(doctorSelectCell:withChooseStatus:)]) {
        [self.delegate doctorSelectCell:self withChooseStatus:self.selectButton.isSelected];
    }
}


- (void)setType:(DoctorSelectType)type{
    _type = type;
    
    if (type == DoctorSelectTypeAdd) {
        [self.selectButton setImage:[UIImage imageNamed:@"choose-blue"] forState:UIControlStateSelected];
    }else{
        [self.selectButton setImage:[UIImage imageNamed:@"remove_red"] forState:UIControlStateSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)selectOperation{
    [self selectAction:nil];
}
@end

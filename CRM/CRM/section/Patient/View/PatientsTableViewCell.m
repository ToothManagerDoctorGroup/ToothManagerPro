//
//  PatientsTableViewCell.m
//  CRM
//
//  Created by TimTiger on 10/21/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientsTableViewCell.h"
#import "DBTableMode.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "AccountManager.h"
#import "NSString+Conversion.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Doctor.h"
#import "DBManager+Introducer.h"

@implementation PatientsTableViewCell

- (void)awakeFromNib {
    UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = selectView;
    selectView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
}

- (void)configCellWithCellMode:(PatientsCellMode *)mode {
    self.nameLabel.text = mode.name;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.statusLabel.text = mode.statusStr;
    self.transferLabel.text = mode.introducerName;
    self.transferLabel.adjustsFontSizeToFitWidth = YES;
    
    if(mode.isTransfer){
        self.zhuanZhenImageview.hidden = NO;
    }else{
        self.zhuanZhenImageview.hidden = YES;
    }
    
    self.countMaterial.text = [NSString stringWithFormat:@"%ld颗",(long)mode.countMaterial];
    self.statusLabel.textColor = [Patient statusColorWithIntegerStatus:mode.status];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

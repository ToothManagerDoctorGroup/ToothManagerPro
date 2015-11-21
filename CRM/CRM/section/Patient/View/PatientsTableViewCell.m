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
    // Initialization code
}

- (void)configCellWithCellMode:(PatientsCellMode *)mode {
    self.nameLabel.text = mode.name;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.statusLabel.text = mode.statusStr;
    self.transferLabel.text = mode.introducerName;
    
    
    Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:mode.patientId withIntrId:[AccountManager shareInstance].currentUser.userid];
    if([doc.doctor_name isNotEmpty]){
        self.zhuanZhenImageview.hidden = NO;
    }else{
        self.zhuanZhenImageview.hidden = YES;
    }
    
    self.countMaterial.text = [NSString stringWithFormat:@"%ld颗",mode.countMaterial];
    switch (mode.status) {
        case PatientStatusUntreatment:
            [self.statusLabel setTextColor:[UIColor colorWithHex:CUSTOM_YELLOW]];
            break;
        case PatientStatusUnplanted:
            [self.statusLabel setTextColor:[UIColor colorWithHex:CUSTOM_RED]];
            break;
        case PatientStatusUnrepaired:
            [self.statusLabel setTextColor:[UIColor colorWithHex:CUSTOM_GREEN]];
            break;
        case PatientStatusRepaired:
            [self.statusLabel setTextColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

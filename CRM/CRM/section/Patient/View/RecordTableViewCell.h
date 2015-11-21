//
//  RecordTableViewCell.h
//  CRM
//
//  Created by TimTiger on 2/10/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalRecord;
@class PatientConsultation;
@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *content;

-(void)setCellWithRecord:(MedicalRecord *)record size:(CGSize)size;

-(void)setCellWithPatientC:(PatientConsultation *)patientC size:(CGSize)size;
@end

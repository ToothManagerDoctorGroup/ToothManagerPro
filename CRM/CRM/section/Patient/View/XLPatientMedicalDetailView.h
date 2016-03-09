//
//  XLPatientMedicalDetailView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalCase;
@interface XLPatientMedicalDetailView : UIView

@property (nonatomic, strong)MedicalCase *medicalCase;

@property (nonatomic, assign)NSInteger memberNum;

@end

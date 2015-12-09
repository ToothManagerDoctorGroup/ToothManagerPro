//
//  MedicalDetailView.h
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  病历详情视图
 */
@class TTMMedicalCaseModel;
@interface MedicalDetailView : UIView

@property (nonatomic, strong)TTMMedicalCaseModel *medicalCase;

@end

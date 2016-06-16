//
//  ClinicDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class ClinicModel,XLClinicModel,Patient;
@interface ClinicDetailViewController : TimViewController

//诊所模型一
@property (nonatomic, strong)ClinicModel *model;

//诊所模型二
@property (nonatomic, strong)XLClinicModel *unsignModel;

@property (nonatomic, strong)Patient *patient;

@end

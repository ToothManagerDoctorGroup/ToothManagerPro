//
//  XLDoctorDetailViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
/**
 *  医生详情
 */
@class Doctor;
@interface XLDoctorDetailViewController : TimDisplayViewController

@property (nonatomic, strong)Doctor *doc;

@end


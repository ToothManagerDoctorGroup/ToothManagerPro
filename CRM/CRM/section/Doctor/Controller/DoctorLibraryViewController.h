//
//  DoctorLibraryViewController.h
//  CRM
//
//  Created by fankejun on 14-9-25.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
@class DoctorLibraryViewController,Doctor;
@protocol DoctorLibraryViewControllerDelegate <NSObject>

@optional
- (void)doctorLibraryVc:(DoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor;

@end

@interface DoctorLibraryViewController : TimDisplayViewController

@property (nonatomic,readwrite)BOOL isTransfer;  //是否转诊【只有转诊功能才为YES】
@property (nonatomic,copy) NSString *userId;     //转诊医生id
@property (nonatomic,copy) NSString *patientId; //转诊病人id【只有转诊功能用得到】


@property (nonatomic, assign)BOOL isTherapyDoctor;//是否是选择治疗医生
@property (nonatomic, weak)id<DoctorLibraryViewControllerDelegate> delegate;

@end
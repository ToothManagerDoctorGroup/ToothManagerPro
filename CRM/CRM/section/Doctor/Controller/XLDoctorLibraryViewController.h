//
//  XLDoctorLibraryViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class XLDoctorLibraryViewController,Doctor;
@protocol XLDoctorLibraryViewControllerDelegate <NSObject>

@optional
- (void)doctorLibraryVc:(XLDoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor;

@end

@interface XLDoctorLibraryViewController : TimViewController

@property (nonatomic,readwrite)BOOL isTransfer;  //是否转诊【只有转诊功能才为YES】
@property (nonatomic,copy) NSString *userId;     //转诊医生id
@property (nonatomic,copy) NSString *patientId; //转诊病人id【只有转诊功能用得到】

@property (nonatomic, assign)BOOL isTherapyDoctor;//是否是选择治疗医生
@property (nonatomic, weak)id<XLDoctorLibraryViewControllerDelegate> delegate;

@end

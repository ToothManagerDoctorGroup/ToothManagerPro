//
//  XLTreatePatientViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

typedef NS_ENUM(NSInteger,TreatePatientViewControllerType){
    TreatePatientViewControllerTypeOtherToMe = 1,//别人转诊给我
    TreatePatientViewControllerTypeMeToOther = 2,//我转诊给别人
    TreatePatientViewControllerTypeMeInviteOther = 3,//我邀请别人
    TreatePatientViewControllerTypeOtherInviteMe = 4//别人邀请我
};

@class Doctor;
@interface XLTreatePatientViewController : TimViewController

@property (nonatomic, assign)TreatePatientViewControllerType type;

@property (nonatomic, strong)Doctor *doc;

@end

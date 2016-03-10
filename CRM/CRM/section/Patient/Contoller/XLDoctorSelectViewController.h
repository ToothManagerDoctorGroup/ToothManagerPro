//
//  XLDoctorSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

typedef NS_ENUM(NSInteger,DoctorSelectType){
    DoctorSelectTypeAdd = 0,
    DoctorSelectTypeRemove = 1
};
/**
 *  选择医生好友
 */
@class MedicalCase;
@interface XLDoctorSelectViewController : TimViewController

@property (nonatomic, assign)DoctorSelectType type;

@property (nonatomic, strong)MedicalCase *mCase;

@property (nonatomic, strong)NSArray *existMembers;//当前存在的成员

@end

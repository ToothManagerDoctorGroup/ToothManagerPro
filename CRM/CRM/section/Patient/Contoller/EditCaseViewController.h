//
//  EditCaseViewController.h
//  MCRPages
//
//  Created by fankejun on 14-5-14.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "CTView.h"
#import "DBTableMode.h"

@interface EditCaseViewController : TimViewController <UITextFieldDelegate>
{
    UIView * CTImageView;  //CT片
    UIView * appointTimeView; //下次预约时间
    UIView * descriptionView; //病情描述
    UIView * materialView;  //所用耗材
    
    CTView * ctView;
    UITextField * year_filed;
    UITextField * month_filed;
    UITextField * day_filed;
    UITextField * materialName_filed;
    UITextField * materialNumb_filed;
    UITextField * description_field;
}

@property (nonatomic, retain) Patient * patient;
@property (nonatomic, retain) MedicalCase * medicalCase;
@end

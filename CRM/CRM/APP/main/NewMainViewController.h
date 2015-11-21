//
//  NewMainViewController.h
//  CRM
//
//  Created by fankejun on 14-9-25.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"

@interface NewMainViewController : TimViewController <UIScrollViewDelegate>
{
    NSMutableArray *headImageArray;
}

- (IBAction)unPlantClick:(UIButton *)sender;
- (IBAction)dateRemindClick:(UIButton *)sender;
- (IBAction)plantUnfixedClick:(UIButton *)sender;
- (IBAction)introducerClick:(UIButton *)sender;
- (IBAction)doctorClick:(UIButton *)sender;
- (IBAction)patientClick:(UIButton *)sender;
- (IBAction)fixedDoctorClick:(UIButton *)sender;

@end

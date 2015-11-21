//
//  PatientConsultationViewController.h
//  CRM
//
//  Created by lsz on 15/9/8.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "DBTableMode.h"

@interface PatientConsultationViewController : TimViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property(nonatomic,copy) NSString *patientId;
@property (nonatomic,retain) Patient *patient;

@end

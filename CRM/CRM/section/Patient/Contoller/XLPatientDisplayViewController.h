//
//  XLPatientDisplayViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/24.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface XLPatientDisplayViewController : EaseConversationListViewController

@property (nonatomic,readwrite) PatientStatus patientStatus;

@end

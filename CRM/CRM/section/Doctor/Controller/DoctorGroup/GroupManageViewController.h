//
//  GroupManageViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/9.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"
#import "DBManager.h"

@class DoctorGroupModel;
@interface GroupManageViewController : TimDisplayViewController

@property (nonatomic, strong)DoctorGroupModel *group;

@end

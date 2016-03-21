//
//  XLUserInfoViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  用户信息
 */
@class Doctor;
@interface XLUserInfoViewController : TimTableViewController

@property (nonatomic, strong)Doctor *doctor;

@property (nonatomic, assign)BOOL needGet;//只传了医生id，需要获取网络数据

@end

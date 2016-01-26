//
//  XLGroupManagerViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class DoctorGroupModel;
@interface XLGroupManagerViewController : TimViewController

@property (nonatomic, strong)DoctorGroupModel *group;

@property (nonatomic, assign)BOOL isAnalyse;//从数据分析页面跳转过来
@property (nonatomic, strong)NSArray *analyseList;//数据分析获取到的数据

@end

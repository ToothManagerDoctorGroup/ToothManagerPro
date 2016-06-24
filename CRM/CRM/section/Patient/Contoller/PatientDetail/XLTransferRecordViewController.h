//
//  XLTransferRecordViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/6/14.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
/**
 *  转诊记录
 */
@interface XLTransferRecordViewController : TimViewController

@property (nonatomic, copy)NSString *patientId;
@property (nonatomic, assign)BOOL isBind;

@end

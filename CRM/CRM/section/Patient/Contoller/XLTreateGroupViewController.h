//
//  XLTreateGroupViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  治疗群组
 */
@class  MedicalCase;
@interface XLTreateGroupViewController : TimTableViewController

@property (nonatomic, strong)MedicalCase *mCase;

@end

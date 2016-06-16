//
//  XLDiseaseRecordViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  病程记录
 */
@class MedicalCase;
@interface XLDiseaseRecordViewController : TimTableViewController

@property (nonatomic, strong)MedicalCase *mCase;

@end

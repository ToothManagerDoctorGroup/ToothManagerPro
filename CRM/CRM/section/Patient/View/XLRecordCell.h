//
//  XLRecordCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/25.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  病历描述cell
 */
@class MedicalRecord;
@interface XLRecordCell : UITableViewCell


@property (nonatomic, strong)MedicalRecord *record;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

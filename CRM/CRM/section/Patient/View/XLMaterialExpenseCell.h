//
//  XLMaterialExpenseCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalExpense;
@interface XLMaterialExpenseCell : UITableViewCell

@property (nonatomic, strong)MedicalExpense *expense;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end


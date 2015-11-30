//
//  MyBillPayedCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/30.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillModel;
@protocol MyBillPayedCellDelegate <NSObject>

@optional
//点击预约取消按钮回调
- (void)didClickAppointCancleButtonWithBillModel:(BillModel *)model;

//付款成功回调
- (void)didPaySuccessWithResult:(NSString *)result;

@end

@interface MyBillPayedCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)BillModel *model;

@property (nonatomic, weak)id<MyBillPayedCellDelegate> delegate;

@end

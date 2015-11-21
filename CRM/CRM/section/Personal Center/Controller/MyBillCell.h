//
//  MyBillCell.h
//  CRM
//
//  Created by Argo Zhang on 15/11/13.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillModel;
@protocol MyBillCellDelegate <NSObject>

@optional
//点击预约取消按钮回调
- (void)didClickAppointCancleButtonWithBillModel:(BillModel *)model;

//付款成功回调
- (void)didPaySuccessWithResult:(NSString *)result;

@end

@interface MyBillCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)BillModel *model;

@property (nonatomic, copy)NSString *type;

@property (nonatomic, weak)id<MyBillCellDelegate> delegate;

@end

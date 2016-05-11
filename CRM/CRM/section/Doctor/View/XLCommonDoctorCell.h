//
//  XLCommonDoctorCell.h
//  CRM
//
//  Created by Argo Zhang on 16/3/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  医生通用cell
 */
@class Doctor,FriendNotificationItem,XLCommonDoctorCell;
@protocol XLCommonDoctorCellDelegte <NSObject>

@optional
- (void)commonDoctorCell:(XLCommonDoctorCell *)cell addButtonDidSelect:(id)sender;

@end
@interface XLCommonDoctorCell : UITableViewCell

@property (nonatomic, weak)id<XLCommonDoctorCellDelegte> delegate;

+ (CGFloat)fixHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign)BOOL buttonEnable;

//新的好友页面
- (void)setNewFriendCellWithFrienNotifi:(FriendNotificationItem *)notifiItem;
//好友列表页面
- (void)setFriendListCellWithModel:(Doctor *)doctor;
//医生广场页面
- (void)setDoctorSquareCellWithModel:(Doctor *)doctor;

@end

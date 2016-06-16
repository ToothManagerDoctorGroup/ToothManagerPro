//
//  XLEditGroupViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/3/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
/**
 *  编辑分组
 */
@class XLEditGroupViewController,Patient;
@protocol XLEditGroupViewControllerDelegate <NSObject>

@optional
- (void)editGroupViewController:(XLEditGroupViewController *)editGroupVc didSelectGroups:(NSArray *)groups;

- (void)editGroupViewController:(XLEditGroupViewController *)editGroupVc didAddGroups:(NSArray *)addGroups delectGroups:(NSArray *)deleteGroups groupName:(NSString *)groupName;
@end

@interface XLEditGroupViewController : TimTableViewController

@property (nonatomic, strong)NSArray *currentGroups;//编辑后的分组信息

@property (nonatomic, assign)BOOL isEdit;//是编辑模式
@property (nonatomic, strong)NSArray *orginExistGroups;//编辑模式下初始的分组信息

@property (nonatomic, assign)BOOL isPatientEdit;//患者详情编辑模式

@property (nonatomic, weak)id<XLEditGroupViewControllerDelegate> delegate;

@end

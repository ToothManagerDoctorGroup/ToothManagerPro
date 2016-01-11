//
//  XLAddReminderViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

@class MedicalCase,XLAddReminderViewController,Patient,LocalNotification;
@protocol XLAddReminderViewControllerDelegate <NSObject>

@optional
- (void)addReminderViewController:(XLAddReminderViewController *)vc didSelectDateTime:(NSString *)dateStr;
- (void)addReminderViewController:(XLAddReminderViewController *)vc didUpdateReserveRecord:(LocalNotification *)localNoti;
@end
@interface XLAddReminderViewController : TimDisplayViewController

@property (nonatomic, strong)NSDictionary *infoDic;//时间选择页面传递过来的数据

@property (nonatomic) BOOL isNextReserve; //从编辑病历跳转
@property (nonatomic, strong)MedicalCase *medicalCase;//编辑病历时传递过来的病历模型

@property (nonatomic, assign)BOOL isAddLocationToPatient;//给指定病人添加预约
@property (nonatomic, strong)Patient *patient;//指定病人的病历

@property (nonatomic, assign)BOOL isEditAppointment;//修改预约
@property (nonatomic, strong)LocalNotification *localNoti;//修改预约时传递过来的预约模型


@property (nonatomic, weak)id<XLAddReminderViewControllerDelegate> delegate;

@end

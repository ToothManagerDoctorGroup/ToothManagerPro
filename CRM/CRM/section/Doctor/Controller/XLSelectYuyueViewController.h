//
//  XLSelectYuyueViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "TimPickerTextField.h"
/**
 *  选择预约时间
 */
@class MedicalCase,Patient,XLSelectYuyueViewController;
@protocol XLSelectYuyueViewControllerDelegate <NSObject>

@optional
- (void)selectYuyueViewController:(XLSelectYuyueViewController *)vc didSelectDateTime:(NSString *)dateStr;
- (void)selectYuyueViewController:(XLSelectYuyueViewController *)vc didSelectData:(NSDictionary *)dic;

@end

@interface XLSelectYuyueViewController : TimViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UITableView *m_tableView;
    NSMutableArray *timeArray;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, assign)BOOL isHome;//判断是否是通过首页进行跳转

@property (nonatomic) BOOL isNextReserve; //从编辑病历跳转
@property (nonatomic, strong)MedicalCase *medicalCase;//编辑病历时传递过来的病历模型

@property (nonatomic, assign)BOOL isAddLocationToPatient;//给指定病人添加预约
@property (nonatomic, strong)Patient *patient;//指定病人的病历

@property (nonatomic, assign)BOOL isEditAppointment;//是编辑病历跳转
@property (nonatomic, copy)NSString *reserveTime;//当前选择的就诊时间

@property (nonatomic, weak)id<XLSelectYuyueViewControllerDelegate> delegate;

@end

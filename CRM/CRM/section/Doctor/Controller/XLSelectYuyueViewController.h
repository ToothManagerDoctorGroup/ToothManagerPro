//
//  XLSelectYuyueViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/21.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"
#import "VRGCalendarView.h"
#import "TimPickerTextField.h"
/**
 *  选择预约时间
 */
@interface XLSelectYuyueViewController : TimViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UITableView *m_tableView;
    NSMutableArray *timeArray;
    NSString *dateString;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, assign)BOOL isHome;//判断是否是通过首页进行跳转

@end

//
//  XLDataSelectViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/12/28.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

typedef NS_ENUM(NSInteger, XLDataSelectViewControllerType) {
    XLDataSelectViewControllerSex = 1, //性别
    XLDataSelectViewControllerDepartment = 2, //科室
    XLDataSelectViewControllerHospital = 3,//医院
    XLDataSelectViewControllerProfressional = 4,//职称
    XLDataSelectViewControllerDegree = 5,//学历
    XLDataSelectViewControllerMaterialType = 6,//种植体类型
};
@class XLDataSelectViewController;
@protocol XLDataSelectViewControllerDelegate <NSObject>

@optional
- (void)dataSelectViewController:(XLDataSelectViewController *)dataVc didSelectContent:(NSString *)content type:(XLDataSelectViewControllerType)type;
@end

@interface XLDataSelectViewController : TimDisplayViewController

@property (nonatomic, assign)XLDataSelectViewControllerType type;

@property (nonatomic, copy)NSString *currentContent;//当前需要选中的数据

@property (nonatomic, weak)id<XLDataSelectViewControllerDelegate> delegate;

@end

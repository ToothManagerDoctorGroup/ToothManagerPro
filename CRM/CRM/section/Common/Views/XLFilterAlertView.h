//
//  XLFilterAlertView.h
//  CRM
//
//  Created by Argo Zhang on 16/3/31.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTableMode.h"

typedef NS_ENUM(NSInteger,FilterAlertViewType){
    FilterAlertViewAll,//全部患者
    FilterAlertViewPatientState,//患者状态
    FilterAlertViewNewPatient,//新增患者
    FilterAlertViewImplanted,//完成种植
    FilterAlertViewRepaired//完成修复
};

@class XLFilterAlertView;
@protocol XLFilterAlertViewDelegate <NSObject>

@optional
- (void)filterAlertViewDidDismiss:(XLFilterAlertView *)alertView;

- (void)filterAlertView:(XLFilterAlertView *)alertView filterAlertViewType:(FilterAlertViewType)type patientStatus:(PatientStatus)status startTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
@interface XLFilterAlertView : UIView

- (void)showInView:(UIView *)superView;
- (void)dismiss;

@property (nonatomic, weak)id<XLFilterAlertViewDelegate> delegate;

@end

//
//  XLFilterPatientTimeView.h
//  CRM
//
//  Created by Argo Zhang on 16/4/1.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FilterPatientTimeViewType){
    FilterPatientTimeViewTypeNewPatient,//新增患者
    FilterPatientTimeViewTypeImplanted,//完成种植
    FilterPatientTimeViewTypeRepaired   //完成修复
};
/**
 *  根据时间筛选
 */
@class XLFilterPatientTimeView;
@protocol XLFilterPatientTimeViewDelegate <NSObject>

@optional
- (void)filterPatientTimeView:(XLFilterPatientTimeView *)timeView startTime:(NSString *)startTime endTime:(NSString *)endTime;
@end

@interface XLFilterPatientTimeView : UIView

@property (nonatomic, assign)FilterPatientTimeViewType type;

@property (nonatomic, weak)id<XLFilterPatientTimeViewDelegate> delegate;

@end

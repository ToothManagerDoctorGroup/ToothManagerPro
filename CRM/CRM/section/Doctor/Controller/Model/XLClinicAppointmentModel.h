//
//  XLClinicAppointmentModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/13.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormScrollView.h"

@interface XLClinicAppointmentModel : NSObject

/**
 *  当前对象所在位置
 */
@property (nonatomic, strong)FIndexPath *indexPath;
/**
 *  是否被占用
 */
@property (nonatomic, assign,getter=isTakeUp)BOOL takeUp;
/**
 *  椅位号
 */
@property (nonatomic, copy)NSString *seat;
/**
 *  预约时间
 */
@property (nonatomic, copy)NSString *appointTime;
/**
 *  预约时长
 */
@property (nonatomic, assign)float duration;
/**s
 *  当前显示时间
 */
@property (nonatomic, copy)NSString *visiableTime;

@end

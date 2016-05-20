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
@property (nonatomic, strong)NSArray *indexPathList;
/**
 *  每个模型的原始位置
 */
@property (nonatomic, strong)NSIndexPath *indexPath;

/**
 *  是否被占用
 */
@property (nonatomic, assign,getter=isTakeUp)BOOL takeUp;
/**
 *  诊所id
 */
@property (nonatomic, copy)NSString *clinicId;
/**
 *  诊所名称
 */
@property (nonatomic, copy)NSString *clinicName;
/**
 *  椅位号
 */
@property (nonatomic, copy)NSString *seatId;
/**
 *  椅位价格
 */
@property (nonatomic, assign)float seatPrice;
/**
 *  预约时间
 */
@property (nonatomic, copy)NSString *appointTime;
/**
 *  预约时长
 */
@property (nonatomic, assign)float duration;

/**
 *  当前的显示时间
 */
@property (nonatomic, copy)NSString *visibleTime;



@end

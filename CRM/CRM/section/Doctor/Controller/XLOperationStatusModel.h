//
//  XLOperationStatusModel.h
//  CRM
//
//  Created by Argo Zhang on 16/5/18.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  营业状态模型
 */
@class XLBusiness;
@interface XLOperationStatusModel : NSObject

@property (nonatomic, strong)XLBusiness *business;

@property (nonatomic, strong)NSArray *seatList;

@property (nonatomic, strong)NSArray *timeList;

@end


#pragma mark - 诊所营业时间
@interface XLBusiness : NSObject
/**
 *  诊所id
 */
@property (nonatomic, copy)NSString *clinicId;
/**
 *  诊所每天营业时间
 */
@property (nonatomic, copy)NSString *businessHours;
/**
 *  诊所每周营业天数
 */
@property (nonatomic, copy)NSString *businessWeek;

@end

#pragma mark - 椅位信息
@interface XLSeatInfo : NSObject
//椅位id
@property (nonatomic, copy)NSString *seat_id;
//椅位名称
@property (nonatomic, copy)NSString *seat_name;
/**
 *  椅位价格
 */
@property (nonatomic, strong)NSNumber *seat_price;

@end

#pragma mark - 诊所占用时间信息
@interface XLOccupyTime : NSObject
/**
*  诊所id
*/
@property (nonatomic, copy)NSString *clinicId;
/**
 *  椅位id
 */
@property (nonatomic, copy)NSString *seatId;

/**
 *  预约的开始时间
 */
@property (nonatomic, copy)NSString *reserveTime;
/**
 *  预约的时长
 */
@property (nonatomic, strong)NSNumber *reserveDuration;


@end

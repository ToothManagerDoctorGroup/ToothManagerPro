//
//  TTMScheduleRequestModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>
@class TTMChairModel;
/**
 *  控制器类型
 */
typedef NS_ENUM(NSUInteger, TTMScheduleRequestModelControlType){
    /**
     *  日程表
     */
    TTMScheduleRequestModelControlTypeSchedule,
    /**
     *  我的预约
     */
    TTMScheduleRequestModelControlTypeAppointment,
};

/**
 *  请求类型
 */
typedef NS_ENUM(NSUInteger, TTMScheduleRequestType){
    /**
     *  按状态请求
     */
    TTMScheduleRequestTypeStatus,
    /**
     *  按椅位请求
     */
    TTMScheduleRequestTypeChair,
    /**
     *  按日期请求
     */
    TTMScheduleRequestTypeDate,
};

/**
 *  预约请求model
 */
@interface TTMScheduleRequestModel : NSObject

/**
 *  控制器类型
 */
@property (nonatomic, assign) TTMScheduleRequestModelControlType controlType;
/**
 *  请求类型
 */
@property (nonatomic, assign) TTMScheduleRequestType requestType;

// 日程表页面请求参数
/**
 *  请求日期
 */
@property (nonatomic, strong) NSDate *date;
/**
 *  椅位
 */
@property (nonatomic, strong) TTMChairModel *chair;

// 我的预约页面请求参数
/**
 *  状态（0、1、2）进行中，已完成，全部
 */
@property (nonatomic, assign) NSUInteger status;

@end

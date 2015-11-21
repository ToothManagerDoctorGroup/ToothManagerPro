

#import <Foundation/Foundation.h>
#import "TTMScheduleRequestModel.h"
@class TTMChargeDetailModel;

/**
 *  预约信息状态
 */
typedef NS_ENUM(NSUInteger, TTMApointmentStatus){
    /**
     *  已预约未开始
     */
    TTMApointmentStatusNotStart = 0,
    /**
     *  开始未结束
     */
    TTMApointmentStatusStarting = 1,
    /**
     *  已结束未申请付款
     */
    TTMApointmentStatusEnded = 2,
    /**
     *  已申请付款未付款
     */
    TTMApointmentStatusWaitPay = 3,
    /**
     *  已付款
     */
    TTMApointmentStatusComplete = 4,
    /**
     *  已取消
     */
    TTMApointmentStatusCanceled = -1,
};

/**
 *  预约信息单行
 */
@interface TTMApointmentModel : NSObject


@property (nonatomic, copy) NSString *doctor_name;

@property (nonatomic, copy) NSString *doctor_image;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, assign) TTMApointmentStatus status;

@property (nonatomic, copy) NSString *used_time;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger KeyId;

@property (nonatomic, assign) NSInteger material_money;

@property (nonatomic, copy) NSString *appoint_id;

@property (nonatomic, copy) NSString *doctor_phone;

@property (nonatomic, assign) NSInteger extra_money;

@property (nonatomic, copy) NSString *doctor_id;

@property (nonatomic, assign) NSInteger appoint_money;

@property (nonatomic, assign) NSInteger planting_quantity;

@property (nonatomic, copy) NSString *expert_suggestion;

@property (nonatomic, copy) NSString *seat_name;

@property (nonatomic, copy) NSString *seat_id;

@property (nonatomic, copy) NSString *doctor_dept;

@property (nonatomic, assign) NSInteger assistant_price;

@property (nonatomic, assign) NSInteger clinic_id;

@property (nonatomic, copy) NSString *doctor_position;

@property (nonatomic, copy) NSString *doctor_hospital;

@property (nonatomic, assign) NSInteger assistant_number;

@property (nonatomic, assign) NSInteger seat_price;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *appoint_type;

@property (nonatomic, assign) NSInteger expert_result;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *appoint_time;

@property (nonatomic, assign) NSInteger star_level;

/**
 *  实付款
 */
@property (nonatomic, copy)   NSString *realPay;


/**
 *  查询已完成的预约列表
 *
 *  @param request 请求参数
 */
+ (void)queryCompleteAppointmentComplete:(CompleteBlock)complete;

/**
 *  按时间段查询正在进行的预约
 *
 *  @param type     时间段类型 (0表示按天，1表示按周，2表示按月)
 *  @param complete 回调
 */
+ (void)queryAppointmentListWithTimeType:(NSUInteger)timeType
                                complete:(CompleteBlock)complete;
/**
 *  开始计时
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)startTimeWithModel:(TTMApointmentModel *)model
                  complete:(CompleteBlock)complete;
/**
 *  结束计时
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)endTimeWithModel:(TTMApointmentModel *)model
                complete:(CompleteBlock)complete;
/**
 *  编辑收费明细
 *
 *  @param model    model
 *  @param complete 回调
 */
+ (void)editPayDetailWithModel:(TTMChargeDetailModel *)model
                      complete:(CompleteBlock)complete;

@end

//
//  TTMScheduleCellModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>
#import "TTMScheduleRequestModel.h"
#import "TTMApointmentModel.h"
@class TTMIncomeModel;

/**
 *  时间段查询类型
 */
typedef NS_ENUM(NSUInteger, TTMScheduleQueryTimeType){
    /**
     *  天
     */
    TTMScheduleQueryTimeTypeDay = 0,
    /**
     *  周
     */
    TTMScheduleQueryTimeTypeWeek = 1,
    /**
     *  月
     */
    TTMScheduleQueryTimeTypeMonth = 2,
};

/**
 *  日程表cellModel
 */
@interface TTMScheduleCellModel : NSObject

/**
 *  关健字
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  预约id，查详情用
 */
@property (nonatomic, copy)   NSString *appoint_id;
/**
 *  预约时间
 */
@property (nonatomic, copy)   NSString *appoint_time;
/**
 *  预约类型
 */
@property (nonatomic, copy)   NSString *appoint_type;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  医生id
 */
@property (nonatomic, copy)   NSString *doctor_id;
/**
 *  医生名字
 */
@property (nonatomic, copy)   NSString *doctor_name;
/**
 *  椅号id
 */
@property (nonatomic, copy)   NSString *seat_id;
/**
 *  椅号名称
 */
@property (nonatomic, copy)   NSString *seat_name;
/**
 *  牙位
 */
@property (nonatomic, copy)   NSString *tooth_position;
/**
 *  患者姓名
 */
@property (nonatomic, copy)   NSString *patient_name;
/**
 *  患者id
 */
@property (nonatomic, copy)   NSString *patient_id;


// 预约详情页面需要的数据
/**
 *  医生头像
 */
@property (nonatomic, copy)   NSString *doctor_image;
/**
 *  星级
 */
@property (nonatomic, assign) NSInteger star_level;
/**
 *  科室
 */
@property (nonatomic, copy)   NSString *doctor_dept;
/**
 *  医院
 */
@property (nonatomic, copy)   NSString *doctor_hospital;
/**
 *  职位
 */
@property (nonatomic, copy)   NSString *doctor_position;
/**
 *  电话
 */
@property (nonatomic, copy)   NSString *doctor_phone;
/**
 *  种植数量
 */
@property (nonatomic, assign) NSInteger planting_quantity;
/**
 *  时长
 */
@property (nonatomic, assign) NSInteger duration;

/**
 *  备注
 */
@property (nonatomic, copy)   NSString *remark;
/**
 *  诊疗结果
 */
@property (nonatomic, copy)   NSString *expert_result;
/**
 *  诊疗建议
 */
@property (nonatomic, copy)   NSString *expert_suggestion;
/**
 *  状态
 */
@property (nonatomic, assign) TTMApointmentStatus status;

// 预约详情字段

@property (nonatomic, strong) NSArray *materials;

@property (nonatomic, strong) NSArray *assists;

@property (nonatomic, assign) TTMApointmentStatus reserve_status;

@property (nonatomic, copy) NSString *total_money;

@property (nonatomic, copy) NSString *actual_start_time;

@property (nonatomic, copy) NSString *actual_end_time;

@property (nonatomic, copy) NSString *reserve_type;

@property (nonatomic, copy) NSString *reserve_duration;

@property (nonatomic, copy) NSString *reserve_time;

@property (nonatomic, copy) NSString *used_time;


/**
 *  查询日程列表
 *
 *  @param request 请求参数
 */
+ (void)querySchedulesWithRequest:(TTMScheduleRequestModel *)request
                         complete:(CompleteBlock)complete;
/**
 *  查询预约详情
 *
 *  @param appointId 预约id
 */
+ (void)queryScheduleDetailWithId:(NSInteger)appointId
                         complete:(CompleteBlock)complete;

/**
 *  查询其他部分的详情
 *
 *  @param appointId appointId description
 *  @param complete  complete description
 */
+ (void)queryScheduleOtherDetailWithId:(NSInteger)appointId
                              complete:(CompleteBlock)complete;


/**
 *  我的收入页面查询预约详情
 *
 *  @param appointId 预约id
 */
+ (void)queryScheduleDetailWithAppointId:(NSString *)appointId
                                complete:(CompleteBlock)complete;

/**
 *  转化为incomeModel
 *
 *  @return TTMIncomeModel
 */
- (TTMIncomeModel *)incomeModelAdapter;

@end

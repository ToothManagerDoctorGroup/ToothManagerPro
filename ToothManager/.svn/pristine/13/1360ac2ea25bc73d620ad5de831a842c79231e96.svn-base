
#import <Foundation/Foundation.h>
#import "TTMApointmentModel.h"

/**
 *  收费明细model
 */
@interface TTMChargeDetailModel : NSObject

@property (nonatomic, assign) NSInteger KeyId;

@property (nonatomic, copy) NSString *appoint_id;

@property (nonatomic, assign) TTMApointmentStatus status;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger doctor_id;

@property (nonatomic, copy) NSString *seat_name;

@property (nonatomic, copy) NSString *expert_suggestion;

@property (nonatomic, copy) NSString *seat_id;

@property (nonatomic, assign) NSInteger assistant_price;

@property (nonatomic, assign) NSInteger clinic_id;

@property (nonatomic, assign) NSInteger assistant_number;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *appoint_type;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger expert_result;

@property (nonatomic, copy) NSString *appoint_time;

@property (nonatomic, copy) NSString *end_time;

/**
 *  用时
 */
@property (nonatomic, copy) NSString *used_time;
/**
 *  总费用
 */
@property (nonatomic, copy) NSString *appoint_money;
/**
 *  椅位价格
 */
@property (nonatomic, copy) NSString *seat_price;
/**
 *  椅位总价
 */
@property (nonatomic, copy) NSString *seat_money;

/**
 *  助手列表
 */
@property (nonatomic, strong) NSArray *assist_detail;
/**
 *  助手总价
 */
@property (nonatomic, copy) NSString *assistant_money;

/**
 *  种植体材料列表
 */
@property (nonatomic, strong) NSArray *material_detail;
/**
 *  材料费用
 */
@property (nonatomic, copy) NSString *material_money;

/**
 *  其他费用列表
 */
@property (nonatomic, strong) NSArray *extra_detail;
/**
 *  其他费用
 */
@property (nonatomic, copy) NSString *extra_money;



/**
 *  查询收费明细
 *
 *  @param appointmentId 预约id
 *  @param doctorId      医生id
 *  @param complete      回调
 */
+ (void)queryChargeDetailWithAppointmentId:(NSString *)appointmentId
                                  complete:(CompleteBlock)complete;

@end

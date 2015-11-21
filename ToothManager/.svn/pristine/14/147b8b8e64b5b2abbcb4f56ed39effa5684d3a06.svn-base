//
//  TTMIncomModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  收款状态
 */
typedef NS_ENUM(NSUInteger, TTMIncomeModelState){
    /**
     *  已收款
     */
    TTMIncomeModelStateReceived = 4,
    /**
     *  待收款
     */
    TTMIncomeModelStateStay = 3,
};

/**
 *  收入行model
 */

@interface TTMIncomeModel : NSObject

/**
 *  是否是预约，如果是，可以跳转到预约详情
 */
@property (nonatomic, assign) BOOL isAppointment;
/**
 *  关键字
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  时间
 */
@property (nonatomic, copy)   NSString *time;
/**
 *  付款人（或椅号位）
 */
@property (nonatomic, copy)   NSString *person;
/**
 *  多少钱 (或医生)
 */
@property (nonatomic, copy)   NSString *mony;
/**
 *  收款状态
 */
@property (nonatomic, assign) TTMIncomeModelState state;
/**
 *  预约内容
 */
@property (nonatomic, copy)   NSString *appoint_type;



/**
 *  预约id
 */
@property (nonatomic, copy)   NSString *appoint_id;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *datetime;
/**
 *  医生id
 */
@property (nonatomic, assign) NSInteger doctor_id;
/**
 *  医生名
 */
@property (nonatomic, copy)   NSString *doctor_name;
/**
 *  费用
 */
@property (nonatomic, assign) CGFloat money;
/**
 *  状态
 */
@property (nonatomic, assign) NSInteger status;

@end

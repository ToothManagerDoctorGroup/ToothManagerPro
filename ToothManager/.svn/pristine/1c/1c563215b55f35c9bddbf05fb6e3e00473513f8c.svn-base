//
//  TTMMessageCellModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  信息状态
 */
typedef NS_ENUM(NSUInteger, TTMMessageStatusType){
    /**
     *  未读
     */
    TTMMessageStatusTypeNotRead = 0,
    /**
     *  已读
     */
    TTMMessageStatusTypeReaded = 1,
};

#define kMessageTypeSign @"sign"
#define kMessageTypeReserve @"reserve"
#define kMessageTypePay @"pay"

/**
 *  消息cellModel
 */
@interface TTMMessageCellModel : NSObject
@property (nonatomic, assign) NSInteger keyId;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  状态
 */
@property (nonatomic, assign) NSInteger message_status;
/**
 *  医生id
 */
@property (nonatomic, copy)   NSString *doctor_id;
/**
 *  医生名
 */
@property (nonatomic, copy)   NSString *doctor_name;
/**
 *  椅位id
 */
@property (nonatomic, assign) NSInteger seat_id;
/**
 *  椅位名
 */
@property (nonatomic, copy)   NSString *seat_name;
/**
 *  预约id
 */
@property (nonatomic, copy)  NSString *appoint_id;
/**
 *  预约类型
 */
@property (nonatomic, copy)   NSString *appoint_type;
/**
 *  预约时间
 */
@property (nonatomic, copy)   NSString *appoint_time;
/**
 *  钱
 */
@property (nonatomic, assign) NSInteger money;
/**
 *  收入时间
 */
@property (nonatomic, copy)   NSString *datetime;
/**
 *  状态，不知道是什么
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  是否是预约信息
 */
@property (nonatomic, assign) BOOL isAppointment;

/**
 *  消息类型，sign签约类型，reserve预约类型，pay收入类型
 */
@property (nonatomic, copy) NSString *message_type;

@property (nonatomic, copy) NSString *message_content;

/**
 *  根据这个调用各自明细值
 */
@property (nonatomic, assign) NSInteger message_id;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, assign) NSInteger KeyId;


/**
 *  查询消息列表
 *
 *  @param complete 回调
 */
+ (void)queryMessageListWithStatus:(TTMMessageStatusType)status Complete:(CompleteBlock)complete;

/**
 *  查询未读条数
 *
 *  @param complete 回调
 */
+ (void)queryNotReadCountWithComplete:(CompleteBlock)complete;

/**
 *  修改消息状态为已读
 *
 *  @param complete 回调
 */
+ (void)changeNotReadMessageWithId:(NSInteger)messageId complete:(CompleteBlock)complete;
@end

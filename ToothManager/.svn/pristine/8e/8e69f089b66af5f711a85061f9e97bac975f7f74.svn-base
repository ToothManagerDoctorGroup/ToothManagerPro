

#import <Foundation/Foundation.h>

/**
 *  提现记录model
 */
@interface TTMWithdrawModel : NSObject


@property (nonatomic, assign) NSInteger KeyId;
/**
 *  时间
 */
@property (nonatomic, copy)   NSString *withdraw_time;
/**
 *  金额
 */
@property (nonatomic, copy)   NSString *money;
/**
 *  状态   0审核中 1提现已到账 
 */
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger clinic_id;


/**
 *  查询提现记录
 *
 *  @param complete 回调
 */
+ (void)queryWithdrawRecordWithComplete:(CompleteBlock)complete;

@end

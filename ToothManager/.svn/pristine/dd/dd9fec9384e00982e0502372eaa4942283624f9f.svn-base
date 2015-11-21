
#import <Foundation/Foundation.h>

/**
 *  助理model
 */
@interface TTMAssistModel : NSObject

@property (nonatomic, copy) NSString *KeyId; // 详情时是预约id，列表时是助手id

@property (nonatomic, copy) NSString *assist_name;

// 详情查询出的数据
@property (nonatomic, copy) NSString *actual_money;

@property (nonatomic, copy) NSString *actual_num;

@property (nonatomic, copy) NSString *assist_id;

@property (nonatomic, assign) BOOL is_reserved;

@property (nonatomic, copy) NSString *plan_money;

@property (nonatomic, copy) NSString *plan_num;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *reserve_id;

// 助手列表查询出的数据
@property (nonatomic, copy) NSString *assist_price;

@property (nonatomic, copy) NSString *assist_type;

@property (nonatomic, copy) NSString *creation_time;

@property (nonatomic, copy) NSString *data_flag;

// 计算数据
@property (nonatomic, assign) NSUInteger number; // 数量

@property (nonatomic, copy) NSString *countPrice; // 总价格

/**
 *  查询助手列表
 *
 *  @param complete 回调
 */
+ (void)queryAssistListWithComplete:(CompleteBlock)complete;

@end

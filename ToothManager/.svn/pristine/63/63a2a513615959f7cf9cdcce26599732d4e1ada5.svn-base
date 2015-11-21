

#import <Foundation/Foundation.h>

/**
 *  材料model,包括种植体和其他
 */
@interface TTMMaterialModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *KeyId; // 详情时是预约id，列表时是材料id

// 详情查出的数据
@property (nonatomic, copy) NSString *actual_money;

@property (nonatomic, copy) NSString *actual_num;

@property (nonatomic, assign) BOOL is_reserved;

@property (nonatomic, copy) NSString *mat_id;

@property (nonatomic, copy) NSString *mat_name;

@property (nonatomic, copy) NSString *plan_money;

@property (nonatomic, copy) NSString *plan_num;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *reserve_id;

// 材料列表查询出的数据
@property (nonatomic, copy) NSString *mat_type;

@property (nonatomic, copy) NSString *data_flag;

@property (nonatomic, copy) NSString *creation_time;

@property (nonatomic, copy) NSString *mat_price;

// 计算数据
@property (nonatomic, assign) NSUInteger number; // 数量

@property (nonatomic, copy) NSString *countPrice; // 总价格

/**
 *  查询材料列表
 *  @param status   查询类型,1种植体，2其他材料
 *  @param complete 回调
 */
+ (void)queryMaterialWithStatus:(NSUInteger)status complete:(CompleteBlock)complete;

@end

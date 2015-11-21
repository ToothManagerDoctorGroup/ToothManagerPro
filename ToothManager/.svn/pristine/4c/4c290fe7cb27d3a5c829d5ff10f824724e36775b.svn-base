
#import <Foundation/Foundation.h>

/**
 *  椅位配置信息model
 */
@interface TTMChairSettingModel : NSObject
/**
 *  唯一id
 */
@property (nonatomic, assign) NSInteger KeyId;
/**
 *  椅位id
 */
@property (nonatomic, copy) NSString *seat_id;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  椅位品牌
 */
@property (nonatomic, copy) NSString *seat_brand;
/**
 *  型号
 */
@property (nonatomic, copy) NSString *seat_desc;


/**
 *  自来水
 */
@property (nonatomic, assign) NSInteger seat_tapwater;
/**
 *  蒸馏水
 */
@property (nonatomic, assign) NSInteger seat_distillwater;
/**
 *  超声功率
 */
@property (nonatomic, assign) NSInteger seat_ultrasound;
/**
 *  光固灯
 */
@property (nonatomic, assign) NSInteger seat_light;


/**
 *  椅位价格
 */
@property (nonatomic, assign) CGFloat seat_price;
/**
 *  助理价格
 */
@property (nonatomic, assign) CGFloat assistant_price;


@property (nonatomic, assign) NSInteger available;

@property (nonatomic, copy) NSString *seat_name;

/**
 *  查询椅位配置信息
 *
 *  @param ID       椅位id
 *  @param complete 回调
 */
+ (void)queryDetailWithID:(NSString *)ID complete:(CompleteBlock)complete;

/**
 *  修改椅位配置信息
 *
 *  @param model    椅位参数model
 *  @param complete 回调
 */
+ (void)updateWithModel:(TTMChairSettingModel *)model complete:(CompleteBlock)complete;
@end

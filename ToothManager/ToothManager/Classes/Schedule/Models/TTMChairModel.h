//
//  TTMChairModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  椅位model
 */
@interface TTMChairModel : NSObject
/**
 *  关键字
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  是否可用
 */
@property (nonatomic, assign) BOOL available;
/**
 *  诊所id
 */
@property (nonatomic, assign) NSInteger clinic_id;
/**
 *  椅位名称
 */
@property (nonatomic, copy)   NSString *seat_name;
/**
 *  椅位id
 */
@property (nonatomic, copy)   NSString *seat_id;

/**
 *  查询椅位信息
 *
 *  @param complete 回调
 */
+ (void)queryChairsWithComplete:(CompleteBlock)complete;

/**
 *  椅位配置信息页面，椅位信息
 *
 *  @param complete 回调
 */
+ (void)queryChairsForSettingWithComplete:(CompleteBlock)complete;
@end

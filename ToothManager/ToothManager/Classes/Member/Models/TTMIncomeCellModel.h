//
//  TTMIncomeCellModel.h
//  ToothManager
//

#import <Foundation/Foundation.h>

/**
 *  我的收入cellModel
 */
@interface TTMIncomeCellModel : NSObject

/**
 *  关键字
 */
@property (nonatomic, assign) NSInteger keyId;
/**
 *  年份
 */
@property (nonatomic, copy)   NSString *year;
/**
 *  月份
 */
@property (nonatomic, copy)   NSString *month;
/**
 *  这月的列表(TTMIncomeModel)
 */
@property (nonatomic, strong) NSMutableArray *infoList;
/**
 *  cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 *  查询收入列表
 *
 *  @param complete 回调
 */
+ (void)queryIncomeListWithComplete:(CompleteBlock)complete;

@end

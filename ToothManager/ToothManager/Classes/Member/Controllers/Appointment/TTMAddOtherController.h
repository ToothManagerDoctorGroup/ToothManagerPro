
#import "TTMBaseColorController.h"
#import "TTMChargeDetailModel.h"
@protocol TTMAddOtherControllerDelegate;

/**
 *  添加其他费用
 */
@interface TTMAddOtherController : TTMBaseColorController

@property (nonatomic, weak) id<TTMAddOtherControllerDelegate> delegate;

@property (nonatomic, strong) TTMChargeDetailModel *detailModel;

@end

@protocol TTMAddOtherControllerDelegate <NSObject>

/**
 *  材料返回
 *
 *  @param addOtherController addOtherController description
 *  @param countMoney         总计价格
 *  @param materialArray      材料数组
 */
- (void)addOtherController:(TTMAddOtherController *)addOtherController
                countMoney:(NSUInteger)countMoney
             materialArray:(NSArray *)materialArray;

@end
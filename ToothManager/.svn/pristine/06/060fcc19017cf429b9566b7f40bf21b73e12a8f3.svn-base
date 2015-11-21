

#import "TTMBaseColorController.h"
#import "TTMChargeDetailModel.h"
@protocol TTMUpdateAssistControllerDelegate;

/**
 *  页面类型
 */
typedef NS_ENUM(NSUInteger, TTMUpdateAssistControllerType) {
    /**
     *  助手
     */
    TTMUpdateAssistControllerTypeAssist,
    /**
     *  种植体
     */
    TTMUpdateAssistControllerTypePlant,
};

/**
 *  修改助理费用
 */
@interface TTMUpdateAssistController : TTMBaseColorController

@property (nonatomic, assign) TTMUpdateAssistControllerType type;

@property (nonatomic, weak) id<TTMUpdateAssistControllerDelegate> delegate;

@property (nonatomic, strong) TTMChargeDetailModel *detailModel;

@end

@protocol TTMUpdateAssistControllerDelegate <NSObject>

/**
 *  助手回调
 *
 *  @param updateAssistController updateAssistController description
 *  @param countMoney             总计价格
 *  @param assistArray            助手列表
 */
- (void)updateAssistController:(TTMUpdateAssistController *)updateAssistController
                    countMoney:(NSUInteger)countMoney
                   assistArray:(NSArray *)assistArray;

/**
 *  种植体回调
 *
 *  @param updateAssistController updateAssistController description
 *  @param countMoney             总计价格
 *  @param plantArray             种植体列表
 */
- (void)updateAssistController:(TTMUpdateAssistController *)updateAssistController
                    countMoney:(NSUInteger)countMoney
                    plantArray:(NSArray *)plantArray;

@end

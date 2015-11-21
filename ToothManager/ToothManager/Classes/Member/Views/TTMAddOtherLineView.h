
#import <UIKit/UIKit.h>
#import "TTMMaterialModel.h"

/**
 *  添加其他费用行
 */
@interface TTMAddOtherLineView : UIView

@property (nonatomic, strong) TTMMaterialModel *model; // 材料model

@property (nonatomic, weak) UIButton *valueButton; // 项目按钮

@property (nonatomic, weak) UIButton *deleteButton; // 删除按钮

@property (nonatomic, weak) UITextField *priceTextField; // 价格输入框

@end

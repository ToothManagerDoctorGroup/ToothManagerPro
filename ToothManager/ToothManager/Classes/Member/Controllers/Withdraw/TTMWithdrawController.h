

#import "TTMBaseColorController.h"
#import "TTMClinicModel.h"

/**
 *  提现
 */
@interface TTMWithdrawController : TTMBaseColorController

@property (nonatomic, strong) TTMClinicModel *bankModel;

@property (nonatomic, strong) TTMClinicModel *accountModel;
@end

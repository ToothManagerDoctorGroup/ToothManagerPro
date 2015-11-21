

#import <UIKit/UIKit.h>
#import "TTMWithdrawModel.h"

/**
 *  提现记录cell
 */
@interface TTMWithdrawCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TTMWithdrawModel *model;

@end

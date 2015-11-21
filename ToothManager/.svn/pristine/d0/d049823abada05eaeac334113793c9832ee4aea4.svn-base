//
//  TTMIncomeCell.h
//  ToothManager
//

#import <UIKit/UIKit.h>
#import "TTMIncomeCellModel.h"
@class TTMIncomeModel;
@protocol TTMIncomeCellDelegate;

/**
 *  我的收入和我的预约cell
 */
@interface TTMIncomeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TTMIncomeCellModel *model;

@property (nonatomic, weak)   id<TTMIncomeCellDelegate> delegate;

@end

@protocol TTMIncomeCellDelegate <NSObject>
/**
 *  返回选中行数据
 *
 *  @param cell        cell
 *  @param incomeModel 数据model
 */
- (void)incomeCell:(TTMIncomeCell *)cell incomModel:(TTMIncomeModel *)incomeModel;

@end
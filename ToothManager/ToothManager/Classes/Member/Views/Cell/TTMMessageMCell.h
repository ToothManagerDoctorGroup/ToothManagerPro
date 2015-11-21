//
//  TTMMessageMCell.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMMessageCellModel;

/**
 *  没有按照设计的cell
 */
@interface TTMMessageMCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) TTMMessageCellModel *model;
@end

//
//  TTMGTaskCell.h
//  ToothManager
//

#import <UIKit/UIKit.h>
@class TTMGTaskCellModel;
@protocol TTMGTaskCellDelegate;

/**
 *  待办项, 医生库cell
 */
@interface TTMGTaskCell : UITableViewCell
/**
 *  实例工厂方法
 *
 *  @param tableView tableView description
 *
 *  @return return value description
 */
+ (instancetype)taskCellWithTableView:(UITableView *)tableView;
/**
 *  数据model
 */
@property (nonatomic, strong) TTMGTaskCellModel *model;
/**
 *  代理
 */
@property (nonatomic, assign) id<TTMGTaskCellDelegate> delegate;

@end

@protocol TTMGTaskCellDelegate <NSObject>
/**
 *  点击按钮回调事件
 *
 *  @param cell  cell description
 *  @param model model description
 */
- (void)gtaskCell:(TTMGTaskCell *)cell model:(TTMGTaskCellModel *)model;

@end

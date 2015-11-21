
#import <UIKit/UIKit.h>
#import "TTMClinicInfoCellModel.h"

/**
 *  诊所信息cell
 */
@interface TTMClinicInfoCell : UITableViewCell

@property (nonatomic, weak)   UILabel *contentLabel; // 内容

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TTMClinicInfoCellModel *model;

@end

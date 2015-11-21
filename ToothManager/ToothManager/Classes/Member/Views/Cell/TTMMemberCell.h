//
//  TTMMemberCell.h
//  ToothManager
//

#import <UIKit/UIKit.h>
#import "TTMMemberCellModel.h"
@protocol TTMMemberCellDelegate;

@interface TTMMemberCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) TTMMemberCellModel *model;
@property (nonatomic, assign) id<TTMMemberCellDelegate> delegate;

@end

@protocol TTMMemberCellDelegate <NSObject>

- (void)memberCell:(TTMMemberCell *)cell clickedModel:(TTMMemberCellModel *)model;

@end
//
//  CaseMaterialsTableViewCell.h
//  CRM
//
//  Created by TimTiger on 2/3/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimPickerTextField,Material;
@protocol CaseMaterialsTableViewCellDelegate;
@interface CaseMaterialsTableViewCell : UITableViewCell

@property (weak,nonatomic) id <CaseMaterialsTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet TimPickerTextField *materialName;
@property (weak, nonatomic) IBOutlet TimPickerTextField *materialNum;

- (void)setCell:(NSArray *)array;

@end

@protocol CaseMaterialsTableViewCellDelegate <NSObject>

- (void)didBeginEdit:(CaseMaterialsTableViewCell *)cell;
- (void)tableViewCell:(CaseMaterialsTableViewCell *)cell materialNum:(NSInteger)num;

@end

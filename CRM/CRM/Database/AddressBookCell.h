//
//  AddressBookCell.h
//  CRM
//
//  Created by Argo Zhang on 15/12/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookViewController.h"

@class AddressBookCell;
@protocol AddressBookCellDelegate <NSObject>

@optional
- (void)addressBookCell:(AddressBookCell *)cell didclickAddButton:(UIButton *)button;

@end

@interface AddressBookCell : UITableViewCell

@property (nonatomic, strong)AddressBookCellMode *model;

@property (nonatomic, weak)id<AddressBookCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

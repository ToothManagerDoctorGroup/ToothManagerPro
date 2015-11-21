//
//  ExpenseTableViewCell.h
//  CRM
//
//  Created by TimTiger on 5/24/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimPickerTextField,Material;
@protocol FirstResponderDelegate;

@class ExpenseTableViewCell;
@protocol ExpenseTableViewCellPushDelegate <NSObject>

- (void)didBeginEdit:(ExpenseTableViewCell *)cell;

@end

@interface ExpenseTableViewCell : UITableViewCell

@property (nonatomic,readonly) TimPickerTextField *nameTextField;
@property (nonatomic,readonly) TimPickerTextField *countTextField;
@property (nonatomic,retain) Material *material;

@property (nonatomic,assign) id <FirstResponderDelegate> delegate;
@property (nonatomic,assign) id <ExpenseTableViewCellPushDelegate> pushdelegate;

@end

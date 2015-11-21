//
//  AddButtonFooterView.h
//  CRM
//
//  Created by TimTiger on 5/29/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddButtonFooterViewDelegate <NSObject>

- (void)didTapAddButton:(NSIndexPath *)indexPath;

@end

@interface AddButtonFooterView : UITableViewHeaderFooterView

@end

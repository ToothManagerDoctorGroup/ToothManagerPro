//
//  DesTableViewCell.h
//  CRM
//
//  Created by TimTiger on 5/24/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimFramework.h"

@class TimTextView;
@interface DesTableViewCell : UITableViewCell

@property (nonatomic,readonly) TimTextView *textView;

@property (nonatomic,assign) id <FirstResponderDelegate> delegate;

@end

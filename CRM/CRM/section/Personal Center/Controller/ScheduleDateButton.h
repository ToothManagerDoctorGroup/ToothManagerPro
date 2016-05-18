//
//  ScheduleDateButton.h
//  CRM
//
//  Created by Argo Zhang on 15/12/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScheduleDateButtonDelegate <NSObject>

@optional
- (void)didClickDateButton;

@end

@interface ScheduleDateButton : UIView

@property (nonatomic, copy)NSString *title;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, weak)id<ScheduleDateButtonDelegate> delegate;

@end

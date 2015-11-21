//
//  TitleMenuViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitleMenuViewController;
@protocol TitleMenuViewControllerDelegate <NSObject>

@optional
- (void)titleMenuViewController:(TitleMenuViewController *)menuController didSelectTitle:(NSString *)title;

@end

@interface TitleMenuViewController : UITableViewController


@property (nonatomic, weak)id<TitleMenuViewControllerDelegate> delegate;

@end

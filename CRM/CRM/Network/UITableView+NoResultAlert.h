//
//  UITableView+NoResultAlert.h
//  CRM
//
//  Created by Argo Zhang on 16/4/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)();

@interface UITableView (NoResultAlert)

- (UIView *)createNoResultAlertViewWithImageName:(NSString *)imageName top:(CGFloat)top showButton:(BOOL)showButton buttonClickBlock:(ButtonClickBlock)buttonClickBlock;

@end

//
//  UserInfoEditViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

typedef NS_ENUM(NSInteger, EditViewControllerType)
{
    //以下是枚举成员
    EditViewControllerTypeSkill ,
    EditViewControllerTypeDescription
};

@class UserInfoEditViewController;
@protocol UserInfoEditViewControllerDelegate <NSObject>

@optional
- (void)editViewController:(UserInfoEditViewController *)editVc didUpdateUserInfoWithStr:(NSString *)str type:(EditViewControllerType)type;

@end
@interface UserInfoEditViewController : TimViewController

@property (nonatomic, copy)NSString *targetStr;

@property (nonatomic, weak)id<UserInfoEditViewControllerDelegate> delegate;

@end

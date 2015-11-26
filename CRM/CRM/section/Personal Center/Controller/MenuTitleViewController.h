//
//  MenuTitleViewController.h
//  CRM
//
//  Created by Argo Zhang on 15/11/26.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MenuTitleViewControllerType){
    MenuTitleViewControllerClinic, //诊所列表
    MenuTitleViewControllerSeat //椅位列表
};

@class MenuTitleViewController;
@protocol MenuTitleViewControllerDelegate <NSObject>

@optional
- (void)titleViewController:(MenuTitleViewController *)titleViewController didSelectTitle:(NSString *)title type:(MenuTitleViewControllerType)type;

@end

@interface MenuTitleViewController : UITableViewController

@property (nonatomic, strong)id<MenuTitleViewControllerDelegate> delegate;

@property (nonatomic, assign)MenuTitleViewControllerType type;

- (instancetype)initWithStyle:(UITableViewStyle)style dataList:(NSArray *)dataList;



@end

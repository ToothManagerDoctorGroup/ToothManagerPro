//
//  MenuButtonPushManager.h
//  CRM
//
//  Created by lsz on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuView.h"

@interface MenuButtonPushManager : NSObject<MenuViewDelegate>
@property (nonatomic) UINavigationController *viewController;
@end

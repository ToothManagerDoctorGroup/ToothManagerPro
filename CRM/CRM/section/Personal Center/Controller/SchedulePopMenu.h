//
//  SchedulePopMenu.h
//  CRM
//
//  Created by Argo Zhang on 15/11/27.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SchedulePopMenuType1 = 10,
    SchedulePopMenuType2 = 20,
    SchedulePopMenuType3 = 30,
    SchedulePopMenuType4 = 40
}SchedulePopMenuType;

@interface SchedulePopMenu : UIView

@property (nonatomic, weak)UIViewController *parentVC;

@property (nonatomic, strong)IBOutlet UIView *innerView;

@property (nonatomic, assign)SchedulePopMenuType type;

+ (instancetype)defaultPopupView;

@end

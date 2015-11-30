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

@property (weak, nonatomic) IBOutlet UIButton *menuButton1;
@property (weak, nonatomic) IBOutlet UIButton *menuButton2;
@property (weak, nonatomic) IBOutlet UIButton *menuButton3;
@property (weak, nonatomic) IBOutlet UIButton *menuButton4;


@end

//
//  SchedulePopMenu.m
//  CRM
//
//  Created by Argo Zhang on 15/11/27.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SchedulePopMenu.h"

#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"

@implementation SchedulePopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        _innerView.layer.cornerRadius = 10;
        _innerView.layer.masksToBounds = YES;
        
        [self addSubview:_innerView];
    }
    return self;
}

+ (instancetype)defaultPopupView{
    return [[SchedulePopMenu alloc]initWithFrame:CGRectMake(0, 0, 140, 180)];
}


- (IBAction)menuone:(id)sender {
    self.type = SchedulePopMenuType1;
   [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (IBAction)menutwo:(id)sender {
    self.type = SchedulePopMenuType2;
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

- (IBAction)menuThree:(id)sender {
    self.type = SchedulePopMenuType3;
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}
- (IBAction)menufour:(id)sender {
    self.type = SchedulePopMenuType4;
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationFade new]];
}

@end

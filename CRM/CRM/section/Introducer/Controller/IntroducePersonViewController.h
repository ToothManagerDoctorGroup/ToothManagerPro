//
//  IntroducePersonViewController.h
//  CRM
//
//  Created by fankejun on 14-5-13.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimFramework.h"

typedef NS_ENUM(NSInteger, IntroducePersonView) {
    IntroducePersonViewNormal = 1, //普通查看模式
    IntroducePersonViewSelect,   //选择介绍人模式
};

@class Introducer;
@protocol IntroducePersonViewControllerDelegate;
@interface IntroducePersonViewController : TimViewController <UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,assign) id <IntroducePersonViewControllerDelegate> delegate;
@property (nonatomic,readwrite) IntroducePersonView Mode;

@end

@protocol IntroducePersonViewControllerDelegate <NSObject>

- (void)didSelectedIntroducer:(Introducer *)intro;

@end

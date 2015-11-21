//
//  IntroducerViewController.h
//  CRM
//
//  Created by TimTiger on 10/22/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimDisplayViewController.h"

typedef NS_ENUM(NSInteger, IntroducePersonView) {
    IntroducePersonViewNormal = 1, //普通查看模式
    IntroducePersonViewSelect,   //选择介绍人模式
};

@class Introducer;
@protocol IntroducePersonViewControllerDelegate;
@interface IntroducerViewController : TimDisplayViewController
{
    
}
@property (nonatomic,assign) id <IntroducePersonViewControllerDelegate> delegate;
@property (nonatomic,readwrite) IntroducePersonView Mode;

@end

@protocol IntroducePersonViewControllerDelegate <NSObject>

- (void)didSelectedIntroducer:(Introducer *)intro;

@end


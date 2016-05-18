//
//  XLIntroducerViewController.h
//  CRM
//
//  Created by Argo Zhang on 16/1/11.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "TimViewController.h"

typedef NS_ENUM(NSInteger, IntroducePersonView) {
    IntroducePersonViewNormal = 1, //普通查看模式
    IntroducePersonViewSelect,   //选择介绍人模式
};

@class XLIntroducerViewController,Introducer;
@protocol XLIntroducerViewControllerDelegate <NSObject>

@optional
- (void)didSelectedIntroducer:(Introducer *)intro;

@end

@interface XLIntroducerViewController : TimViewController

@property (nonatomic,assign) id <XLIntroducerViewControllerDelegate> delegate;
@property (nonatomic,readwrite) IntroducePersonView Mode;

@property (nonatomic, assign)BOOL isHome; //判断是否是从首页进入

@end

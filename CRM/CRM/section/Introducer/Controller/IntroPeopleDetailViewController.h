//
//  IntroPeopleDetailViewController.h
//  CRM
//
//  Created by fankejun on 14-5-13.
//  Copyright (c) 2014年 mifeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimViewController.h"
#import "DBTableMode.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class TimStarView;
@interface IntroPeopleDetailViewController : TimViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    UIView * detailInfoView;
    
    NSArray * patientArray;
    UIWebView * phoneCallWebView;
}

@property (nonatomic, retain) NSMutableArray * infoArray;
@property (nonatomic, retain) Introducer * introducer;

@property (nonatomic, assign)BOOL isEdit;//是否是编辑状态

@end

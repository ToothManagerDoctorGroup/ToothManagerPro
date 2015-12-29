//
//  TwoViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/7.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "TwoViewController.h"
#import "DoctorGroupViewController.h"
#import "CustomAlertView.h"
#import "XLTestViewController.h"

#import "UIImageView+WebCache.h"

@interface TwoViewController ()
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.height - 30) / 2, kScreenWidth, 30)];
    label.text = @"该功能正在开发中,敬请期待!";
    label.textColor = MyColor(136, 136, 136);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.frame = CGRectMake(100, 100, 40, 40);
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addButton];
}

- (void)addClick{
    XLTestViewController *testVc = [[XLTestViewController alloc] init];
    testVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:testVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

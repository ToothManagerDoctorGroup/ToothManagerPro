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

#import "UIImageView+WebCache.h"

@interface TwoViewController ()
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    imageView.backgroundColor = [UIColor grayColor];
    self.imageView = imageView;
//    [self.view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 50, 30);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
}

- (void)buttonAction{
    NSURL *url = [NSURL URLWithString:@"970_1449904818804.jpg"];
    [self.imageView sd_setImageWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

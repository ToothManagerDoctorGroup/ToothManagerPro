//
//  XLAdvertisementViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/20.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdvertisementViewController.h"

@interface XLAdvertisementViewController ()

@property (nonatomic, strong)UIImageView *adImageView;//广告页图片

@end

@implementation XLAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.adImageView.image = [UIImage imageNamed:@"adImage"];
    [self.view addSubview:self.adImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

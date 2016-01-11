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
#import "XLPersonalStepOneViewController.h"
#import "TimNavigationViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+XLValidate.h"

@interface TwoViewController ()
@property (nonatomic, weak)UIImageView *imageView;
@property (nonatomic, weak)UITextField *textField;
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
    
    UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    self.textField = textField;
//    [self.view addSubview:textField];
}

- (void)addClick{
//    XLTestViewController *testVc = [[XLTestViewController alloc] init];
//    testVc.hidesBottomBarWhenPushed = YES;
//    [self pushViewController:testVc animated:YES];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    XLPersonalStepOneViewController *oneVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
//    oneVC.hidesBottomBarWhenPushed = YES;
//    [self pushViewController:oneVC animated:YES];
    //获取手机号
    BOOL isPhone = [self.textField.text validateMobile];
    if (isPhone) {
        [SVProgressHUD showSuccessWithStatus:@"手机号有效"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号无效"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

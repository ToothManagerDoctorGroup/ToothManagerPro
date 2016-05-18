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
#import "NSString+TTMAddtion.h"
#import "CRMHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "XLLoginTool.h"

@interface TwoViewController ()
@property (nonatomic, weak)UIImageView *imageView;
@property (nonatomic, weak)UITextField *textField;

@property (nonatomic, copy)NSString *enCodeText;
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
    
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"加密" forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 100, 50, 30);
    addButton.backgroundColor = [UIColor greenColor];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *deButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deButton setTitle:@"解密" forState:UIControlStateNormal];
    deButton.frame = CGRectMake(80, 100, 50, 30);
    deButton.backgroundColor = [UIColor greenColor];
    [deButton addTarget:self action:@selector(deClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:deButton];
    
    
    
    
}

//加密
- (void)addClick{

//    NSString *text = @"紫荆易元";
//    NSLog(@"加密后:%@",[NSString TripleDES:text encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:@""]);
//    self.enCodeText = [NSString TripleDES:text encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:@""];
//    NSString *urlStr = [NSString stringWithFormat:@"http://118.244.234.207/%@/ashx/ClinicMessage.ashx",Method_His_Crm];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"action"] = @"getClinic";
//    params[@"doctor_id"] = @"156";;
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",str);
//        self.enCodeText = str;
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (error) {
//            NSLog(@"error:%@",error);
//        }
//    }];
    //个人信息完善界面
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    XLPersonalStepOneViewController *oneVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLPersonalStepOneViewController"];
//    oneVC.hidesBottomBarWhenPushed = YES;
//    [self pushViewController:oneVC animated:YES];
    
}
//解密
- (void)deClick{
    NSString *text = @"";
    NSLog(@"解密后:%@",[NSString TripleDES:self.enCodeText encryptOrDecrypt:kCCDecrypt encryptOrDecryptKey:@""]);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

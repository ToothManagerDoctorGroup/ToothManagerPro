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
    NSString *text = @"PgBNx+9cMBfrrgHJV9KBXvHbSsbqcivruG4BKoag68In8+yeANCL5jpFMhZpOraOCk3Ssh4+LGvPqaozvpgcKG2PsIotPU3bdZm/0quVx2L2Y4daTP9AJKmLbrUQa2lfe8n159YaKhovhYw6ZXIgIPvnXOqZOcAo0qVZNbgLjkaLqGVaRm+lki7nBWWAdNme8F6PA8IPU7qxIJEdzTgU3c+C/hUtmZZ2jkbPKYj11sox6PNEV4tdPgNSI6g3q6S/EIaZeP6Gf5onBAMhI5799yDuFjrQU3GoNAQ66L/2GYMrhxx5+lgcJa7oKgHS2C0/7RVoACxeXLIvpSEwbxyJtI/YNMgUj5nCCoqfYHhyEJ3AVb01eRgPNvJHdTi76P4tZs07o4oVztQQMGIlhN5dtBk7+aCJqCy9es9bxko1UGHmABiLV/HkO8NY4IUUgSs4MhDhv7w6oi+lQWL3/pa59pmfd/Fu/SZfGWU51lwg267a25vijY8Xe/5UPnpwWLmJJ/PsngDQi+brs9dCdhmAre1x35TcjQPBWZfNcWbAM9u0V0mNVt/iX3AU+7nvCg0oNbVKP3gi1F5oCJqpTz+wEMBWIv5VKHLl5c7lYGjqwzCmzYQj7vpF2qre13wJFS89Gkm2dXit/oTmHtlzkjLOyEOjKUyxLjEg2Eu4puHnAYtRV3+547uBDlt7lWLomboPNTc/Zhi9n8AOqCo54bxCXfDbnd31Nir4cvJyRXzbmRPCv0dYL/Es83DGOABoqHiQxqmOa3GW+6XDoctMRjsjgKUD+vKLNLk+BL/dJrUQwW48ON0UbeO1TBn07PeYxHiHD7wuUDzYDGDraX1Z4maedrRWaQtmtLPXo7j7dygztpZuDjbK2Ax80qXDrW59DmSIpqlflVZ6GAqlwUX+BTCSauXXJJLtgOafnyA8rijq73XiFZhtnHuAIiYRpHIHIVFBVBHLum8FIma3VjJyIq5oCjfJ9CJ9XMs19mOHWkz/QCS94wRSWTHQHteptkFvOEdoCBGM/q2rgMBKaNf7B8i6iS69P5xb2W3uPFEJy30+jg8CX1bmveDnSdKlWTW4C45Gi6hlWkZvpZIu5wVlgHTZnvBejwPCD1O6sSCRHc04FN3Pgv4VLZmWdudlvqES2azgdoZficdNab72Y4daTP9AJMmuZQIDwSSzg4GbInWg53qLsZmqT8xiQTIQ4b+8OqIvuhlKjdlJatP93EnMC5ung6H5ouXflsNZ7RVoACxeXLJD1nVMawnZ3n4/B4qR2laLT/Bd7awueA3pINR8L2ctQQprgBrYVYSG/XgOWcdLAtt149WtiiQ/N+ggXtbeqZWJuLb7DKAxI6AEcp7lNGw2Aw==";
    NSLog(@"解密后:%@",[NSString TripleDES:self.enCodeText encryptOrDecrypt:kCCDecrypt encryptOrDecryptKey:@""]);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

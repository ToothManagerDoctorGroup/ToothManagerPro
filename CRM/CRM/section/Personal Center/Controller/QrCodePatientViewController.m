//
//  QrCodePatientViewController.m
//  CRM
//
//  Created by lsz on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "QrCodePatientViewController.h"
#import "UIImageView+WebCache.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Share.h"
#import "DBManager+Doctor.h"
#import "DBManager+User.h"
#import "CreatePatientViewController.h"
#import "AddressBookViewController.h"

@interface QrCodePatientViewController ()<WXApiDelegate>{
    NSString *weiXinPageUrl;
}

@end

@implementation QrCodePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [self refreshView];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
        [SVProgressHUD showWithStatus:@"加载中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    
    [[AccountManager shareInstance]getQrCode:[AccountManager shareInstance].currentUser.userid withAccessToken:[AccountManager shareInstance].currentUser.accesstoken successBlock:^{
    } failedBlock:^(NSError *error){
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}
//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
            UserObject *obj = [UserObject userobjectFromDic:dic];
            [[DBManager shareInstance] updateUserWithUserObject:obj];
            [[AccountManager shareInstance] refreshCurrentUserInfo];

        }
        return;
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
- (void)qrCodeImageSuccessWithResult:(NSDictionary *)result{
    NSLog(@"二维码=%@",result);
    NSString *imageUrl = [result objectForKey:@"Message"];
    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    weiXinPageUrl = imageUrl;
}
- (void)qrCodeImageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareQrCodeClick:(id)sender {
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"分享种牙管家医生二维码";
        // mode.message = [NSString stringWithFormat:@"这是来自%@的%@医生的微信二维码,现在推荐给你.",[AccountManager shareInstance].currentUser.hospitalName,[AccountManager shareInstance].currentUser.name];
        mode.message = [NSString stringWithFormat:@"这是来自%@医生的微信二维码,现在推荐给你.",[AccountManager shareInstance].currentUser.name];
        mode.url = weiXinPageUrl;
        mode.image = self.QrCodeImageView.image;
        [Share shareToPlatform:weixin WithMode:mode];
    }
}
- (IBAction)shouGongClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    CreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreatePatientViewController"];
    [self pushViewController:newPatientVC animated:YES];
}
- (IBAction)tongXunLuClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AddressBookViewController *addressBook =[storyBoard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
    addressBook.type = ImportTypePatients;
    [self pushViewController:addressBook animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
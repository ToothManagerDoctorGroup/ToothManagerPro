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
#import "XLGuideView.h"

@interface QrCodePatientViewController ()<WXApiDelegate,XLGuideViewDelegate>{
    NSString *weiXinPageUrl;
}

@property (nonatomic, strong)NSOperationQueue *opQueue;

@end

@implementation QrCodePatientViewController

- (NSOperationQueue *)opQueue{
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
    }
    return _opQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    UIView *view = keyWindow.subviews[1];
//    if (view != nil) {
//        [view removeFromSuperview];
//    }
    
    self.title = @"添加患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [self refreshView];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    
    [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:@"" isDoctor:YES successBlock:^{
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}
//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
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
    
    NSString *imageUrl = [result objectForKey:@"Message"];
    //下载图片，不带缓存
//    [self downloadImageWithImageUrl:imageUrl];
    
    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:imageUrl] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    weiXinPageUrl = imageUrl;
}
- (void)qrCodeImageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /*
    //判断是否显示引导页
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isShowedKey = @"isShowedKey";
    BOOL isShowed = [userDefaults boolForKey:isShowedKey];
    if (!isShowed) {
        //显示引导页
        XLGuideView *guideView = [XLGuideView new];
        guideView.delegate = self;
        guideView.step = XLGuideViewStepThree;
        guideView.type = XLGuideViewTypePatient;
        [guideView showInView:[UIApplication sharedApplication].keyWindow maskViewFrame:CGRectMake(5, 350 + 64, 100, 45)];
    }*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)shareQrCodeClick:(id)sender {
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = [NSString stringWithFormat:@"Hi，我是%@医生，请关注我的种牙管家微信平台",[AccountManager shareInstance].currentUser.name];
        mode.message = @"关注后，您将通过种牙管家微信公众号获得预约通知和诊疗医嘱";
        mode.url = [NSString stringWithFormat:@"%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@",DomainName,Method_Weixin,[[AccountManager shareInstance] currentUser].userid];
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


- (void)downloadImageWithImageUrl:(NSString *)imageStr{
    
    // 1.创建多线程
    NSBlockOperation *downOp = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        //执行下载操作
        NSURL *url = [NSURL URLWithString:imageStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        //回到主线程更新ui
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD dismiss];
            self.QrCodeImageView.image = image;
        }];
    }];
    // 2.必须将任务添加到队列中才能执行
    [self.opQueue addOperation:downOp];
}

/*
#pragma mark - XLGuideViewDelegate
- (void)guideView:(XLGuideView *)guideView didClickView:(UIView *)view step:(XLGuideViewStep)step{
    if (step == XLGuideViewStepThree) {
        //修改
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *isShowedKey = @"isShowedKey";
        [userDefaults setBool:YES forKey:isShowedKey];
        [userDefaults synchronize];
        //手动添加患者
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        CreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"CreatePatientViewController"];
        [self pushViewController:newPatientVC animated:YES];
        
    }
}*/


@end

//
//  QrCodeViewController.m
//  CRM
//
//  Created by lsz on 15/6/19.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "QrCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Share.h"
#import "DBManager+Doctor.h"
#import "DBManager+User.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"
#import "XLGuideView.h"
#import "CRMUserDefalut.h"


#define QRCODE_URL_KEY [NSString stringWithFormat:@"%@_doctor_qrcode_url",[AccountManager currentUserid]]

@interface QrCodeViewController ()<WXApiDelegate,XLGuideViewDelegate,UIActionSheetDelegate>{
    NSString *weiXinPageUrl;
}

@end

@implementation QrCodeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    [self setRightBarButtonWithTitle:@"分享"];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
//    UserObject *userobj = [[AccountManager shareInstance] currentUser];
//    [self refreshView];
//    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
//    } failedBlock:^(NSError *error) {
//        [SVProgressHUD showImage:nil status:error.localizedDescription];
//    }];
    
    if (self.isDoctor) {
        
        //判断本地是否存在二维码的url
        NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
        if (qrcodeUrl == nil) {
            [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:@"" isDoctor:self.isDoctor successBlock:^{
            } failedBlock:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }else{
            [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:qrcodeUrl] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        }
    }else{
        [MyPatientTool getPateintKeyIdWithPatientCKeyId:self.patient.ckeyid success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:respondModel.result isDoctor:self.isDoctor successBlock:^{
                    
                } failedBlock:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }
            
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}
//获取用户的医生列表
/*
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
 */

- (void)onRightButtonAction:(id)sender {
    
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        UserObject *userobj = [[AccountManager shareInstance] currentUser];
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"分享种牙管家医生二维码";
        mode.message = [NSString stringWithFormat:@"这是来自%@医生的微信二维码,现在推荐给你.",[AccountManager shareInstance].currentUser.name];
        mode.url = [NSString stringWithFormat:@"http://www.zhongyaguanjia.com/%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@",Method_Weixin,userobj.userid];
        mode.image = self.QrCodeImageView.image;
        if (buttonIndex == 0) {
            //微信
            [Share shareToPlatform:weixinFriend WithMode:mode];
        }else if(buttonIndex ==1){
            //朋友圈
            [Share shareToPlatform:weixin WithMode:mode];
        }
    }
}

- (void)qrCodeImageSuccessWithResult:(NSDictionary *)result{
    NSString *imageUrl = [result objectForKey:@"Message"];
    if (self.isDoctor) {
        [CRMUserDefalut setObject:imageUrl forKey:QRCODE_URL_KEY];
    }
    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:imageUrl] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
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
}

@end

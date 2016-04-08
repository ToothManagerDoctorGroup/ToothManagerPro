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
#import "AddressBookViewController.h"
#import "XLGuideView.h"
#import "CRMUserDefalut.h"
#import "XLContactsViewController.h"
#import "XLCreatePatientViewController.h"

#define QRCODE_URL_KEY [NSString stringWithFormat:@"%@_doctor_qrcode_url",[AccountManager currentUserid]]
@interface QrCodePatientViewController ()<WXApiDelegate,XLGuideViewDelegate,UIActionSheetDelegate>{
    NSString *weiXinPageUrl;
}

@end

@implementation QrCodePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];

    
    //判断本地是否存在二维码的url
    NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
    if (qrcodeUrl == nil) {
        [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:@"" isDoctor:YES successBlock:^{
        } failedBlock:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }else{
        //下载图片，不带缓存
        [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    }
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
    [CRMUserDefalut setObject:imageUrl forKey:QRCODE_URL_KEY];
    
    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
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
- (IBAction)shareQrCodeClick:(id)sender {
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = [NSString stringWithFormat:@"Hi，我是%@医生，请关注我的种牙管家微信平台",[AccountManager shareInstance].currentUser.name];
        mode.message = @"关注后，您将通过种牙管家微信公众号获得预约通知和诊疗医嘱";
        mode.url = [NSString stringWithFormat:@"%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@",DomainRealName,Method_Weixin,[[AccountManager shareInstance] currentUser].userid];
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

- (IBAction)shouGongClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    XLCreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLCreatePatientViewController"];
    [self pushViewController:newPatientVC animated:YES];
}

- (IBAction)tongXunLuClick:(id)sender {
    XLContactsViewController *contactVc = [[XLContactsViewController alloc] initWithStyle:UITableViewStylePlain];
    contactVc.type = ContactsImportTypePatients;
    contactVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:contactVc animated:YES];
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    AddressBookViewController *addressBook =[storyBoard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
//    addressBook.type = ImportTypePatients;
//    [self pushViewController:addressBook animated:YES];
}



@end

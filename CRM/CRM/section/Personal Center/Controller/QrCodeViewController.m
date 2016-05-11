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
#import <MessageUI/MessageUI.h>
#import "DBManager+Patients.h"
#import "DBTableMode.h"


#define QRCODE_URL_KEY [NSString stringWithFormat:@"%@_doctor_qrcode_url",[AccountManager currentUserid]]

@interface QrCodeViewController ()<WXApiDelegate,XLGuideViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>{
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
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    if (self.isDoctor) {
        [self setRightBarButtonWithTitle:@"分享"];
        self.sendMessageView.hidden = YES;
        //判断本地是否存在二维码的url
        NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
        if (qrcodeUrl == nil) {
            [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:@"" isDoctor:self.isDoctor successBlock:^{
            } failedBlock:^(NSError *error) {
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }else{
            [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        }
    }else{
        self.sendMessageView.hidden = NO;
        [MyPatientTool getPateintKeyIdWithPatientCKeyId:self.patientId success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                [[AccountManager shareInstance] getQrCode:[AccountManager currentUserid] withAccessToken:[AccountManager shareInstance].currentUser.accesstoken patientKeyId:respondModel.result isDoctor:self.isDoctor successBlock:^{
                    
                } failedBlock:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

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
        mode.title = [NSString stringWithFormat:@"%@医生的二维码名片",[AccountManager shareInstance].currentUser.name];
        mode.message = [NSString stringWithFormat:@"这是来自%@医生的微信二维码,现在推荐给你.",[AccountManager shareInstance].currentUser.name];
        mode.url = [NSString stringWithFormat:@"%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@",DomainRealName,Method_Weixin,userobj.userid];
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
    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"] options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    weiXinPageUrl = imageUrl;
}
- (IBAction)sendMessageAction:(id)sender {
    Patient *patient = [[DBManager shareInstance] getPatientCkeyid:self.patientId];
    if (patient == nil) return;
    //短信发送
    if( [MFMessageComposeViewController canSendText] )
    {
        NSString *urlStr = [NSString stringWithFormat:@"关注后，您将通过种牙管家微信公众号获得预约通知和诊疗医嘱:%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@&patient_id=%@",DomainRealName,Method_Weixin,[AccountManager currentUserid],patient.ckeyid];
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[patient.patient_phone];
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = urlStr;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送二维码名片"];//修改短信界面标题
    }
    else
    {
        [SVProgressHUD showImage:nil status:@"该设备没有短信功能"];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
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

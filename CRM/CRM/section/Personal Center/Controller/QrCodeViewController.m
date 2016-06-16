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
#import "SettingMacro.h"
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"

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
    
    //判断本地是否存在二维码的url
    NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
    
    if (self.isDoctor) {
        [self setRightBarButtonWithTitle:@"分享"];
        self.sendMessageView.hidden = YES;
        
        [DoctorTool getQrCodeWithPatientKeyId:@"" isDoctor:self.isDoctor success:^(NSDictionary *result) {
            NSString *imageUrl = [result objectForKey:@"Message"];
            [CRMUserDefalut setObject:imageUrl forKey:QRCODE_URL_KEY];
            [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"]];
            weiXinPageUrl = imageUrl;
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
        
        if (qrcodeUrl) {
            [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"]];
        }
    }else{
        self.sendMessageView.hidden = NO;
        [MyPatientTool getPateintKeyIdWithPatientCKeyId:self.patientId success:^(CRMHttpRespondModel *respondModel) {
            if ([respondModel.code integerValue] == 200) {
                [DoctorTool getQrCodeWithPatientKeyId:respondModel.result isDoctor:self.isDoctor success:^(NSDictionary *result) {
                    NSString *imageUrl = [result objectForKey:@"Message"];
                    [self.QrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"]];
                    weiXinPageUrl = imageUrl;
                } failure:^(NSError *error) {
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }
}

- (void)onRightButtonAction:(id)sender {
    
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
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

- (IBAction)sendMessageAction:(id)sender {
    Patient *patient = [[DBManager shareInstance] getPatientCkeyid:self.patientId];
    if (patient == nil) return;
    //短信发送
    if( [MFMessageComposeViewController canSendText] )
    {
        NSString *urlStr = [NSString stringWithFormat:@"您好，我是%@医生，请点击下面链接，关注我的微信号，关注后您可以获得我的预约通知和诊疗医嘱。链接地址:%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@&patient_id=%@",[AccountManager shareInstance].currentUser.name,DomainRealName,Method_Weixin,[AccountManager currentUserid],patient.ckeyid];
        
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  IntroDetailHeaderTableViewController.m
//  CRM
//
//  Created by TimTiger on 3/7/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "IntroDetailHeaderTableViewController.h"
#import "TimPickerTextField.h"
#import "TimStarTextField.h"
#import "AvatarView.h"
#import "AccountManager.h"
#import "DBManager+Doctor.h"
#import "IntroducerManager.h"
#import "CRMHttpRequest+Introducer.h"
#import "XLStarView.h"
#import "XLStarSelectViewController.h"
#import "WXApi.h"
#import "ShareMode.h"
#import "Share.h"
#import <MessageUI/MessageUI.h>
#import "UIView+WXViewController.h"

@interface IntroDetailHeaderTableViewController ()<XLStarSelectViewControllerDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation IntroDetailHeaderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.allowsSelection = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setBorderStyle:UITextBorderStyleNone];
    
    
    [self.levelView addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickStarView)]) {
        [self.delegate didClickStarView];
    }
}

- (IBAction)tel:(id)sender {
    if(![NSString isEmptyString:self.phoneTextField.text]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"未找到介绍人电话"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
            
        }else{
            NSString *number = self.phoneTextField.text;
            NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }else if (alertView.tag == 102) {
        switch (buttonIndex) {
            case 0:
                //取消
                break;
            case 1:
            {
                if(![WXApi isWXAppInstalled]){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }else{
                    ShareMode *mode = [[ShareMode alloc]init];
                    mode.title = @"介绍朋友给医生";
                    mode.message = [NSString stringWithFormat:@"我是%@医生,请点击以下链接,填写您朋友的信息,以便后续就诊",[AccountManager shareInstance].currentUser.name];
                    mode.url = [NSString stringWithFormat:@"%@%@/view/Introduce/IntroduceFriends.aspx?doctor_id=%@&ckeyid=%@",DomainRealName,Method_Weixin,[AccountManager shareInstance].currentUser.userid,self.ckeyId];
                    mode.image = [UIImage imageNamed:@"crm_logo"];
                    
                    //微信
                    [Share shareToPlatform:weixinFriend WithMode:mode];
                    
                }
            }
                
                break;
            case 2:
                //短信发送
                if( [MFMessageComposeViewController canSendText] )
                {
                     NSString *urlStr = [NSString stringWithFormat:@"我是%@医生,请点击以下链接,完善您朋友的信息,以便后续就诊:%@%@/view/Introduce/IntroduceFriends.aspx?doctor_id=%@&ckeyid=%@",[AccountManager shareInstance].currentUser.name,DomainRealName,Method_Weixin,[AccountManager shareInstance].currentUser.userid,self.ckeyId];
                    
                    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
                    controller.recipients = @[self.phoneTextField.text];
                    controller.navigationBar.tintColor = [UIColor redColor];
                    controller.body = urlStr;
                    controller.messageComposeDelegate = self;
                    [self.view.superview.viewController presentViewController:controller animated:YES completion:nil];
                    [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"介绍朋友"];//修改短信界面标题
                }
                else
                {
                    [SVProgressHUD showImage:nil status:@"该设备没有短信功能"];
                }
                break;
                
            default:
                break;
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.view.superview.viewController dismissViewControllerAnimated:YES completion:nil];
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

/*
  本地介绍人的链接：http://122.114.62.57/Weixin/view/Introduce/IntroduceFriends.aspx?doctor_id=162&ckeyid=162_2838837722
网络介绍人的链接：
http://118.244.234.207/Weixin/view/Introduce/IntroduceFriends.aspx?doctor_id=162&introduce_id=413
 
 */

- (void)longUrlToShortUrlSucessWithResult:(NSDictionary *)result{
    NSArray *resultArray = [result objectForKey:@"urls"];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    NSString *shortUrl = [dic objectForKey:@"url_short"];
    
}
- (void)longUrlToShortUrlFailedWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}
- (IBAction)message:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"我是%@医生,请点击以下链接,完善您朋友的信息,以便后续就诊:%@%@/view/Introduce/IntroduceFriends.aspx?doctor_id=%@&ckeyid=%@",[AccountManager shareInstance].currentUser.name,DomainRealName,Method_Weixin,[AccountManager shareInstance].currentUser.userid,self.ckeyId];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"介绍朋友" message:urlStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"微信发送",@"短信发送", nil];
    alertView.tag = 102;
    [alertView show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

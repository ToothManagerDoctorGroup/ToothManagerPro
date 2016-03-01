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

@interface IntroDetailHeaderTableViewController ()<XLStarSelectViewControllerDelegate>

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
        if (buttonIndex == 1) {
            [self shareAction];
        }
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
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
        if(![NSString isEmptyString:self.phoneTextField.text]){
            controller.recipients = [NSArray arrayWithObject:self.phoneTextField.text];
            controller.body = [NSString stringWithFormat:@"我是%@医生,请点击以下链接,完善您朋友的信息,以便后续就诊:%@%@/view/Introduce/IntroduceFriends.aspx?doctor_id=%@&ckeyid=%@",[AccountManager shareInstance].currentUser.name,DomainName,Method_Weixin,[AccountManager shareInstance].currentUser.userid,self.ckeyId];
            
            controller.messageComposeDelegate = self;
            
            [self presentViewController:controller animated:YES completion:nil];
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"发送短信页面"];//修改短信界面标题
        }else{
            [SVProgressHUD showImage:nil status:@"未找到介绍人电话,不能发送信息。"];
        }
    }
    else{
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
        case MessageComposeResultCancelled:
          //  [self alertWithTitle:@"提示" msg:@"取消发送信息"];
            break;
        case MessageComposeResultFailed:// send failed
       //     [self alertWithTitle:@"提示" msg:@"发送信息成功"];
            break;
        case MessageComposeResultSent:
       //     [self alertWithTitle:@"提示" msg:@"发送信息失败"];
            break;
        default:
            break;
    }
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];  
    
}
- (IBAction)weixinShare:(id)sender {
    [self showShareActionChoose];
}


//分享选择
- (void)showShareActionChoose{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"确认打开微信进行分享吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 102;
    [alertView show];
}

//分享
- (void)shareAction{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = @"完善信息";
        mode.message = [NSString stringWithFormat:@"请点击以下链接,完善您信息,以便后续就诊"];
        mode.url = [NSString stringWithFormat:@"http://www.zhongyaguanjia.com/%@/view/Introduce/IntroduceFriends.aspx?doctor_id=%@&ckeyid=%@",Method_Weixin,[AccountManager shareInstance].currentUser.userid,self.ckeyId];
        
        mode.image = [UIImage imageNamed:@"crm_logo"];
        [Share shareToPlatform:weixin WithMode:mode];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  XLQrcodePatientViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/7.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLQrcodePatientViewController.h"
#import "UIImageView+WebCache.h"
#import "AccountManager.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Share.h"
#import "DBManager+Doctor.h"
#import "DBManager+User.h"
#import "XLGuideView.h"
#import "CRMUserDefalut.h"
#import "XLContactsViewController.h"
#import "XLCreatePatientViewController.h"
#import "SettingMacro.h"
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"

@interface XLQrcodePatientViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation XLQrcodePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化视图
    [self setUpView];
    //初始化数据
    [self setUpData];
}

#pragma mark - 初始化视图
- (void)setUpView{
    self.title = @"添加患者";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

#pragma mark - 初始化数据
- (void)setUpData{
    //判断本地是否存在二维码的url
    NSString *qrcodeUrl = [CRMUserDefalut objectForKey:QRCODE_URL_KEY];
    
    [DoctorTool getQrCodeWithPatientKeyId:@"" isDoctor:YES success:^(NSDictionary *result) {
        NSString *imageUrl = [result objectForKey:@"Message"];
        [CRMUserDefalut setObject:imageUrl forKey:QRCODE_URL_KEY];
        
        [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
    if (qrcodeUrl) {
        [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcodeUrl] placeholderImage:[UIImage imageNamed:@"qrcode_jiazai"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)shareAction:(id)sender {
    UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"朋友圈", nil];
    [sheetView showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        ShareMode *mode = [[ShareMode alloc]init];
        mode.title = [NSString stringWithFormat:@"Hi，我是%@医生，请关注我的种牙管家微信平台",[AccountManager shareInstance].currentUser.name];
        mode.message = @"关注后，您将通过种牙管家微信公众号获得预约通知和诊疗医嘱";
        mode.url = [NSString stringWithFormat:@"%@%@/view/Introduce/DoctorDetail.aspx?doctor_id=%@",DomainRealName,Method_Weixin,[[AccountManager shareInstance] currentUser].userid];
        mode.image = self.qrcodeImageView.image;
        
        if (buttonIndex == 0) {
            //微信
            [Share shareToPlatform:weixinFriend WithMode:mode];
        }else if(buttonIndex ==1){
            //朋友圈
            [Share shareToPlatform:weixin WithMode:mode];
        }
    }
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
            XLCreatePatientViewController *newPatientVC = [storyBoard instantiateViewControllerWithIdentifier:@"XLCreatePatientViewController"];
            [self pushViewController:newPatientVC animated:YES];
        }else{
            XLContactsViewController *contactVc = [[XLContactsViewController alloc] initWithStyle:UITableViewStylePlain];
            contactVc.type = ContactsImportTypePatients;
            contactVc.hidesBottomBarWhenPushed = YES;
            [self pushViewController:contactVc animated:YES];
        }
    }
}

@end

//
//  XLDoctorDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/8.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDoctorDetailViewController.h"
#import "XLAvatarView.h"
#import "DBTableMode.h"
#import "XLTreatePatientViewController.h"
#import "MBProgressHUD+XLHUD.h"
#import "XLTeamTool.h"
#import "AccountManager.h"
#import "XLCureCountModel.h"
#import "XLUserInfoViewController.h"

@interface XLDoctorDetailViewController ()
@property (weak, nonatomic) IBOutlet XLAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel; //医生姓名
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *meTransferToOtherCount;//我转给他人
@property (weak, nonatomic) IBOutlet UILabel *otherTransferToMeCount;//他人转给我
@property (weak, nonatomic) IBOutlet UILabel *meInviteOtherCount;//我邀请他人
@property (weak, nonatomic) IBOutlet UILabel *otherInviteMeCount;//他人邀请我

@end

@implementation XLDoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"更多"];
    
    //设置数据
    [self setUpData];
    
    //查询所有数据
    [self requestData];
}
#pragma mark - 拨打电话
- (IBAction)phoneAction:(id)sender {
    if(![NSString isEmptyString:self.doc.doctor_phone]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否拨打该电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }else{
        [SVProgressHUD showImage:nil status:@"电话无效"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)return;
    NSString *number = self.doc.doctor_phone;
    NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}


- (void)setUpData{
    self.doctorNameLabel.text = self.doc.doctor_name;
    self.phoneLabel.text = self.doc.doctor_phone;
    self.avatarView.urlStr = self.doc.doctor_image;
}

- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    XLUserInfoViewController *userInfoVc = [storyboard instantiateViewControllerWithIdentifier:@"XLUserInfoViewController"];
    userInfoVc.doctor = self.doc;
    [self pushViewController:userInfoVc animated:YES];
}

#pragma mark - 查询所有数据
- (void)requestData{
    [XLTeamTool queryAllCountOfPatientWithDoctorId:[AccountManager currentUserid] theraptDocId:self.doc.ckeyid success:^(XLCureCountModel *model) {
        //加载成功
        self.meTransferToOtherCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)model.introByMe.count];
        self.otherTransferToMeCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)model.introByHim.count];
        self.otherInviteMeCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)model.cureByMe.count];
        self.meInviteOtherCount.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)model.cureByHim.count];
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
    
}

#pragma mark - UITableViewDataSource/Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    XLTreatePatientViewController *pVc = [[XLTreatePatientViewController alloc] init];
    pVc.doc = self.doc;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            pVc.title = @"我转给他的患者";
            pVc.type = TreatePatientViewControllerTypeMeToOther;
        }else{
            pVc.title = @"他转给我的患者";
            pVc.type = TreatePatientViewControllerTypeOtherToMe;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            pVc.title = @"我邀请他治疗的患者";
            pVc.type = TreatePatientViewControllerTypeMeInviteOther;
        }else{
            pVc.title = @"他邀请我治疗的患者";
            pVc.type = TreatePatientViewControllerTypeOtherInviteMe;
        }
    }
    
    [self pushViewController:pVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

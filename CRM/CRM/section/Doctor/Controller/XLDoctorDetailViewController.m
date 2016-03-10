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
    
    //设置数据
    [self setUpData];
}
- (IBAction)phoneAction:(id)sender {
    
}

- (void)setUpData{
    self.doctorNameLabel.text = self.doc.doctor_name;
    self.phoneLabel.text = self.doc.doctor_phone;
    self.avatarView.urlStr = self.doc.doctor_image;
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

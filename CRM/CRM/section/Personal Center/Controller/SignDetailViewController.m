//
//  SignDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SignDetailViewController.h"
#import "MyClinicTool.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "ClinicModel.h"
#import "XLClinicModel.h"

@interface SignDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *partyALabel;
@property (weak, nonatomic) IBOutlet UILabel *partyBLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
- (IBAction)signButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;

@end

@implementation SignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNavBarStyle];
    
    //设置控件的值
    [self initViewData];
}

#pragma mark -设置导航栏样式
- (void)setUpNavBarStyle{
    self.title = @"申请签约";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

#pragma mark -设置控件的值
- (void)initViewData{
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    self.partyALabel.text = currentUser.name;
    if (self.signModel) {
        self.partyBLabel.text = self.signModel.clinic_name;
    }else{
        self.partyBLabel.text = self.unSignModel.clinic_name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)signButtonClick:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在申请中，请稍候"];
    
    UserObject *currentUser = [[AccountManager shareInstance] currentUser];
    NSString *clinicId;
    if (self.signModel) {
        clinicId = self.signModel.clinic_id;
    }else{
        clinicId = self.unSignModel.clinic_id;
    }
    
    [MyClinicTool applyForClinicWithDoctorID:currentUser.userid clinicId:clinicId success:^(NSString *result,NSNumber *status) {
        
        //如果是申请成功，则发送一个通知，通知我的预约诊所页面进行刷新
        if ([status intValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DoctorApplyForClinicSuccessNotification object:nil];
        }
        //移除当前控制器
        [self.navigationController popViewControllerAnimated:YES];
        //调用代理的方法
        if ([self.delegate respondsToSelector:@selector(didClickApplyButtonWithResult:)]) {
            [self.delegate didClickApplyButtonWithResult:result];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
    
    
}
@end

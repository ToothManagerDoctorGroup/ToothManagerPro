//
//  AppointDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/16.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "AppointDetailViewController.h"
#import "MyBillTool.h"
#import "BillModel.h"
#import "BillDetailModel.h"
#import "MaterialModel.h"
#import "AssistModel.h"


@interface AppointDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //预约信息
@property (weak, nonatomic) IBOutlet UILabel *patientLabel; //患者姓名
@property (weak, nonatomic) IBOutlet UILabel *toothLabel; //牙位
@property (weak, nonatomic) IBOutlet UILabel *projectLabel; //项目
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel; //预约时长
@property (weak, nonatomic) IBOutlet UILabel *clinicLabel; //诊所名称
@property (weak, nonatomic) IBOutlet UILabel *chairLabel; //椅位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel; //诊所电话
@property (weak, nonatomic) IBOutlet UILabel *remarks; //备注
@property (weak, nonatomic) IBOutlet UILabel *materialLabel; //材料
@property (weak, nonatomic) IBOutlet UILabel *assistentLabel; //助手

@end

@implementation AppointDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNavBarStyle];
    
    //请求网络数据
    [self requestAppoinDetailData];
}

#pragma mark -设置导航栏样式
- (void)setUpNavBarStyle{
    self.title = @"预约信息";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = MyColor(239, 239, 239);
}
#pragma mark -请求网络数据
- (void)requestAppoinDetailData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [MyBillTool requestBillDetailWithBillId:self.model.KeyId success:^(BillDetailModel *billDetail) {
        [SVProgressHUD dismiss];
        
        //设置控件的数据
        self.timeLabel.text = billDetail.reserve_time;
        self.patientLabel.text = billDetail.patient_name;
        self.toothLabel.text = billDetail.tooth_position;
        self.projectLabel.text = billDetail.reserve_type;
        self.appointTimeLabel.text = [NSString stringWithFormat:@"%@小时",billDetail.reserve_duration];
        self.clinicLabel.text = billDetail.clinic_name;
        self.chairLabel.text = billDetail.seat_name;
        
        if (billDetail.materials.count > 0) {
            NSString *materialStr = @"";
            for (MaterialModel *material in billDetail.materials) {
               materialStr = [materialStr stringByAppendingFormat:@"%@%@个 ",material.mat_name,material.actual_num];
            }
            self.materialLabel.text = materialStr;
        }
        
        if (billDetail.assists.count > 0) {
            NSString *assistStr = @"";
            for (AssistModel *assist in billDetail.assists) {
                assistStr = [assistStr stringByAppendingFormat:@"%@%@人 ",assist.assist_name,assist.actual_num];
            }
            self.assistentLabel.text = assistStr;
         }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
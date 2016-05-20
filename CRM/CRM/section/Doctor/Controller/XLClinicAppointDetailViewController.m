//
//  XLClinicAppointDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/5/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLClinicAppointDetailViewController.h"
#import "MyBillTool.h"
#import "BillDetailModel.h"
#import "MaterialModel.h"
#import "AssistModel.h"
#import "PatientDetailViewController.h"

@interface XLClinicAppointDetailViewController ()
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//患者姓名
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
//牙位
@property (weak, nonatomic) IBOutlet UILabel *toothPositionLabel;
//预约类型
@property (weak, nonatomic) IBOutlet UILabel *reserveTypeLabel;
//预约时长
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLabel;
//医院
@property (weak, nonatomic) IBOutlet UILabel *medicalPlaceLabel;
//椅位
@property (weak, nonatomic) IBOutlet UILabel *chairLabel;
//耗材
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
//助手
@property (weak, nonatomic) IBOutlet UILabel *assistLabel;
//备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong)BillDetailModel *currentModel;

@end

@implementation XLClinicAppointDetailViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
   //初始化子视图
    [self setUpSubViews];
    //加载数据
    [self requestAppointData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化子视图
- (void)setUpSubViews{
    self.title = @"预约详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}
#pragma mark 加载诊所数据
- (void)requestAppointData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [MyBillTool requestBillDetailWithBillId:self.clinic_reserve_id success:^(BillDetailModel *billDetail) {
        [SVProgressHUD dismiss];
        
        self.currentModel = billDetail;
        //设置控件的数据
        self.timeLabel.text = billDetail.reserve_time;
        self.patientNameLabel.text = billDetail.patient_name;
        self.toothPositionLabel.text = billDetail.tooth_position;
        self.reserveTypeLabel.text = billDetail.reserve_type;
        self.appointTimeLabel.text = [NSString stringWithFormat:@"%@小时",billDetail.reserve_duration];
        self.medicalPlaceLabel.text = billDetail.clinic_name;
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
            self.assistLabel.text = assistStr;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - ******************* Delegate / DataSource *****************
#pragma mark UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //跳转到患者详情页面
        PatientsCellMode *cellModel = [[PatientsCellMode alloc] init];
        cellModel.patientId = self.currentModel.patient_id;
        PatientDetailViewController *detailVc = [[PatientDetailViewController alloc] init];
        detailVc.patientsCellMode = cellModel;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

@end

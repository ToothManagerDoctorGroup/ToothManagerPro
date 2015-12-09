//
//  TTMPatientDetailController.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMPatientDetailController.h"
#import "PatientDetailHeadInfoView.h"
#import "TTMPatientTool.h"
#import "TTMPatientModel.h"
#import "PatientHeadMedicalRecordView.h"
#import "TTMMedicalCaseModel.h"
#import "TTMCTLibModel.h"

@interface TTMPatientDetailController (){
    PatientDetailHeadInfoView *_headerInfoView; //具体信息
    PatientHeadMedicalRecordView *_headerMedicalView; //病历详细信息
}

@property (nonatomic, strong)NSMutableArray *cTLibs; //存放病历的数据

@property (nonatomic, strong)NSArray *medicalCases;//病历数据

@end

@implementation TTMPatientDetailController

- (NSMutableArray *)cTLibs{
    if (!_cTLibs) {
        _cTLibs = [NSMutableArray array];
    }
    return _cTLibs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    
    //设置子视图
    [self setUpSubViews];
    
    //请求网络数据
    [self queryPatientData];
    
    //请求病例数据
    [self queryMedicalCaseData];
}

#pragma mark - 初始化子视图
- (void)setUpSubViews{
    //患者详情视图
    _headerInfoView = [[PatientDetailHeadInfoView alloc] init];
    _headerInfoView.frame = CGRectMake(0, 64, ScreenWidth, 7 * 35);
    _headerInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerInfoView];
    
    //病历视图
    _headerMedicalView = [[PatientHeadMedicalRecordView alloc] initWithFrame:CGRectMake(5, _headerInfoView.bottom + 5, ScreenWidth - 10, 260)];
    [self.view addSubview:_headerMedicalView];
}

#pragma mark - 请求患者详细信息
- (void)queryPatientData{
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"正在加载..."];
    [TTMPatientTool requestPatientInfoWithpatientId:self.patientId success:^(TTMPatientModel *result) {
        [hud hide:YES];
        _headerInfoView.model = result;
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 请求病历数据
- (void)queryMedicalCaseData{
    [TTMPatientTool requestMedicalCaseWithPatientId:self.patientId success:^(NSArray *result) {
        
        _headerMedicalView.medicalCases = result;
        
        self.medicalCases = result;
        //请求CT数据
        [self queryCTLibDataWithCases:result];
        
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
    
}

#pragma mark - 请求CT数据
- (void)queryCTLibDataWithCases:(NSArray *)cases{
    NSMutableString *caseIdStr = [NSMutableString string];
    [caseIdStr setString:@""];
    NSString *temp;
    if (cases.count > 0) {
        for (TTMMedicalCaseModel *caseModel in cases) {
            [caseIdStr appendFormat:@"%@,",caseModel.ckeyid];
        }
        temp = [caseIdStr substringToIndex:caseIdStr.length - 1];
        
        //查询所有的CT片信息
        [TTMPatientTool requestCTLibWithCaseId:temp success:^(NSArray *result) {
            //所有的CT片信息
            for (TTMMedicalCaseModel *medicalCase in cases) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (TTMCTLibModel *ctModel in result) {
                    if ([ctModel.case_id isEqualToString:medicalCase.ckeyid]) {
                        [tempArr addObject:ctModel];
                    }
                }
                medicalCase.ctLibs = tempArr;
            }
            
            //设置CT片的数据
            _headerMedicalView.medicalCases = self.medicalCases;
            
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

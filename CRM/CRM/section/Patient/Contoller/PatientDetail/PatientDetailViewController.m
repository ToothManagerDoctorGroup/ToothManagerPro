//
//  PatientDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/20.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "PatientDetailHeadInfoView.h"
#import "PatientHeadMedicalRecordView.h"
#import "UIImage+LBImage.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "CommentModelFrame.h"
#import "CommentTextField.h"
#import "MLKMenuPopover.h"

#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "DBManager+Doctor.h"
#import "DBManager+sync.h"
#import "CreateCaseViewController.h"
#import "LocalNotificationCenter.h"
#import "CRMHttpRequest+Sync.h"
#import "IntroducerManager.h"
#import "XLIntroducerViewController.h"
#import "NSDictionary+Extension.h"
#import "CRMMacro.h"
#import "DBTableMode.h"
#import "CRMHttpRequest+Doctor.h"
#import "MyPatientTool.h"
#import "CRMHttpRespondModel.h"

#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "XLPatientAppointViewController.h"
#import "XLDoctorLibraryViewController.h"

#import "DBManager+Doctor.h"
#import "MyPatientTool.h"
#import "XLPatientTotalInfoModel.h"
#import "PatientManager.h"
#import "DBManager+Materials.h"
#import "UIColor+Extension.h"
#import "EditPatientDetailViewController.h"
#import "SDWebImageManager.h"
#import "DoctorManager.h"
#import "AccountManager.h"
#import "MyDateTool.h"
#import "NSString+TTMAddtion.h"
#import "DoctorGroupTool.h"
#import "DoctorTool.h"
#import "XLCustomAlertView.h"
#import "SysMessageTool.h"
#import "XLChatModel.h"
#import "IntroPeopleDetailViewController.h"

#define CommenBgColor MyColor(245, 246, 247)
#define Margin 5

@interface PatientDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MLKMenuPopoverDelegate,PatientHeadMedicalRecordViewDelegate,PatientDetailHeadInfoViewDelegate,XLIntroducerViewControllerDelegate>{
    
    UITableView *_tableView;//表示图
    UIView *_headerView; //头视图的背景视图
    PatientDetailHeadInfoView *_headerInfoView; //具体信息
    PatientHeadMedicalRecordView *_headerMedicalView; //病历详细信息
    
    //输入框背景视图
    UIView *_editView;
    UIImageView *_searchImage; //搜索图片
    CommentTextField *_commentTextField; //会诊信息输入框
    Introducer *selectIntroducer;//当前选中的介绍人
}
//评论
@property (nonatomic, strong)NSMutableArray *comments;
//菜单选项
@property (nonatomic, strong)NSArray *menuList;
//菜单弹出视图
@property (nonatomic, strong)MLKMenuPopover *menuPopover;
//患者模型
@property (nonatomic, strong) Patient *detailPatient;
@property (nonatomic, strong) Introducer *detailIntroducer;
@property (nonatomic, strong) Introducer *changeIntroducer;
@property (nonatomic, strong) NSMutableArray *medicalCases;
@property (nonatomic, strong) NSMutableArray *cTLibs;

@property (nonatomic, strong)MedicalCase *selectCase;
@property (nonatomic, strong)NSMutableArray *orginExistGroups;//用户所在分组信息

@property (nonatomic, assign)BOOL isBind;//是否绑定微信
@end

@implementation PatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    //添加编辑状态监听
    [self addNotificationObserver];
    
    //加载子视图
    [self setUpSubView];
    
    //获取患者分组信息
    [self requestGroupData];
    
    //获取患者的CT片的状态
    [self requestPatientCTsStatus];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加键盘状态监听
    [self addNotification];
    //初始化数据，刷新视图
    [self setUpData];
    [self refreshView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    selectIntroducer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -添加监听
- (void)addNotification{
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘将要出现
- (void)keyboardWasShown:(NSNotification *)note{
    _headerMedicalView.userInteractionEnabled = NO;
    if ([_commentTextField isFirstResponder]) {
        //获取当前键盘的高度
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat keyBoardH = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -keyBoardH);
        }];
    }
}
//键盘将要隐藏
- (void)keyboardWillBeHidden:(NSNotification *)note{
    _headerMedicalView.userInteractionEnabled = YES;
    if ([_commentTextField isFirstResponder]) {
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark -加载数据
- (void)setUpData {
    
    _detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    if (_detailPatient == nil) {
        [SVProgressHUD showImage:nil status:@"患者不存在"];
        return;
    }
    _detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:_detailPatient.introducer_id];
    if (_detailIntroducer == nil && [_detailPatient.introducer_id isEqualToString:[AccountManager currentUserid]]) {
        _detailIntroducer = [[Introducer alloc] init];
        _detailIntroducer.intr_name = [AccountManager shareInstance].currentUser.name;
        _detailIntroducer.ckeyid = [AccountManager currentUserid];
    }
    
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];

        //为控件赋值
    _headerMedicalView.medicalCases = array;
    
    //获取绑定信息
    [self getPaitientIsBind];
}

- (void)refreshView {
    [super refreshView];
    self.detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    
    _headerInfoView.detailPatient = self.detailPatient;
    
    if(self.changeIntroducer != nil){
        self.detailIntroducer = self.changeIntroducer;
    }else{
        self.detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:self.detailPatient.introducer_id];
    }
    
    PatientIntroducerMap *map = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
    if (selectIntroducer != nil) {
        //表明当前是手动选择介绍人
        _headerInfoView.introducerName = selectIntroducer.intr_name;
        _headerInfoView.introduceCanEdit = YES;
    }else{
        if (map == nil) {
            _headerInfoView.introduceCanEdit = YES;
        }else{
            //表明是本地介绍人
            if([map.intr_source isContainsString:@"B"]){
                Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
                NSLog(@"介绍人姓名=%@",introducer.intr_name);
                _headerInfoView.introducerName = introducer.intr_name;
                _headerInfoView.introduceCanEdit = YES;
            }else{
                //如果介绍人表中没有数据，就查询好友
                Doctor *doctor = [[DBManager shareInstance] getDoctorWithCkeyId:map.intr_id];
                if (doctor != nil) {
                    _headerInfoView.introducerName = doctor.doctor_name;
                }
            }
        }
    }
//    Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:self.detailPatient.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
}

- (void)refreshData {
    [super refreshData];
    
    NSLog(@"刷新数据");
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    _headerMedicalView.medicalCases = array;
    
    //重新加载数据
    [self comments];
}
#pragma mark - 获取患者是否绑定微信信息
- (void)getPaitientIsBind{
    //获取患者绑定微信的状态
    WS(weakSelf);
    [MyPatientTool getWeixinStatusWithPatientId:self.detailPatient.ckeyid success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            weakSelf.isBind = YES;
        }else{
            weakSelf.isBind = NO;
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        //未绑定
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - 获取患者的CT状态
- (void)requestPatientCTsStatus{
    //获取所有的CT片的id
    NSArray *cts = [[DBManager shareInstance] getCTLibArrayWithPatientId:self.patientsCellMode.patientId];
    NSMutableString *ctids = [NSMutableString string];
    for (CTLib *ct in cts) {
        [ctids appendFormat:@"%@,",ct.ckeyid];
    }
    if (ctids.length > 0) {
        NSString *idStr = [ctids substringToIndex:ctids.length - 1];
        [MyPatientTool getPatientCTStatusCTCkeyIds:idStr success:^(NSArray *result) {
            //判断获取到的数据状态
            if (result.count > 0) {
                for (XLPatientCTStatusModel *statusM in result) {
                    if (statusM.fileStatus > 0) {
                        if (![[DBManager shareInstance] isExistWithPostType:Insert dataType:AutoSync_CtLib ckeyId:statusM.ckeyid]) {
                            //如果行为表中不存在此数据，则重新添加
                            CTLib *ct = [[DBManager shareInstance] getCTLibWithCKeyId:statusM.ckeyid];
                            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Insert dataEntity:[ct.keyValues JSONString] syncStatus:@"0"];
                            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                        }
                    }
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

#pragma mark - 获取患者分组信息
- (void)requestGroupData{
    [DoctorGroupTool getGroupListWithDoctorId:[AccountManager currentUserid] ckId:@"" patientId:self.patientsCellMode.patientId success:^(NSArray *result) {
        _headerInfoView.currentGroups = result;
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark -加载子视图
- (void)setUpSubView{
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"patient_detail_menu"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = CommenBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    if (_headerInfoView == nil) {
        _headerInfoView = [[PatientDetailHeadInfoView alloc] init];
        _headerInfoView.frame = CGRectMake(0, 0, kScreenWidth, [_headerInfoView getTotalHeight]);
        _headerInfoView.delegate = self;
        _headerInfoView.backgroundColor = [UIColor whiteColor];
    }
    
    if (_headerMedicalView == nil) {
        _headerMedicalView = [[PatientHeadMedicalRecordView alloc] initWithFrame:CGRectMake(5, _headerInfoView.bottom + 5, kScreenWidth - 10, 300)];
        _headerMedicalView.delegate = self;
        
    }
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [_headerInfoView getTotalHeight] + 310)];
        [_headerView addSubview:_headerInfoView];
        [_headerView addSubview:_headerMedicalView];
    }
    
    //搜索视图
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44)];
    _editView.backgroundColor = CommenBgColor;
    [self.view addSubview:_editView];
    
    //搜索按钮
    _searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"medical_info_blue"]];
    _searchImage.frame = CGRectMake(9, 9, 28, 26);
    [_editView addSubview:_searchImage];
    
    //搜索框
    _commentTextField = [[CommentTextField alloc] initWithFrame:CGRectMake(_searchImage.right + Margin * 2, Margin, kScreenWidth - Margin * 6 - _searchImage.width, 44 - Margin * 2)];
    _commentTextField.delegate = self;
    [_editView addSubview:_commentTextField];
    

    //设置tableView的头视图
    _tableView.tableHeaderView = _headerView;
}


#pragma mark -导航栏菜单按钮点击事件
- (void)onRightButtonAction:(id)sender{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.menuPopover showInView:keyWindow];
}

- (void)onBackButtonAction:(id)sender{
    if (self.isNewPatient) {
        UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC setSelectedViewController:[rootVC.viewControllers objectAtIndex:1]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModelFrame *modelF = self.comments[indexPath.row];
    
    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    
    cell.modelFrame = modelF;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModelFrame *modelF = self.comments[indexPath.row];
    return modelF.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //第一组的头视图
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headView.backgroundColor = [UIColor colorWithHex:0x00a0ea];
    //头视图上的标题
    UIButton *consultationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [consultationButton setTitle:@"会诊信息" forState:UIControlStateNormal];
    [consultationButton setImage:[UIImage imageNamed:@"medical_info"] forState:UIControlStateNormal];
    [consultationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    consultationButton.enabled = NO;
    [consultationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    consultationButton.frame = CGRectMake(0, 2.5, 120, 35);
    consultationButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [headView addSubview:consultationButton];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除当前的会诊信息
        CommentModelFrame *modelF = self.comments[indexPath.row];
        //删除本地的会诊信息
        BOOL ret = [[DBManager shareInstance] deletePatientConsultationWithCkeyId_sync:modelF.model.ckeyid];
        if (ret) {
            [self.comments removeObjectAtIndex:indexPath.row];
            //刷新当前被删除的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientConsultation postType:Delete dataEntity:[modelF.model.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isValidLength:600]) {
        [SVProgressHUD showErrorWithStatus:@"内容过长"];
    }else{
        UserObject *user = [[AccountManager shareInstance] currentUser];
        PatientConsultation *model = [self createPatientConsultationWithContent:textField.text];
        CommentModelFrame *modelFrame = [[CommentModelFrame alloc] init];
        modelFrame.model = model;
        modelFrame.headImg_url = user.img;
        
        BOOL result = [[DBManager shareInstance] insertPatientConsultation:model];
        if (result) {
            
            PatientConsultation *tempPatientC = [[DBManager shareInstance] getPatientConsultationWithCkeyId:model.ckeyid];
            if (tempPatientC != nil) {
                //添加会诊信息自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientConsultation postType:Insert dataEntity:[tempPatientC.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count inSection:0];
            
            [self.comments addObject:modelFrame];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
            textField.text = @"";
            
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }
    return YES;
}

#pragma mark -创建一个会诊信息
- (PatientConsultation *)createPatientConsultationWithContent:(NSString *)content{
    
    UserObject *user = [[AccountManager shareInstance] currentUser];
    PatientConsultation *consultation = [[PatientConsultation alloc] init];
    consultation.patient_id = self.patientsCellMode.patientId;
    consultation.doctor_name = user.name;
    consultation.cons_content = content;
    consultation.cons_type = @"0";
    consultation.amr_file = @"";
    consultation.amr_time = @"0";
    consultation.data_flag = 0;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    consultation.sync_time = [NSString defaultDateString];
    consultation.user_id = user.userid;
    consultation.creation_date = [formatter stringFromDate:date];
    consultation.creation_date_sync = [formatter stringFromDate:date];
    consultation.update_date = [formatter stringFromDate:date];
    consultation.doctor_id = user.userid;
    
    return consultation;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    if (selectedIndex == 0) {
        //编辑患者
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        EditPatientDetailViewController *editDetail = [storyboard instantiateViewControllerWithIdentifier:@"EditPatientDetailViewController"];
        editDetail.patient = self.detailPatient;
        [self pushViewController:editDetail animated:YES];
        
    }else if (selectedIndex == 1){
        //查看预约
        XLPatientAppointViewController *appointVc = [[XLPatientAppointViewController alloc] initWithStyle:UITableViewStylePlain];
        appointVc.patient_id = self.detailPatient.ckeyid;
        [self pushViewController:appointVc animated:YES];
    }else if(selectedIndex == 2){
        //转诊患者
        [self referralAction:nil];
    }else if(selectedIndex == 3){
        //判断当前介绍人是否存在
        if([[DBManager shareInstance] isInIntroducerTable:_detailPatient.patient_phone]){
            [SVProgressHUD showImage:nil status:@"该患者已经是您的介绍人"];
        }else{
            TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"升级介绍人" message:@"确定将患者升级为介绍人吗?" cancelHandler:^{
            } comfirmButtonHandlder:^{
                [[IntroducerManager shareInstance] patientToIntroducer:[AccountManager shareInstance].currentUser.userid withCkeyId:_detailPatient.ckeyid withName:_detailPatient.patient_name withPhone:_detailPatient.patient_phone successBlock:^{
                    [SVProgressHUD showWithStatus:@"正在转换..."];
                }failedBlock:^(NSError *error){
                    [SVProgressHUD showImage:nil status:error.localizedDescription];
                }];
            }];
            [alertView show];
        }
    }else if (selectedIndex == 4){
        //更新当前患者的所有数据
        [SVProgressHUD showWithStatus:@"正在下载CT片"];
        [MyPatientTool getPatientAllInfosWithPatientId:self.detailPatient.ckeyid doctorID:[AccountManager currentUserid] success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dic in respond.result) {
                    XLPatientTotalInfoModel *model = [XLPatientTotalInfoModel objectWithKeyValues:dic];
                    [arrayM addObject:model];
                }
                //保存数据到数据库
                [self savePatientDataWithModel:[arrayM lastObject]];
            }else{
                [SVProgressHUD showErrorWithStatus:respond.result];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}
#pragma mark - 保存所有的患者数据到数据库
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model{
    
   BOOL ret = [[DBManager shareInstance] saveAllDownloadPatientInfoWithPatientModel:model];
    if (ret) {
        [SVProgressHUD dismiss];
        //将会诊信息的array清除
        [self.comments removeAllObjects];
        self.comments = nil;
        [self refreshData];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"患者CT片下载失败"];
    }
    
}
//转诊患者
- (void)referralAction:(id)sender {
    XLDoctorLibraryViewController *doctorVC = [[XLDoctorLibraryViewController alloc] init];
    if (self.detailPatient != nil) {
        doctorVC.isTransfer = YES;
        doctorVC.userId = self.detailPatient.doctor_id;
        doctorVC.patientId = self.detailPatient.ckeyid;
        [self pushViewController:doctorVC animated:YES];
    }
}
//患者转介绍人
- (void)patientToIntroducerSuccess:(NSDictionary *)result{
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showImage:nil status:@"升级成功"];
        //获取提醒数据
        __weak typeof(self) weakSelf = self;
        [DoctorTool newYuYueMessagePatient:_detailPatient.ckeyid fromDoctor:[AccountManager currentUserid] therapyDoctorId:@"" withMessageType:@"介绍人" withSendType:@"1" withSendTime:[MyDateTool stringWithDateWithSec:[NSDate date]] success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:respond.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:weakSelf.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
                    [weakSelf jumpToIntroducerListViewWithDic:result];
                } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                    [SVProgressHUD showWithStatus:@"正在发送"];
                    [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:_detailPatient.ckeyid isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                        if ([respond.code integerValue] == 200) {
                            [SVProgressHUD showImage:nil status:@"消息发送成功"];
                            
                            //将消息保存在消息记录里
                            XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:_detailPatient.ckeyid receiverName:_detailPatient.patient_name content:content];
                            [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
                            
                            //发送环信消息
                            [EaseSDKHelper sendTextMessage:content
                                                        to:_detailPatient.ckeyid
                                               messageType:eMessageTypeChat
                                         requireEncryption:NO
                                                messageExt:nil];
                        }else{
                            [SVProgressHUD showImage:nil status:@"消息发送失败"];
                        }
                        [weakSelf jumpToIntroducerListViewWithDic:result];
                    } failure:^(NSError *error) {
                        [SVProgressHUD showImage:nil status:error.localizedDescription];
                        if (error) {
                            NSLog(@"error:%@",error);
                        }
                    }];
                }];
                [alertView show];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:error.localizedDescription];
            [weakSelf jumpToIntroducerListViewWithDic:result];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    } else {
        [SVProgressHUD showImage:nil status:@"升级失败"];
    }
}
#pragma mark - 跳转到介绍人详情页面
- (void)jumpToIntroducerListViewWithDic:(NSDictionary *)dic{
    //存入介绍人库
    Introducer *introducer = [Introducer IntroducerFromIntroducerResult:[self dicFromJsonStr:dic[@"Result"]]];
    [[DBManager shareInstance] insertIntroducer:introducer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerCreatedNotification object:nil];
    
    IntroPeopleDetailViewController * detailCtl = [[IntroPeopleDetailViewController alloc] init];
    [detailCtl setIntroducer:introducer];
    detailCtl.hidesBottomBarWhenPushed = YES;
    [self pushViewController:detailCtl animated:YES];
}

- (void)patientToIntroducerFailed:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark - 将json字符串转换为字典
- (NSDictionary *)dicFromJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

#pragma mark -PatientHeadMedicalRecordViewDelegate
- (void)didClickAddMedicalButton{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
    caseVC.title = @"新建病历";
    caseVC.isBind = self.isBind;
    caseVC.patiendId = self.detailPatient.ckeyid;
    [self pushViewController:caseVC animated:YES];
}
- (void)didClickeditMedicalButtonWithMedicalCase:(MedicalCase *)medicalCase{
    MedicalCase *mcase = medicalCase;
    _selectCase = mcase;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
    caseVC.title = @"病历详情";
    caseVC.edit = YES;
    caseVC.isBind = self.isBind;
    caseVC.medicalCaseId = mcase.ckeyid;
    [self pushViewController:caseVC animated:YES];
}

#pragma mark - NOtification
- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCancleSuccessNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    [self removeObserverNotificationWithName:MedicalCaseCancleSuccessNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MedicalCaseEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseCancleSuccessNotification]) {
        [self refreshData];
        [self refreshView];
    }
}

#pragma mark - PatientDetailHeadInfoViewDelegate
- (void)didSelectIntroducer{
    XLIntroducerViewController *introducerVC = [[XLIntroducerViewController alloc] init];
    introducerVC.delegate = self;
    introducerVC.Mode = IntroducePersonViewSelect;
    [self.navigationController pushViewController:introducerVC animated:YES];
}

#pragma mark - XLIntroducerViewControllerDelegate
- (void)didSelectedIntroducer:(Introducer *)intro{
    
    if ([self.detailPatient.patient_name isEqualToString:intro.intr_name] && [self.detailPatient.patient_phone isEqualToString:intro.intr_phone]) {
        [SVProgressHUD showErrorWithStatus:@"不能选择自己为介绍人"];
        return;
    }
    
    selectIntroducer = nil;
    selectIntroducer = [Introducer intoducerFromIntro:intro];
    
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    patient.introducer_id = selectIntroducer.ckeyid;//表明是本地介绍人
    patient.intr_name = selectIntroducer.intr_name;//介绍人姓名
    //更新患者信息
    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    
    //获取原来的介绍人信息
    PatientIntroducerMap *mapOrigin = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
    if (mapOrigin != nil) {
        //表明存在本地介绍人,当前操作是修改
        mapOrigin.intr_id = selectIntroducer.ckeyid;
        mapOrigin.intr_source = @"B";
        mapOrigin.patient_id = self.patientsCellMode.patientId;
        mapOrigin.doctor_id = [AccountManager shareInstance].currentUser.userid;
        mapOrigin.intr_time = [NSString currentDateString];
        
        if([[DBManager shareInstance] updatePatientIntroducerMap:mapOrigin]){
            //获取介绍人患者信息
            PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:mapOrigin.patient_id doctorId:mapOrigin.doctor_id intrId:mapOrigin.intr_id];
            if (tempMap != nil) {
                //添加一条自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PatientEditedNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerEditedNotification object:nil];
        }
    }else{
        //表明是新增介绍人
        PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
        map.intr_id = selectIntroducer.ckeyid;
        map.intr_source = @"B";
        map.patient_id = self.patientsCellMode.patientId;
        map.doctor_id = [AccountManager shareInstance].currentUser.userid;
        map.intr_time = [NSString currentDateString];
        
        
        if([[DBManager shareInstance] insertPatientIntroducerMap:map]){
            //获取介绍人患者信息
            PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:map.patient_id doctorId:map.doctor_id intrId:map.intr_id];
            if (tempMap != nil) {
                //添加一条自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:PatientEditedNotification object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:IntroducerEditedNotification object:nil];
            }
        }
    }
}

- (void)insertPatientIntroducerMapWithPatient:(Patient *)patient{
    if ([selectIntroducer.intr_id isEqualToString:@"0"]) {
        [[CRMHttpRequest shareInstance] postPatientIntroducerMap:patient.ckeyid withDoctorId:[AccountManager shareInstance].currentUser.userid withIntrId:selectIntroducer.ckeyid];
    }
}

-(void)postPatientIntroducerMapSuccess:(NSDictionary *)result{
    [SVProgressHUD showImage:nil status:@"修改完成"];
    
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = selectIntroducer.ckeyid;
    map.intr_source = @"B";
    map.patient_id = self.patientsCellMode.patientId;
    map.doctor_id = [AccountManager shareInstance].currentUser.userid;
    map.intr_time = [NSString currentDateString];
    
    if([[DBManager shareInstance] insertPatientIntroducerMap:map]){
        //获取介绍人患者信息
        PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:map.patient_id doctorId:map.doctor_id intrId:map.intr_id];
        if (tempMap != nil) {
            //添加一条自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        
    }
}
-(void)postPatientIntroducerMapFailed:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}


- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark - 初始化子控件
- (NSMutableArray *)orginExistGroups{
    if (!_orginExistGroups) {
        _orginExistGroups = [NSMutableArray array];
    }
    return _orginExistGroups;
}

- (MLKMenuPopover *)menuPopover{
    if (!_menuPopover) {
        MLKMenuPopover *menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(kScreenWidth - 120 - 8, 64, 120, self.menuList.count * 44) menuItems:self.menuList];
        menuPopover.menuPopoverDelegate = self;
        _menuPopover = menuPopover;
    }
    return _menuPopover;
}

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"编辑患者",@"查看预约",@"转诊患者",@"升为介绍人",@"下载CT片", nil];
    }
    return _menuList;
}

- (NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
        
        UserObject *currentUser = [[AccountManager shareInstance] currentUser];
        NSArray *commentArr = [[DBManager shareInstance] getPatientConsultationWithPatientId:self.patientsCellMode.patientId];
        if (commentArr.count > 0) {
            for (int i = 0; i < commentArr.count; i++) {
                PatientConsultation *model = commentArr[i];
                CommentModelFrame *modelFrame = [[CommentModelFrame alloc] init];
                modelFrame.model = model;
                Doctor *doctor = [[DBManager shareInstance] getDoctorWithCkeyId:model.doctor_id];
                if ([currentUser.userid isEqualToString:model.doctor_id]) {
                    modelFrame.headImg_url = currentUser.img;
                }else{
                    modelFrame.headImg_url = doctor.doctor_image;
                }
                [_comments addObject:modelFrame];
            }
            //刷新单元格
            [_tableView reloadData];
        }
    }
    return _comments;
}

- (void)dealloc{
    NSLog(@"患者详情列表被销毁");
    _tableView = nil;
    _headerView = nil;
    _headerInfoView = nil;
    _headerMedicalView = nil;
    _editView = nil;
    _searchImage = nil;
    _commentTextField = nil;
    selectIntroducer = nil;
    
    [_comments removeAllObjects];
    _comments = nil;
    _menuList = nil;
    _menuPopover = nil;
    
    _detailPatient = nil;
    _detailIntroducer = nil;
    _changeIntroducer = nil;
    [_medicalCases removeAllObjects];
    _medicalCases = nil;
    [_cTLibs removeAllObjects];
    _cTLibs = nil;
    _selectCase = nil;
}

@end

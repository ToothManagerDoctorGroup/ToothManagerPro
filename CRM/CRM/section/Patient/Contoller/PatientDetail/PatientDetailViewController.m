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

#import "PatientEditViewController.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "DBManager+Doctor.h"
#import "DBManager+sync.h"
#import "CreateCaseViewController.h"
#import "LocalNotificationCenter.h"
#import "SelectDateViewController.h"
#import "CRMHttpRequest+Sync.h"
#import "IntroducerManager.h"
#import "XLIntroducerViewController.h"
#import "NSDictionary+Extension.h"
#import "CRMMacro.h"
#import "DBTableMode.h"
#import "CRMHttpRequest+Doctor.h"
#import "MyPatientTool.h"
#import "AddReminderViewController.h"
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
    
    Introducer *selectIntroducer;
}
/**
 *  评论
 */
@property (nonatomic, strong)NSMutableArray *comments;

/**
 *  菜单选项
 */
@property (nonatomic, strong)NSArray *menuList;
/**
 *  菜单弹出视图
 */
@property (nonatomic, strong)MLKMenuPopover *menuPopover;
/**
 *  患者模型
 */
@property (nonatomic,retain) Patient *detailPatient;
@property (nonatomic,retain) Introducer *detailIntroducer;
@property (nonatomic,retain) Introducer *changeIntroducer;
@property (nonatomic, strong)NSMutableArray *medicalCases;
@property (nonatomic, strong)NSMutableArray *cTLibs;

@property (nonatomic, strong)MedicalCase *selectCase;


@end

@implementation PatientDetailViewController

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
        _menuList = [NSArray arrayWithObjects:@"编辑患者",@"查看预约",@"转诊患者",@"转为介绍人",@"下载CT片", nil];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //添加键盘状态监听
    [self addNotification];
    
    [self initData];
    [self refreshView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    selectIntroducer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加编辑状态监听
    [self addNotificationObserver];
    
    //初始化导航栏
    [self initView];
    
    //加载子视图
    [self setUpSubView];
}

#pragma mark -添加监听
- (void)addNotification{
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
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


#pragma mark -初始化
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"patient_detail_menu"]];
    self.view.backgroundColor = CommenBgColor;
    
}

#pragma mark -加载数据
- (void)initData {
    [super initData];
    
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
    
    
}

- (void)refreshView {
    [super refreshView];
    self.detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    //获取患者绑定微信的状态
    [MyPatientTool getWeixinStatusWithPatientId:self.detailPatient.ckeyid success:^(CRMHttpRespondModel *respondModel) {
        if ([respondModel.result isEqualToString:@"1"]) {
            //绑定
            _headerInfoView.isWeixin = YES;
        }else{
            //未绑定
            _headerInfoView.isWeixin = NO;
        }

    } failure:^(NSError *error) {
        //未绑定
        _headerInfoView.isWeixin = NO;
        if (error) {
             NSLog(@"error:%@",error);
        }
    }];
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
        //表明是本地介绍人
        if([map.intr_source rangeOfString:@"B"].location != NSNotFound){
            Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
            NSLog(@"介绍人姓名=%@",introducer.intr_name);
            _headerInfoView.introducerName = introducer.intr_name;
            _headerInfoView.introduceCanEdit = YES;
        }else{
            //表明是网络介绍人
            Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
            NSLog(@"介绍人=%@",introducer.intr_name);
            if (introducer == nil) {
                //如果介绍人表中没有数据，就查询好友
                Doctor *doctor = [[DBManager shareInstance] getDoctorWithCkeyId:map.intr_id];
                if (doctor != nil) {
                    _headerInfoView.introducerName = doctor.doctor_name;
                }
            }else{
                _headerInfoView.introducerName = introducer.intr_name;
            }
            
        }

    }
    
    Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:self.detailPatient.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
    _headerInfoView.transferStr = doc.doctor_name;
}

- (void)refreshData {
    [super refreshData];
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];

    _headerMedicalView.medicalCases = array;
}

#pragma mark -加载子视图
- (void)setUpSubView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = CommenBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
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
        [self referralAction:nil];
    }else if(selectedIndex == 3){
        //判断当前介绍人是否存在
        if([[DBManager shareInstance] isInIntroducerTable:_detailPatient.patient_phone]){
            [SVProgressHUD showImage:nil status:@"介绍人已存在，不能重复转换"];
        }else{
            [[IntroducerManager shareInstance] patientToIntroducer:[AccountManager shareInstance].currentUser.userid withCkeyId:_detailPatient.ckeyid withName:_detailPatient.patient_name withPhone:_detailPatient.patient_phone successBlock:^{
                [SVProgressHUD showWithStatus:@"正在转换..."];
            }failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }else if (selectedIndex == 4){
        //更新当前患者的所有数据
        [SVProgressHUD showWithStatus:@"正在下载CT片"];
        [MyPatientTool getPatientAllInfosWithPatientId:self.detailPatient.ckeyid doctorID:[AccountManager currentUserid] success:^(NSArray *results) {
            //保存数据到数据库
            [self savePatientDataWithModel:[results lastObject]];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"患者CT片更新失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}
#pragma mark - 保存所有的患者数据到数据库
- (void)savePatientDataWithModel:(XLPatientTotalInfoModel *)model{
    
    NSInteger total = 1 + model.medicalCase.count + model.medicalCourse.count + model.cT.count + model.consultation.count + model.expense.count + model.introducerMap.count;
    NSInteger current = 0;
    //保存患者消息
    Patient *patient = [Patient PatientFromPatientResult:model.baseInfo];
    [[DBManager shareInstance] insertPatient:patient];
    //稍后条件判断是否成功的代码
    if([[DBManager shareInstance] insertPatientBySync:patient]){
        current++;
    };
    
    //判断medicalCase数据是否存在
    if (model.medicalCase.count > 0) {
        //保存病历数据
        for (NSDictionary *dic in model.medicalCase) {
            MedicalCase *medicalCase = [MedicalCase MedicalCaseFromPatientMedicalCase:dic];
            if([[DBManager shareInstance] insertMedicalCase:medicalCase]){
                current++;
            };
        }
        
    }
    //判断medicalCourse数据是否存在
    if (model.medicalCourse.count > 0) {
        for (NSDictionary *dic in model.medicalCourse) {
            MedicalRecord *medicalrecord = [MedicalRecord MRFromMRResult:dic];
            if([[DBManager shareInstance] insertMedicalRecord:medicalrecord]){
                current++;
            }
        }
    }
    
    //判断CT数据是否存在
    if (model.cT.count > 0) {
        for (NSDictionary *dic in model.cT) {
            CTLib *ctlib = [CTLib CTLibFromCTLibResult:dic];
            if([[DBManager shareInstance] insertCTLib:ctlib]){
                current++;
            }
            if ([ctlib.ct_image isNotEmpty]) {
                NSString *urlImage = [NSString stringWithFormat:@"%@%@_%@", ImageDown, ctlib.ckeyid, ctlib.ct_image];
                NSURL *imageUrl = [NSURL URLWithString:urlImage];
                if ([PatientManager IsImageExisting:ctlib.ct_image]) {
                    [[SDImageCache sharedImageCache] removeImageForKey:ctlib.ct_image];
                }
                [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (nil != image) {
                        [PatientManager pathImageSaveToDisk:image withKey:ctlib.ct_image];
                    }
                }];
                
            }
        }
    }
    
    //判断consultation数据是否存在
    if (model.consultation.count > 0) {
        for (NSDictionary *dic in model.consultation) {
            PatientConsultation *patientC = [PatientConsultation PCFromPCResult:dic];
            if([[DBManager shareInstance] insertPatientConsultation:patientC]){
                current++;
            }
        }
    }
    
    //判断expense数据是否存在
    if (model.expense.count > 0) {
        for (NSDictionary *dic in model.expense) {
            MedicalExpense *medicalexpense = [MedicalExpense MEFromMEResult:dic];
            if([[DBManager shareInstance] insertMedicalExpenseWith:medicalexpense]){
                current++;
            }
        }
    }
    
    //判断introducerMap数据是否存在
    if (model.introducerMap.count > 0) {
        for (NSDictionary *dic in model.introducerMap) {
            PatientIntroducerMap *map = [PatientIntroducerMap PIFromMIResult:dic];
            if ([[DBManager shareInstance] insertPatientIntroducerMap:map]) {
                current++;
            }
        }
    }
    if (total == current) {
//        [SVProgressHUD showSuccessWithStatus:@"CT片下载成功，请重新打开患者信息"];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadDataSuccessWithModel:)]) {
//            [self.delegate didLoadDataSuccessWithModel:self.patientsCellMode];
//        }
//        [self popViewControllerAnimated:YES];
        [self refreshData];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"患者CT片下载失败"];
    }
}
//获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
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
//新建提醒
- (void)createNotificationAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
    addReminderVC.isAddLocationToPatient = YES;
    addReminderVC.patient = self.detailPatient;
    [self.navigationController pushViewController:addReminderVC animated:YES];
}

//患者转介绍人
- (void)patientToIntroducerSuccess:(NSDictionary *)result{
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showImage:nil status:@"转换成功"];
        //存入介绍人库
        Introducer *introducer = [Introducer IntroducerFromIntroducerResult:[self dicFromJsonStr:result[@"Result"]]];
        [[DBManager shareInstance] insertIntroducer:introducer];
        
        XLIntroducerViewController *introducerVC = [[XLIntroducerViewController alloc] init];
        [self pushViewController:introducerVC animated:YES];
    } else {
        [SVProgressHUD showImage:nil status:@"转换失败"];
    }
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
    caseVC.medicalCaseId = mcase.ckeyid;
    [self pushViewController:caseVC animated:YES];
}

#pragma mark - NOtification
- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:MedicalCaseEditedNotification];
    [self addObserveNotificationWithName:MedicalCaseCancleSuccessNotification];
    // [self addObserveNotificationWithName:PatientTransferNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:MedicalCaseEditedNotification];
    //  [self removeObserverNotificationWithName:PatientTransferNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MedicalCaseEditedNotification]
        || [notifacation.name isEqualToString:MedicalCaseEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }else if ([notifacation.name isEqualToString:MedicalCaseCancleSuccessNotification]){
        [self refreshData];
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
    
    //获取原来的介绍人信息
    PatientIntroducerMap *mapOrigin = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
    if (mapOrigin != nil) {
        if([mapOrigin.intr_source rangeOfString:@"B"].location != NSNotFound){
            //表明存在本地介绍人,当前操作是修改
            mapOrigin.intr_id = selectIntroducer.ckeyid;
            mapOrigin.intr_source = @"B";
            mapOrigin.patient_id = self.patientsCellMode.patientId;
            mapOrigin.doctor_id = [AccountManager shareInstance].currentUser.userid;
            mapOrigin.intr_time = [NSString currentDateString];
            
            if ([[DBManager shareInstance] updatePatient:patient]) {
                //添加一条自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
                if([[DBManager shareInstance] updatePatientIntroducerMap:mapOrigin]){
                    //获取介绍人患者信息
                    PatientIntroducerMap *tempMap = [[DBManager shareInstance] getPatientIntroducerMapByPatientId:mapOrigin.patient_id doctorId:mapOrigin.doctor_id intrId:mapOrigin.intr_id];
                    if (tempMap != nil) {
                        //添加一条自动同步信息
                        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_PatientIntroducerMap postType:Insert dataEntity:[tempMap.keyValues JSONString] syncStatus:@"0"];
                        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                    }
                }
            }
        }
    }else{
        //表明是新增介绍人
        PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
        map.intr_id = selectIntroducer.ckeyid;
        map.intr_source = @"B";
        map.patient_id = self.patientsCellMode.patientId;
        map.doctor_id = [AccountManager shareInstance].currentUser.userid;
        map.intr_time = [NSString currentDateString];
        
        if ([[DBManager shareInstance] updatePatient:patient]) {
            //添加一条自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            
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

@end

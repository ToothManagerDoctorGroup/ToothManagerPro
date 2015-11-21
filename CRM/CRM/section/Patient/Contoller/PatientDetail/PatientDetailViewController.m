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
#import "DoctorLibraryViewController.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "DBManager+Doctor.h"
#import "DBManager+sync.h"
#import "CreateCaseViewController.h"

#define CommenBgColor MyColor(245, 246, 247)
#define Margin 5

@interface PatientDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MLKMenuPopoverDelegate,PatientHeadMedicalRecordViewDelegate>{
    UITableView *_tableView;//表示图
    UIView *_headerView; //头视图的背景视图
    PatientDetailHeadInfoView *_headerInfoView; //具体信息
    PatientHeadMedicalRecordView *_headerMedicalView; //病历详细信息
    
    //输入框背景视图
    UIView *_editView;
    UIImageView *_searchImage; //搜索图片
    CommentTextField *_commentTextField; //搜索框
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

@end

@implementation PatientDetailViewController

- (MLKMenuPopover *)menuPopover{
    if (!_menuPopover) {
        MLKMenuPopover *menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(kScreenWidth - 140 - 8, 0, 140, self.menuList.count * 44) menuItems:self.menuList];
        menuPopover.menuPopoverDelegate = self;
        _menuPopover = menuPopover;
    }
    return _menuPopover;
}

- (NSArray *)menuList{
    if (_menuList == nil) {
        _menuList = [NSArray arrayWithObjects:@"编辑患者",@"转诊患者",@"增加提醒",@"转为介绍人", nil];
    }
    return _menuList;
}

- (NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++) {
            CommentModel *model = [[CommentModel alloc] init];
            model.name = [NSString stringWithFormat:@"张三%d",i];
            model.time = @"2015-10-09 12:13:05";
            model.content = @"我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论我是评论";
            CommentModelFrame *modelFrame = [[CommentModelFrame alloc] init];
            modelFrame.model = model;
            
            [_comments addObject:modelFrame];
        }
    }
    return _comments;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initData];
    [self refreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加监听
    [self addNotification];
    
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
    //获取当前键盘的高度
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
     CGFloat keyBoardH = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyBoardH);
    }];
}
//键盘将要隐藏
- (void)keyboardWillBeHidden:(NSNotification *)note{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark -初始化
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"菜单"]];
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
    _medicalCases = [NSMutableArray arrayWithCapacity:0];
    _cTLibs = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    for (MedicalCase *mCase in array) {
        [_medicalCases addObject:mCase];
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:mCase.ckeyid];
        if (libArray != nil && libArray.count > 0) {
            [_cTLibs addObject:libArray];
        } else {
            CTLib *libtmp = [[CTLib alloc]init];
            libtmp.ckeyid = @"-100";
            libtmp.ct_image = @"ctlib_placeholder.png";
            libtmp.creationdate = mCase.creation_date;
            libtmp.ct_desc = mCase.creation_date;
            [_cTLibs addObject:@[libtmp]];
        }
    }
    
    //为控件赋值
    _headerMedicalView.medicalCases = _medicalCases;
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
    if([map.intr_source rangeOfString:@"B"].location != NSNotFound){
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
        NSLog(@"介绍人姓名=%@",introducer.intr_name);
        _headerInfoView.introducerName = introducer.intr_name;
    }else{
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
        NSLog(@"介绍人=%@",introducer.intr_name);
        _headerInfoView.introducerName = introducer.intr_name;
    }
    
    Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:self.detailPatient.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
    _headerInfoView.transferStr = doc.doctor_name;
    NSLog(@"转诊到=%@",doc.doctor_name);
}

- (void)refreshData {
    [super refreshData];
    _cTLibs = nil;
    _medicalCases = nil;
    _cTLibs = [NSMutableArray arrayWithCapacity:0];
    _medicalCases = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    for (MedicalCase *mCase in array) {
        [_medicalCases addObject:mCase];
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:mCase.ckeyid];
        if (libArray != nil && libArray.count > 0) {
            [_cTLibs addObject:libArray];
        } else {
            CTLib *libtmp = [[CTLib alloc]init];
            libtmp.ckeyid = @"-100";
            libtmp.ct_image = @"ctlib_placeholder.png";
            libtmp.creationdate = mCase.creation_date;
            libtmp.ct_desc = mCase.creation_date;
            [_cTLibs addObject:@[libtmp]];
        }
    }
}

#pragma mark -加载子视图
- (void)setUpSubView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = CommenBgColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (_headerInfoView == nil) {
        _headerInfoView = [[PatientDetailHeadInfoView alloc] init];
        _headerInfoView.frame = CGRectMake(0, 0, kScreenWidth, [_headerInfoView getTotalHeight]);
        _headerInfoView.backgroundColor = [UIColor whiteColor];
    }
    
    if (_headerMedicalView == nil) {
        _headerMedicalView = [[PatientHeadMedicalRecordView alloc] initWithFrame:CGRectMake(5, _headerInfoView.bottom + 5, kScreenWidth - 10, 260)];
        _headerMedicalView.delegate = self;
        
    }
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [_headerInfoView getTotalHeight] + 270)];
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
    [self.menuPopover showInView:self.view];
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
    headView.backgroundColor = MyColor(19, 152, 234);
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
    
    //创建一个model
    CommentModel *model = [[CommentModel alloc] init];
    model.name = @"李四";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    model.time = dateStr;
    model.content = textField.text;
    
    CommentModelFrame *modelFrame = [[CommentModelFrame alloc] init];
    modelFrame.model = model;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count inSection:0];
    
    [self.comments addObject:modelFrame];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    textField.text = @"";
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    if(selectedIndex == 0){
        PatientEditViewController *edit = [[PatientEditViewController alloc]initWithNibName:@"PatientEditViewController" bundle:nil];
        edit.patientsCellMode = self.patientsCellMode;
        [self pushViewController:edit animated:YES];
    }else if(selectedIndex == 1){
        [self referralAction:nil];
    }else if (selectedIndex == 2){
//        [self createNotificationAction:nil];
    }else if (selectedIndex == 3){
        NSLog(@"%@---%@",_detailPatient.ckeyid,self.patientsCellMode.patientId);
        
//        [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:[NSArray arrayWithObjects:_detailPatient, nil]];
//        [NSThread sleepForTimeInterval: 0.5];
//        
//        [[IntroducerManager shareInstance]patientToIntroducer:[AccountManager shareInstance].currentUser.userid withCkeyId:_detailPatient.ckeyid withName:_detailPatient.patient_name withPhone:_detailPatient.patient_phone successBlock:^{
//            [SVProgressHUD showWithStatus:@"正在转换..."];
//        }failedBlock:^(NSError *error){
//            [SVProgressHUD showImage:nil status:error.localizedDescription];
//        }];
    }
}
//转诊患者
- (void)referralAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
    DoctorLibraryViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
    if (self.detailPatient != nil) {
        doctorVC.isTransfer = YES;
        doctorVC.userId = self.detailPatient.doctor_id;
        doctorVC.patientId = self.detailPatient.ckeyid;
        [self pushViewController:doctorVC animated:YES];
    }
}

#pragma mark -PatientHeadMedicalRecordViewDelegate
- (void)didClickAddMedicalButton{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
    caseVC.title = @"新建病历";
    caseVC.patiendId = self.detailPatient.ckeyid;
    [self pushViewController:caseVC animated:YES];
}
@end

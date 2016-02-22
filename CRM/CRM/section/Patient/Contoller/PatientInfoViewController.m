//
//  PatientInfoViewController.m
//  CRM
//
//  Created by TimTiger on 10/23/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "PatientInfoViewController.h"
#import "PatientInfoHeaderViewController.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Introducer.h"
#import "PatientsCellMode.h"
#import "TimPickerTextField.h"
#import "IntroducerViewController.h"
#import "TimNavigationViewController.h"
#import "CreateCaseViewController.h"
#import "PatientCaseTableViewCell.h"
#import "TimAlertView.h"
#import "SVProgressHUD.h"
#import "SDImageCache.h"
#import "NSString+Conversion.h"
#import "CRMMacro.h"
#import "DoctorLibraryViewController.h"
#import "LocalNotificationCenter.h"
#import "IntroducerCellMode.h"
#import "DBManager+Doctor.h"
#import "PatientEditViewController.h"
#import "IntroducerManager.h"
#import "NSDictionary+Extension.h"
#import "DBManager+sync.h"
#import "CRMHttpRequest+Sync.h"
#import "PatientConsultationViewController.h"

@interface PatientInfoViewController () <IntroducePersonViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,PatientCaseTableViewCellDelegate>{
    NSArray *_menuDataArray;
    UIView *_moreBgView;
    UITableView *_moreTableView;
    UIView *_clearView;
}
@property (nonatomic,retain) Patient *detailPatient;
@property (nonatomic,retain) Introducer *detailIntroducer;
@property (nonatomic,retain) Introducer *changeIntroducer;
@property (nonatomic,retain) PatientInfoHeaderViewController *headerViewController;
@property (nonatomic,retain) NSMutableArray *dataSouceArray;
@property (nonatomic,retain) NSMutableArray *caseArray;
@end

@implementation PatientInfoViewController

#pragma mark - Life Cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotificationObserver];
    
    //下拉菜单
    NSDictionary *bianji = [[NSDictionary alloc] initWithObjectsAndKeys:@"编辑患者", @"name",[NSNumber numberWithInt:0],@"row", nil];
    NSDictionary *xinjian = [[NSDictionary alloc] initWithObjectsAndKeys:@"新建病历", @"name",[NSNumber numberWithInt:1],@"row", nil];
    NSDictionary *zhuanzhen = [[NSDictionary alloc] initWithObjectsAndKeys:@"转诊患者", @"name",[NSNumber numberWithInt:2],@"row", nil];
    NSDictionary *tixing = [[NSDictionary alloc] initWithObjectsAndKeys:@"增加提醒", @"name",[NSNumber numberWithInt:3],@"row", nil];
    NSDictionary *zhuanhuan = [[NSDictionary alloc] initWithObjectsAndKeys:@"转为介绍人", @"name",[NSNumber numberWithInt:4],@"row", nil];
   // NSDictionary *huizhen = [[NSDictionary alloc] initWithObjectsAndKeys:@"会诊信息", @"name",[NSNumber numberWithInt:5],@"row", nil];
    _menuDataArray = [NSArray arrayWithObjects:bianji,xinjian,zhuanzhen,tixing,zhuanhuan, nil];
    _moreBgView = [[UIView alloc] initWithFrame:CGRectMake(320, 61, 134, 184+46)];
    NSString *imgName = @"moreListBg5";
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [_moreBgView addSubview:img];
    
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 7, 132, 180+44) style:UITableViewStylePlain];
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.scrollEnabled = NO;
    _moreTableView.backgroundColor = [UIColor clearColor];
    _moreTableView.separatorColor = [UIColor clearColor];
    [_moreBgView addSubview:_moreTableView];
    
    _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _clearView.backgroundColor = [UIColor blackColor];
    _clearView.alpha = 0.5;
    UITapGestureRecognizer *clearViewTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clearViewTap)];
    [clearViewTap setNumberOfTapsRequired:1];
    [_clearView addGestureRecognizer:clearViewTap];
    _clearView.userInteractionEnabled = YES;
    clearViewTap.delegate = self;
    
}

-(void)clearViewTap{
    [_clearView removeFromSuperview];
    [_moreBgView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initData];
    [self refreshView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44);
}
- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"患者详情";
   // [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet.png"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_Personal center"]];
    [self setupTableView];
}

- (void)setupTableView {
    if (_headerViewController == nil) {
        UIStoryboard *patientStoryboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        _headerViewController = [patientStoryboard instantiateViewControllerWithIdentifier:@"PatientInfoHeaderViewController"];
        [_headerViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width,170)];
        _headerViewController.patientNameLabel.text = _detailPatient.patient_name;
        _headerViewController.patientPhoneLabel.text = _detailPatient.patient_phone;
        /*
        if(_detailIntroducer.intr_name != nil){
            _headerViewController.introducerNameLabel.text = _detailIntroducer.intr_name;
        }else{
            Doctor *doctor2 = [[DBManager shareInstance] getDoctorWithCkeyId:self.detailPatient.introducer_id];
            self.headerViewController.introducerNameLabel.text = doctor2.doctor_name;
        }*/
        
        PatientIntroducerMap *map = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
        if([map.intr_source rangeOfString:@"B"].location != NSNotFound){
            Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
            _headerViewController.introducerNameLabel.text = introducer.intr_name;
        }else{
            Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
            _headerViewController.introducerNameLabel.text = introducer.intr_name;
        }
        /*
        Doctor *doctor1 = [[DBManager shareInstance] getDoctorWithCkeyId:_detailPatient.doctor_id];
        if(![doctor1.doctor_name isEqualToString:[AccountManager shareInstance].currentUser.name]){
            self.headerViewController.transferTextField.text = doctor1.doctor_name;
        }*/
        
        
        Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:self.detailPatient.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
        self.headerViewController.transferTextField.text = doc.doctor_name;
        
        
        [self updateIntroducerNameTextFieldState];
        
        [self.tableView setTableHeaderView:self.headerViewController.view];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        _headerViewController.introducerNameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
        _headerViewController.introducerNameLabel.enabled = NO;
        _headerViewController.patientNameLabel.enabled = NO;
        _headerViewController.patientPhoneLabel.enabled = NO;
    }
}
- (void)updateIntroducerNameTextFieldState{
    //“介绍人”若在本地介绍人库里，则可修改。若为网络介绍人则不可修改。
    NSArray *introducerInfoArray = [[NSArray alloc]init];
    introducerInfoArray = [[DBManager shareInstance] getAllIntroducerWithPage:0];
    NSMutableArray *allIntroducerArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < introducerInfoArray.count; i++) {
        Introducer *introducerInfo = [introducerInfoArray objectAtIndex:i];
        [allIntroducerArray addObject:introducerInfo.intr_name];
    }
    if(![allIntroducerArray containsObject:_detailIntroducer.intr_name] && _headerViewController.introducerNameLabel.text.length > 0){
        _headerViewController.introducerNameLabel.clearButtonMode = UITextFieldViewModeWhileEditing;
        _headerViewController.introducerNameLabel.enabled = NO;
    }
}
- (void)refreshData {
    [super refreshData];
    _dataSouceArray = nil;
    _caseArray = nil;
    _dataSouceArray = [NSMutableArray arrayWithCapacity:0];
    _caseArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    for (MedicalCase *mCase in array) {
        [_caseArray addObject:mCase];
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:mCase.ckeyid];
        if (libArray != nil && libArray.count > 0) {
            [_dataSouceArray addObject:libArray];
        } else {
            CTLib *libtmp = [[CTLib alloc]init];
            libtmp.ckeyid = @"-100";
            libtmp.ct_image = @"ctlib_placeholder.png";
            libtmp.creationdate = mCase.creation_date;
            libtmp.ct_desc = mCase.creation_date;
            [_dataSouceArray addObject:@[libtmp]];
        }
    }
}

- (void)refreshView {
    [super refreshView];
    self.detailPatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patientsCellMode.patientId];
    self.headerViewController.patientNameLabel.text = self.detailPatient.patient_name;
    self.headerViewController.patientPhoneLabel.text = self.detailPatient.patient_phone;
    
    if(self.changeIntroducer != nil){
        self.detailIntroducer = self.changeIntroducer;
    }else{
        self.detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:self.detailPatient.introducer_id];
    }
    /*
    if(_detailIntroducer.intr_name != nil){
        _headerViewController.introducerNameLabel.text = _detailIntroducer.intr_name;
    }else{
        Doctor *doctor2 = [[DBManager shareInstance] getDoctorWithCkeyId:self.detailPatient.introducer_id];
        self.headerViewController.introducerNameLabel.text = doctor2.doctor_name;
    }*/
    
    PatientIntroducerMap *map = [[DBManager shareInstance]getPatientIntroducerMapByPatientId:self.detailPatient.ckeyid];
    if([map.intr_source rangeOfString:@"B"].location != NSNotFound){
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
        NSLog(@"介绍人姓名=%@",introducer.intr_name);
        _headerViewController.introducerNameLabel.text = introducer.intr_name;
    }else{
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
        NSLog(@"介绍人=%@",introducer.intr_name);
        _headerViewController.introducerNameLabel.text = introducer.intr_name;
    }
    /*
    if([map.intr_source containsString:@"B"]){
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByCkeyId:map.intr_id];
        NSLog(@"介绍人姓名=%@",introducer.intr_name);
        _headerViewController.introducerNameLabel.text = introducer.intr_name;
    }else{
        Introducer *introducer = [[DBManager shareInstance]getIntroducerByIntrid:map.intr_id];
        NSLog(@"介绍人=%@",introducer.intr_name);
        _headerViewController.introducerNameLabel.text = introducer.intr_name;
    }*/
    
    /*
    Doctor *doctor1 = [[DBManager shareInstance] getDoctorWithCkeyId:self.detailPatient.doctor_id];
    if(![doctor1.doctor_name isEqualToString:[AccountManager shareInstance].currentUser.name]){
        self.headerViewController.transferTextField.text = doctor1.doctor_name;
    }*/
    Doctor *doc = [[DBManager shareInstance]getDoctorNameByPatientIntroducerMapWithPatientId:self.detailPatient.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
    self.headerViewController.transferTextField.text = doc.doctor_name;
    
    [self updateIntroducerNameTextFieldState];
    [self.tableView reloadData];
}

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
    _dataSouceArray = [NSMutableArray arrayWithCapacity:0];
    _caseArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [[DBManager shareInstance] getMedicalCaseArrayWithPatientId:_detailPatient.ckeyid];
    for (MedicalCase *mCase in array) {
        [_caseArray addObject:mCase];
        NSArray *libArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:mCase.ckeyid];
        if (libArray != nil && libArray.count > 0) {
            [_dataSouceArray addObject:libArray];
        } else {
            CTLib *libtmp = [[CTLib alloc]init];
            libtmp.ckeyid = @"-100";
            libtmp.ct_image = @"ctlib_placeholder.png";
            libtmp.creationdate = mCase.creation_date;
            libtmp.ct_desc = mCase.creation_date;
            [_dataSouceArray addObject:@[libtmp]];
        }
    }
}

- (BOOL)getData {
    
    if ([NSString isEmptyString:self.headerViewController.patientNameLabel.text]) {
        [SVProgressHUD showImage:nil status:@"患者姓名不能为空"];
        return NO;
    }else{
        self.detailPatient.patient_name = self.headerViewController.patientNameLabel.text;
    }
    if ([NSString isEmptyString:self.headerViewController.introducerNameLabel.text]) {
        self.detailPatient.introducer_id = @"";
    } else if (self.detailIntroducer != nil && [NSString isNotEmptyString:self.detailIntroducer.ckeyid]) {
        self.detailPatient.introducer_id = self.detailIntroducer.ckeyid;
    }
    if ([NSString isEmptyString:self.headerViewController.patientPhoneLabel.text]) {
        self.detailPatient.patient_phone = @"";
    }
    /*else {
        if ([self.headerViewController.patientPhoneLabel.text hasPrefix:@"1"] && self.headerViewController.patientPhoneLabel.text.length == 11) {
            self.detailPatient.patient_phone = self.headerViewController.patientPhoneLabel.text;
        } else {
            [SVProgressHUD showImage:nil status:@"手机号码格式错误"];
            return NO;
        }
    }*/
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotificationObserver];
}

#pragma mark - Button Actions
- (void)onRightButtonAction:(id)sender {
    
    [self.view addSubview:_clearView];
    _moreBgView.frame = CGRectMake(320-139, 1, _moreBgView.frame.size.width, _moreBgView.frame.size.height);
    [self.view addSubview:_moreBgView];
    
    /*
    BOOL ret =[self getData];
    if (ret == NO) {
        return;
    }
    ret = [[DBManager shareInstance] insertPatient:self.detailPatient];
    if (ret) {
        [SVProgressHUD showImage:nil status:@"保存成功"];
        [self postNotificationName:PatientEditedNotification object:nil];
        [self popViewControllerAnimated:YES];
    } else{
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }
    */
    
}

- (IBAction)createCaseAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
    caseVC.title = @"新建病历";
    caseVC.patiendId = self.detailPatient.ckeyid;
    [self pushViewController:caseVC animated:YES];
    
}

- (IBAction)referralAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
    DoctorLibraryViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
    if (self.detailPatient != nil) {
        doctorVC.isTransfer = YES;
        doctorVC.userId = self.detailPatient.doctor_id;
        doctorVC.patientId = self.detailPatient.ckeyid;
        [self pushViewController:doctorVC animated:YES];
    }
}


- (IBAction)createNotificationAction:(id)sender {
//    [LocalNotificationCenter shareInstance].selectPatient = _detailPatient;
//    SelectDateViewController *selectDateView = [[SelectDateViewController alloc]init];
//    [self.navigationController pushViewController:selectDateView animated:YES];
}

#pragma mark - Notifications
- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    if ([self.headerViewController.introducerNameLabel isFirstResponder]) {
        [self.headerViewController.introducerNameLabel resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        IntroducerViewController *introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
        introducerVC.Mode = IntroducePersonViewSelect;
        introducerVC.delegate = self;
        TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:introducerVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    } else {
        
    }
}

#pragma mark - Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _moreTableView)
        return [_menuDataArray count];
    else {
        return self.dataSouceArray.count;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_clearView removeFromSuperview];
    [_moreBgView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == _moreTableView){
        if(indexPath.row == 0){
            PatientEditViewController *edit = [[PatientEditViewController alloc]initWithNibName:@"PatientEditViewController" bundle:nil];
            edit.patientsCellMode = self.patientsCellMode;
            [self pushViewController:edit animated:YES];
        }else if(indexPath.row == 1){
            [self createCaseAction:nil];
        }else if (indexPath.row == 2){
            [self referralAction:nil];
        }else if (indexPath.row == 3){
            [self createNotificationAction:nil];
        }else if (indexPath.row == 4){
            NSLog(@"%@---%@",_detailPatient.ckeyid,self.patientsCellMode.patientId);
            
                [[CRMHttpRequest shareInstance] postAllNeedSyncPatient:[NSArray arrayWithObjects:_detailPatient, nil]];
                [NSThread sleepForTimeInterval: 0.5];
            

            
            [[IntroducerManager shareInstance]patientToIntroducer:[AccountManager shareInstance].currentUser.userid withCkeyId:_detailPatient.ckeyid withName:_detailPatient.patient_name withPhone:_detailPatient.patient_phone successBlock:^{
                [SVProgressHUD showWithStatus:@"正在转换..."];
            }failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }/*
        else if (indexPath.row == 5){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
            PatientConsultationViewController *patientCVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientConsultationViewController"];
            patientCVC.patientId = self.detailPatient.ckeyid;
            patientCVC.patient = self.detailPatient;
            [self pushViewController:patientCVC animated:YES];
        }
          */
    }
}
- (void)patientToIntroducerSuccess:(NSDictionary *)result{
    if ([result integerForKey:@"Code"] == 200) {
        [SVProgressHUD showImage:nil status:@"转换成功"];
        //存入介绍人库
        Introducer *introducer = [[Introducer alloc]init];
        introducer.intr_name = _detailPatient.patient_name;
        introducer.intr_phone = _detailPatient.patient_phone;
        introducer.intr_id = @"0";
        [[DBManager shareInstance] insertIntroducer:introducer];
        
        NSArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
        if (0 != [recordArray count])
        {
            [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        IntroducerViewController *introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
        [self pushViewController:introducerVC animated:YES];
    } else {
        [SVProgressHUD showImage:nil status:@"转换失败"];
    }

    
    
}
- (void)patientToIntroducerFailed:(NSError *)error{
     [SVProgressHUD showImage:nil status:error.localizedDescription];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _moreTableView){
        return 44;
    }else{
        return  170;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _moreTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            /*
            UINib *nib = [UINib nibWithNibName:@"UITableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"UITableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];*/
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        NSDictionary *data = _menuDataArray[indexPath.row];
        cell.textLabel.text = data[@"name"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [ UIColor clearColor];
        
        return cell;
    }
    else{
    PatientCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PatientCaseTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"PatientCaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientCaseTableViewCell"];
    }
    cell.delegate = self;
    cell.tag = 100+indexPath.row;
    NSArray *array = [self.dataSouceArray objectAtIndex:indexPath.row];
    [cell setImages:array];
    MedicalCase *medicalCase = [self.caseArray objectAtIndex:indexPath.row];
    [cell setMedicalCaseInfomation:medicalCase];
    return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TimAlertView *alertView = [[TimAlertView alloc]initWithTitle:@"确认删除？" message:nil  cancelHandler:^{
        [tableView reloadData];
        } comfirmButtonHandlder:^{
            NSArray *libArray = [self.dataSouceArray objectAtIndex:indexPath.row];
            for (CTLib *lib in libArray) {
                [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
            }
        MedicalCase *medicalCase = [self.caseArray objectAtIndex:indexPath.row];
        BOOL ret = [[DBManager shareInstance] deleteMedicalCaseWithCaseId:medicalCase.ckeyid];
        if (ret) {
            [self.caseArray removeObjectAtIndex:indexPath.row];
            [self.dataSouceArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showImage:nil status:@"删除失败"];
        }
    }];
    [alertView show];
}
}

- (void)didSelectedIntroducer:(Introducer *)intro {
  //  self.detailIntroducer = [[DBManager shareInstance] getIntroducerByIntroducerID:intro.ckeyid];
  //  [self refreshView];
 
    self.changeIntroducer = intro;
    _headerViewController.introducerNameLabel.text = intro.intr_name;
}

- (void)didSelectCell:(PatientCaseTableViewCell *)cell {
    MedicalCase *mcase = [self.caseArray objectAtIndex:cell.tag-100];
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
    }
}

@end

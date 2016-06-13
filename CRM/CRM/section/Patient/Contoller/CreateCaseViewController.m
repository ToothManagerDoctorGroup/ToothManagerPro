//
//  CreateCaseViewController.m
//  CRM
//
//  Created by TimTiger on 1/17/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CreateCaseViewController.h"
#import "CreateCaseHeaderViewController.h"
#import "ImageBrowserViewController.h"
#import "DBTableMode.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "DBManager+Introducer.h"
#import "NSDate+Conversion.h"
#import "PatientManager.h"
#import "SVProgressHUD.h"
#import "TimPickerTextField.h"
#import "TimNavigationViewController.h"
#import "CaseMaterialsViewController.h"
#import "NSString+Conversion.h"
#import "SDImageCache.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "LocalNotificationCenter.h"
#import "XLSelectYuyueViewController.h"
#import "XLSelectCalendarViewController.h"
#import "MyDateTool.h"
#import "XLRecordCell.h"
#import "MyDateTool.h"
#import "DBManager+AutoSync.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "UUDatePicker.h"
#import "XLDoctorLibraryViewController.h"
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"
#import "XLHengYaViewController.h"
#import "XLRuYaViewController.h"
#import "AddressBoolTool.h"
#import "XLPatientSelectViewController.h"
#import "XLCustomAlertView.h"
#import "SysMessageTool.h"
#import "DBManager+Doctor.h"
#import "UIImage+TTMAddtion.h"
#import "XLChatModel.h"
#import "EaseSDKHelper.h"
#import "UINavigationItem+Margin.h"

#define TableHeaderViewHeight 350
@interface CreateCaseViewController () <CreateCaseHeaderViewControllerDeleate,ImageBrowserViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CaseMaterialsViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,XLHengYaDeleate,XLRuYaDelegate,XLSelectYuyueViewControllerDelegate,XLDoctorLibraryViewControllerDelegate>
@property (nonatomic,strong) CreateCaseHeaderViewController *tableHeaderView;
@property (nonatomic,strong) MedicalCase *medicalCase;
@property (nonatomic,strong) MedicalReserve *medicalRes;
@property (nonatomic,strong) NSMutableArray *ctblibArray;
@property (nonatomic,strong) NSMutableArray *expenseArray;
@property (nonatomic,strong) NSMutableArray *recordArray;
@property (nonatomic,strong) XLHengYaViewController *hengYaVC;
@property (nonatomic,strong) XLRuYaViewController *ruYaVC;

@property (nonatomic, strong)NSMutableArray *deleteRcords;//删除的病历记录
@property (nonatomic, strong)NSMutableArray *newRecords;//新增的病历记录

@property (nonatomic, strong)NSMutableArray *deleteCtLibs;//删除的ct数据
@property (nonatomic, strong)NSMutableArray *addCTLibs;//新增的ct数据

@property (nonatomic, assign)BOOL isCamera;//是否拍照

@end

@implementation CreateCaseViewController{
    NSString *implant_time;
    NSString *repair_doctor;
    NSString *repair_time;
}

- (NSMutableArray *)deleteCtLibs{
    if (!_deleteCtLibs) {
        _deleteCtLibs = [NSMutableArray array];
    }
    return _deleteCtLibs;
}

- (NSMutableArray *)addCTLibs{
    if (!_addCTLibs) {
        _addCTLibs = [NSMutableArray array];
    }
    return _addCTLibs;
}

- (NSMutableArray *)deleteRcords{
    if (!_deleteRcords) {
        _deleteRcords = [NSMutableArray array];
    }
    return _deleteRcords;
}
- (NSMutableArray *)newRecords{
    if (!_newRecords) {
        _newRecords = [NSMutableArray array];
    }
    return _newRecords;
}

#pragma mark - Life Cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    implant_time = _medicalCase.implant_time;
    repair_doctor = _medicalCase.repair_doctor;
    repair_time = _medicalCase.repair_time;
    self.tableView.backgroundColor = MyColor(248, 248, 248);
    
    [self addNotificationObserver];
    
}

- (void)initView {
    [super initView];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tooBar.frame = CGRectMake(0, SCREEN_HEIGHT-64-44, self.view.bounds.size.width, 44);
    self.addRecordButton.layer.cornerRadius = 5.0f;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    _tableHeaderView = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseHeaderViewController"];
    [_tableHeaderView.view setFrame:CGRectMake(0, 0, kScreenWidth, TableHeaderViewHeight)];
    _tableHeaderView.delegate = self;
    _tableHeaderView.tableView.scrollEnabled = NO;
    [_tableHeaderView setviewWith:_medicalCase andRes:_medicalRes];
    [_tableHeaderView setImages:_ctblibArray];
    [_tableHeaderView setExpenseArray:_expenseArray];
    _tableHeaderView.view.frame = CGRectMake(0, 0, kScreenWidth, TableHeaderViewHeight + _expenseArray.count * 40);
    
    self.tableView.tableHeaderView = _tableHeaderView.view;
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = MyColor(248, 248, 248);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
    [tapges addTarget:self action:@selector(dismissKeyboard)];
    tapges.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapges];
}

- (void)dismissKeyboard {
    [self.recordTextField resignFirstResponder];
}

- (void)initData {
    [super initData];
    //初始化table 每段的数据容器
    if (self.edit == YES) {
        self.title = @"编辑病历";
        _medicalCase = [[DBManager shareInstance] getMedicalCaseWithCaseId:self.medicalCaseId];
        _medicalRes  = [[DBManager shareInstance] getMedicalReserveWithCaseId:self.medicalCaseId];
        if (_medicalRes == nil) {
            [self initMedicalReserve];
        }
        _recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getMedicalRecordWithCaseId:self.medicalCaseId]];
        if (_recordArray.count == 0) {
            _recordArray = [NSMutableArray arrayWithCapacity:0];
        }else{
            for (MedicalRecord *record in _recordArray) {
                if ([record.doctor_id isEqualToString:[AccountManager currentUserid]]) {
                    record.doctor_name = [AccountManager shareInstance].currentUser.name;
                }else{
                    Doctor *doc = [[DBManager shareInstance] getDoctorWithCkeyId:record.doctor_id];
                    if (doc != nil) {
                        record.doctor_name = doc.doctor_name;
                    }
                }
            }
        }
        
        _expenseArray = [NSMutableArray arrayWithArray:[[DBManager shareInstance] getMedicalExpenseArrayWithMedicalCaseId:self.medicalCaseId]];
        if (_expenseArray.count == 0) {
            _expenseArray = [NSMutableArray arrayWithCapacity:0];
        }
        _ctblibArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *libtmpArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCaseId isAsc:YES];
        if (libtmpArray && libtmpArray.count > 0) {
            [_ctblibArray addObjectsFromArray:libtmpArray];
        }
        self.patiendId = _medicalCase.patient_id;
    } else {
        self.title = @"新建病历";
        _medicalCase = [[MedicalCase alloc]init];
        _medicalCase.patient_id = self.patiendId;
        _medicalCase.case_status = 1;
        Patient *tmpP = [[DBManager shareInstance] getPatientCkeyid:self.patiendId];
        _medicalCase.case_name = [NSString stringWithFormat:@"%@的病历",tmpP.patient_name];
        [self initMedicalReserve];
        _expenseArray = [NSMutableArray arrayWithCapacity:0];
        _recordArray = [NSMutableArray arrayWithCapacity:0];
        _ctblibArray = [NSMutableArray arrayWithCapacity:0];
    }
}

- (void)initMedicalReserve {
    _medicalRes= [[MedicalReserve alloc]init];
    _medicalRes.patient_id = self.patiendId;
}

- (void)refreshData {
    [super refreshData];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
}

- (BOOL)saveData {
    [self.tableHeaderView setCase:_medicalCase andRes:_medicalRes];
    
    if([[DBManager shareInstance] insertMedicalCase:_medicalCase]) {  //先保存病例表
        //获取病历数据
        MedicalCase *tempMCase = [[DBManager shareInstance] getMedicalCaseWithCaseId:_medicalCase.ckeyid];
        if (tempMCase != nil) {
            if (self.edit) {//表明是编辑病历
                //添加一条自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalCase postType:Update dataEntity:[tempMCase.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                
            }else{//表明是新增病历
                //添加一条自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalCase postType:Insert dataEntity:[tempMCase.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
        
        NSString *caseid = _medicalCase.ckeyid;
        if ([NSString isNotEmptyString:caseid]) {
            
            BOOL libRet = [self editCTLibInfo];
            if (!libRet) return NO;
            
            libRet = [self editMedicalReserveWithCaseId:caseid];
            if (!libRet) return NO;
            
            libRet = [self editMedicalRecordWithCaseId:caseid];
            if (!libRet) return NO;
            
            libRet = [self editExpenseInfoWithCaseId:caseid];
            if (!libRet) return NO;
            
            return libRet;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return YES;
}

#pragma mark - 修改CT数据（新增，修改，删除）
- (BOOL)editCTLibInfo{
    //存储ct照片
    BOOL libRet = YES;
    NSMutableArray *CTTmp = [NSMutableArray array];
    //找出相同的ct片
    for (CTLib *addCT in _addCTLibs) {
        for (CTLib *delCT in _deleteCtLibs) {
            if ([addCT.ckeyid isEqualToString:delCT.ckeyid]) {
                [CTTmp addObject:addCT];
                break;
            }
        }
    }
    //删除相同的ct片
    for (CTLib *unUseCT in CTTmp) {
        [_addCTLibs removeObject:unUseCT];
        [_deleteCtLibs removeObject:unUseCT];
    }
    //删除ct
    for (CTLib *lib in _deleteCtLibs) {
        
        libRet =[[DBManager shareInstance] deleteCTlibWithLibId:lib.ckeyid];
        if (libRet == NO) {
            return NO;
        }
        //添加一条删除ct片的自动同步数据
        InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Delete dataEntity:[lib.keyValues JSONString] syncStatus:@"0"];
        [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
    }
    
    //判断是否存在主照片
    NSArray *mainCts = [[DBManager shareInstance] getMainCTWithPatientId:self.patiendId];
    CTLib *mainCT;
    if (mainCts.count > 0) {
        //表明存在主照片，无需设置
        mainCT = nil;
    }else{
        //设置主照片
        mainCT = [self.ctblibArray lastObject];
        //获取患者数据
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patiendId];
        //判断是否开启了通讯录权限
        if ([[AddressBoolTool shareInstance] userAllowToAddress]) {
            if (self.ctblibArray.count > 0) {
                //保存患者的头像
                BOOL isExist = [[AddressBoolTool shareInstance] getContactsWithName:patient.patient_name phone:patient.patient_phone];
                if (!isExist) {
                    [[AddressBoolTool shareInstance] addContactToAddressBook:patient];
                }
                NSString *intrName = [[DBManager shareInstance] getPatientIntrNameWithPatientId:self.patiendId];
                UIImage *sourceImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:mainCT.ct_image];
                UIImage *image = [[AddressBoolTool shareInstance] drawImageWithSourceImage:sourceImage plantTime:self.tableHeaderView.implantTextField.text intrName:intrName];
                [[AddressBoolTool shareInstance] saveWithImage:image person:patient.patient_name phone:patient.patient_phone];
            }
        }
    }
    //新增ct
    for (CTLib *lib in _addCTLibs) {
        if (mainCT) {
            if ([lib.ckeyid isEqualToString:mainCT.ckeyid]) {
                lib.is_main = @"1";
            }
        }
        lib.patient_id = _medicalCase.patient_id;
        lib.case_id = _medicalCase.ckeyid;
        if (nil == lib.creation_date){
            lib.creation_date = [NSString currentDateString];
        }
        libRet = [[DBManager shareInstance] insertCTLib:lib];
        if (libRet == NO) {
            return NO;
        }
        //获取ctlib数据
        CTLib *tempCTLib = [[DBManager shareInstance] getCTLibWithCKeyId:lib.ckeyid];
        if (tempCTLib != nil) {
            //添加ct片的自动同步数据
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_CtLib postType:Insert dataEntity:[tempCTLib.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
    }
    return libRet;
}
#pragma mark - 修改预约记录（新增，修改，删除）
- (BOOL)editMedicalReserveWithCaseId:(NSString *)caseId{
    //存储预约记录
    _medicalRes.case_id = caseId;
    _medicalRes.patient_id = _medicalCase.patient_id;
    _medicalRes.actual_time = _medicalCase.implant_time;
    _medicalRes.repair_time = _medicalCase.repair_time;
    _medicalRes.reserve_time = _medicalCase.next_reserve_time;
    _medicalRes.creation_date = [NSString currentDateString];
    BOOL resRet = [[DBManager shareInstance] insertMedicalReserve:self.medicalRes];
    if (resRet == NO) {
        return NO;
    }
    return resRet;
}

#pragma mark - 修改病历记录（新增，修改，删除）
- (BOOL)editMedicalRecordWithCaseId:(NSString *)caseid{
    NSMutableArray *recordsTmp = [NSMutableArray array];
    
    //找出相同的病历记录
    for (MedicalRecord *newR in _newRecords) {
        for (MedicalRecord *delR in _deleteCtLibs) {
            if ([newR.ckeyid isEqualToString:delR.ckeyid]) {
                [recordsTmp addObject:newR];
                break;
            }
        }
    }
    //删除相同的病历记录
    for (MedicalRecord *unR in recordsTmp) {
        [_newRecords removeObject:unR];
        [_deleteRcords removeObject:unR];
    }
    //存储病例记录
    BOOL recordRet = YES;
    //删除需要删除的病历记录
    if (self.deleteRcords.count > 0) {
        for (MedicalRecord *deleteR in self.deleteRcords) {
            if([[DBManager shareInstance] deleteMedicalRecordWithId:deleteR.ckeyid]){
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalRecord postType:Delete dataEntity:[deleteR.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }
    }
    //添加新增加的病历记录
    for (MedicalRecord *recordTmp in self.newRecords) {
        if ([recordTmp.record_content isEmpty]) continue;
        recordTmp.case_id = caseid;
        if (nil == recordTmp.creation_date){
            recordTmp.creation_date = [NSString currentDateString];
        }
        recordRet = [[DBManager shareInstance] insertMedicalRecord:recordTmp];
        if (recordRet == NO) {
            return NO;
        }
        //获取病历记录的信息
        MedicalRecord *tempRecord = [[DBManager shareInstance] getMedicalRecordWithCkeyId:recordTmp.ckeyid];
        if (tempRecord != nil) {
            //添加自动同步数据
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalRecord postType:Insert dataEntity:[tempRecord.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
    }
    return recordRet;
}
#pragma mark - 修改种植体耗材信息（新增，修改，删除）
- (BOOL)editExpenseInfoWithCaseId:(NSString *)caseid{
    //存储种植体消耗信息
    BOOL expenseRet = YES;
    if (_expenseArray.count < 1) {
        return YES;
    }
    //判断本地是否有此耗材信息
    for (MedicalExpense *expenseTmp in _expenseArray) {
        MedicalExpense *tmp = [[DBManager shareInstance] getMedicalExpenseWithCkeyId:expenseTmp.ckeyid];
        if (tmp == nil) {
            //新增操作
            expenseTmp.case_id = caseid;
            expenseTmp.patient_id = _medicalCase.patient_id;
            if (nil == expenseTmp.creation_date)
            {
                expenseTmp.creation_date = [NSString currentDateString];
            }
            expenseRet = [[DBManager shareInstance] insertMedicalExpenseWith:expenseTmp];
            if (expenseRet == NO) {
                return NO;
            }
            //获取完整的耗材信息
            MedicalExpense *tempExpense = [[DBManager shareInstance] getMedicalExpenseWithCkeyId:expenseTmp.ckeyid];
            if (tempExpense != nil) {
                //添加自动同步数据
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalExpense postType:Insert dataEntity:[tempExpense.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            }
        }else{
            //获取完整的耗材信息
            MedicalExpense *tempExpense = [[DBManager shareInstance] getMedicalExpenseWithCkeyId:expenseTmp.ckeyid];
            tempExpense.expense_num = expenseTmp.expense_num;
            tempExpense.expense_money = expenseTmp.expense_money;
            tempExpense.expense_price = expenseTmp.expense_price;
            tempExpense.mat_id = expenseTmp.mat_id;
            tempExpense.mat_name = expenseTmp.mat_name;
            
            if ([[DBManager shareInstance] updateMedicalExpenseWith:tempExpense]) {
                if (tempExpense != nil) {
                    //添加自动同步数据
                    InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_MedicalExpense postType:Update dataEntity:[tempExpense.keyValues JSONString] syncStatus:@"0"];
                    [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
                }
            }
        }
    }
    
    return expenseRet;
}


#pragma mark - IBActions
- (void)createCTAction:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"添加CT片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionsheet showInView:self.navigationController.view];
}

- (void)onRightButtonAction:(id)sender {
    if (self.tableHeaderView.casenameTextField.text.length == 0) {
        [SVProgressHUD showImage:nil status:@"请填写病历名称"];
        return;
    }
    if ([self.tableHeaderView.casenameTextField.text isValidLength:32]) {
        [SVProgressHUD showImage:nil status:@"病历名称最多为16个汉字"];
        return;
    }
    
    BOOL ret =  [self saveData];
    if (ret) {
        [SVProgressHUD showImage:nil status:@"保存成功"];
        //获取患者数据
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patiendId];
        if (patient != nil) {
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Patient postType:Update dataEntity:[patient.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
        }
        //发送通知
        [self postNotificationName:MedicalCaseEditedNotification object:_medicalCase];
        
        if (self.isNewPatient) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[XLPatientSelectViewController class]]) {
                    [self popToViewController:vc animated:YES];
                    return;
                }
            }
        }else{
            [self popViewControllerAnimated:YES];
        }
        
    } else {
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }
}
- (void)weiXinMessageSuccessWithResult:(NSDictionary *)result{
    
}
- (void)weiXinMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)onBackButtonAction:(id)sender{
    if (self.isNewPatient) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[XLPatientSelectViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }{
        [self popViewControllerAnimated:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelCreateAction)]) {
            [self.delegate didCancelCreateAction];
        }
    }
}
#pragma mark - Notification

#pragma mark - Delegate   -------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicalRecord *record = [self.recordArray objectAtIndex:indexPath.row];
    CGSize contentSize = [record.record_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 15 * 2 - 10 - 40 - 35, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat height = 0;
    if (contentSize.height + 20 + 10 + 5 + 30 > 60) {
        height = contentSize.height + 20 + 10 + 5 + 30;
    }else{
        height = 60;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 320, 50)];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = MyColor(136, 136, 136);
    label.text = @"病情描述";
    [headerView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    lineView.backgroundColor = MyColor(221, 221, 221);
    [headerView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView1.backgroundColor = MyColor(221, 221, 221);
    [headerView addSubview:lineView1];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XLRecordCell *cell = [XLRecordCell cellWithTableView:tableView];
    MedicalRecord *record = [self.recordArray objectAtIndex:indexPath.row];
    cell.record = record;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.recordTextField resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.recordArray.count > indexPath.row) {
            [self.deleteRcords addObject:self.recordArray[indexPath.row]];
            //判断是不是新增的记录被删除
            [self.recordArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 1) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (buttonIndex == 0) {
        self.isCamera = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.isCamera = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark - 解决取消按钮靠左问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    [viewController.navigationItem setRightBarButtonItem:btn animated:NO];
}

#pragma mark - PicBrowserViewControllerdelegate
- (void)picBrowserViewController:(ImageBrowserViewController *)controller didFinishBrowseImages:(NSArray *)images {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self.tableHeaderView setImages:self.ctblibArray];
    }];
}

- (void)picBrowserViewController:(ImageBrowserViewController *)controller didDeleteBrowserPicture:(BrowserPicture *)pic {
    //删除图片
    for (CTLib *lib in self.ctblibArray) {
        if ([lib.ckeyid isEqualToString:pic.keyidStr]) {
            [self.deleteCtLibs addObject:lib];
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ct_image fromDisk:YES];
            [self.ctblibArray removeObject:lib];
            break;
        }
    }
}
- (void)picBrowserViewController:(ImageBrowserViewController *)controller didSetMainImage:(BrowserPicture *)pic{
    [self setMianCtWithCTLib:pic.ctLib];
}

#pragma mark - 设置主照片
- (void)setMianCtWithCTLib:(CTLib *)ctLib{
    //判断是否开启了通讯录权限
    if ([[AddressBoolTool shareInstance] userAllowToAddress]) {
        //保存患者的头像
        Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patiendId];
        BOOL isExist = [[AddressBoolTool shareInstance] getContactsWithName:patient.patient_name phone:patient.patient_phone];
        if (!isExist) {
            [[AddressBoolTool shareInstance] addContactToAddressBook:patient];
        }
        
        //获取介绍人姓名
        NSString *intrName = [[DBManager shareInstance] getPatientIntrNameWithPatientId:self.patiendId];
        @autoreleasepool {
            UIImage *sourceImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:ctLib.ct_image];
            UIImage *image = [[AddressBoolTool shareInstance] drawImageWithSourceImage:sourceImage plantTime:self.tableHeaderView.implantTextField.text intrName:intrName];
            [[AddressBoolTool shareInstance] saveWithImage:image person:patient.patient_name phone:patient.patient_phone];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *resultImage = nil;
        @autoreleasepool {
            resultImage = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
            
            UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [SVProgressHUD showImage:nil status:@"正在添加..."];
            CTLib *lib = [[CTLib alloc] init];
            lib.patient_id = weakSelf.medicalCase.patient_id;
            lib.case_id = weakSelf.medicalCase.ckeyid;
            lib.ct_image = [PatientManager pathImageSaveToDisk:resultImage  withKey:[NSString stringWithFormat:@"%@.jpg",lib.ckeyid]];
            lib.ct_desc = [[NSDate date] dateToNSString];
            lib.is_main = @"0";
            [weakSelf.ctblibArray addObject:lib];
            [weakSelf.addCTLibs addObject:lib];
            [weakSelf.tableHeaderView setImages:weakSelf.ctblibArray];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存到相册成功");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didTouchImageView:(id)sender index:(NSInteger)index{
    NSMutableArray *picArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = self.ctblibArray.count - 1; i >= 0; i--) {
        CTLib *lib = self.ctblibArray[i];
        BrowserPicture *pic = [[BrowserPicture alloc] init];
        pic.keyidStr = lib.ckeyid;
        pic.url = lib.ct_image;
        pic.title = lib.ct_desc;
        pic.ctLib = lib;
        [picArray addObject:pic];
    }
    
    ImageBrowserViewController *picbrowserVC = [[ImageBrowserViewController alloc] init];
    picbrowserVC.delegate = self;
    [picbrowserVC.imageArray addObjectsFromArray:picArray];
    picbrowserVC.currentPage = index;
    picbrowserVC.isEditMedicalCase = YES;
    [self presentViewController:picbrowserVC animated:YES completion:^{
    }];
}


- (void)keyboardWillShow:(CGFloat)keyboardHeight {
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    if ([self.tableHeaderView.expenseTextField isFirstResponder]) {
        [self.tableHeaderView.expenseTextField resignFirstResponder];
        //跳转界面
        CaseMaterialsViewController *caseMaterialVC = [[CaseMaterialsViewController alloc]initWithStyle:UITableViewStylePlain];
        caseMaterialVC.materialsArray = [NSMutableArray arrayWithCapacity:0];
        [caseMaterialVC.materialsArray addObjectsFromArray:self.expenseArray];
        caseMaterialVC.delegate = self;
        [self pushViewController:caseMaterialVC animated:YES];
    } else if ([self.recordTextField isFirstResponder]) {
        CGRect frame = self.view.frame;
        frame.origin.y =  -(keyboardHeight-64);
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    } else if ([self.tableHeaderView.repairDoctorTextField isFirstResponder]) {
        [self.tableHeaderView.repairDoctorTextField resignFirstResponder];
        //选择治疗医生
        XLDoctorLibraryViewController *docLibrary = [[XLDoctorLibraryViewController alloc] init];
        docLibrary.isTherapyDoctor = YES;
        docLibrary.delegate = self;
        [self pushViewController:docLibrary animated:YES];
        
    } else if ([self.tableHeaderView.nextReserveTextField isFirstResponder]) {
        [self.tableHeaderView.nextReserveTextField resignFirstResponder];
        
        XLSelectYuyueViewController *selectYuyeVc = [[XLSelectYuyueViewController alloc] init];
        selectYuyeVc.hidesBottomBarWhenPushed = YES;
        selectYuyeVc.isNextReserve = YES;
        selectYuyeVc.medicalCase = _medicalCase;
        selectYuyeVc.delegate = self;
        [self pushViewController:selectYuyeVc animated:YES];
        
        
    }else if ([self.tableHeaderView.toothPositionField isFirstResponder]){
        [self.tableHeaderView.toothPositionField resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
        self.hengYaVC.delegate = self;
        self.hengYaVC.hengYaString = self.tableHeaderView.toothPositionField.text;
        [self.navigationController addChildViewController:self.hengYaVC];
        [self.navigationController.view addSubview:self.hengYaVC.view];
    }
    flag = NO;
}

-(void)removeHengYaVC{
    [self.hengYaVC willMoveToParentViewController:nil];
    [self.hengYaVC.view removeFromSuperview];
    [self.hengYaVC removeFromParentViewController];
}

- (void)queDingHengYa:(NSMutableArray *)hengYaArray toothStr:(NSString *)toothStr{
    
    if ([toothStr isEqualToString:@"未连续"]) {
        self.tableHeaderView.toothPositionField.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.tableHeaderView.toothPositionField.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.tableHeaderView.toothPositionField.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.tableHeaderView.toothPositionField.text = toothStr;
    }
    [self removeRuYaVC];
}

-(void)removeRuYaVC{
    [self.ruYaVC willMoveToParentViewController:nil];
    [self.ruYaVC.view removeFromSuperview];
    [self.ruYaVC removeFromParentViewController];
}
-(void)changeToRuYaVC{
    [self removeHengYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLRuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.tableHeaderView.toothPositionField.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"XLHengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.tableHeaderView.toothPositionField.text;
    [self.navigationController addChildViewController:self.hengYaVC];
    [self.navigationController.view addSubview:self.hengYaVC.view];
}
- (void)keyboardWillHidden:(CGFloat)keyboardHeight {
    if ([self.recordTextField isFirstResponder]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)didSelectedMaterialsArray:(NSArray *)sourceArray{
    [self.expenseArray removeAllObjects];
    for (MedicalExpense *expense in sourceArray) {
        if ([NSString isNotEmptyString:expense.mat_id] && expense.expense_num > 0)
            [self.expenseArray addObject:expense];
    }
    [_tableHeaderView setExpenseArray:_expenseArray];
    
    _tableHeaderView.view.frame = CGRectMake(0, 0, kScreenWidth, TableHeaderViewHeight + _expenseArray.count * 40);
    _tableHeaderView.view.backgroundColor = MyColor(248, 248, 248);
    self.tableView.tableHeaderView = _tableHeaderView.view;
    [self.tableView reloadData];
}

#pragma mark - XLSelectYuyueViewControllerDelegate
- (void)selectYuyueViewController:(XLSelectYuyueViewController *)vc didSelectDateTime:(NSString *)dateStr{
    self.tableHeaderView.nextReserveTextField.text = dateStr;
}

#pragma mark - XLDoctorLibraryViewControllerDelegate
- (void)doctorLibraryVc:(XLDoctorLibraryViewController *)doctorLibraryVc didSelectDoctor:(Doctor *)doctor{
    _medicalCase.repair_doctor = doctor.ckeyid;
    _medicalCase.repair_doctor_name = doctor.doctor_name;
    self.tableHeaderView.repairDoctorTextField.text = doctor.doctor_name;
}

#pragma mark - CreateCaseHeaderViewControllerDeleate
- (void)didChooseTime:(NSString *)time withType:(NSString *)type{
    WS(weakSelf);
    //获取提醒数据
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:self.patiendId];
    [DoctorTool yuYueMessagePatient:self.patiendId fromDoctor:[AccountManager currentUserid] withMessageType:type withSendType:@"1" withSendTime:time success:^(CRMHttpRespondModel *result) {
        if ([result.code integerValue] == 200) {
            XLCustomAlertView *alertView = [[XLCustomAlertView alloc] initWithTitle:@"提醒患者" message:result.result Cancel:@"不发送" certain:@"发送" weixinEnalbe:self.isBind type:CustonAlertViewTypeCheck cancelHandler:^{
            } certainHandler:^(NSString *content, BOOL wenxinSend, BOOL messageSend) {
                [SysMessageTool sendMessageWithDoctorId:[AccountManager currentUserid] patientId:weakSelf.patiendId isWeixin:wenxinSend isSms:messageSend txtContent:content success:^(CRMHttpRespondModel *respond) {
                    if ([respond.code integerValue] == 200) {
                        [SVProgressHUD showImage:nil status:@"消息发送成功"];
                        //将消息保存在消息记录里
                        XLChatModel *chatModel = [[XLChatModel alloc] initWithReceiverId:weakSelf.patiendId receiverName:patient.patient_name content:content];
                        [DoctorTool addNewChatRecordWithChatModel:chatModel success:nil failure:nil];
                        //发送环信消息
                        [EaseSDKHelper sendTextMessage:content
                                                    to:patient.ckeyid
                                           messageType:eMessageTypeChat
                                     requireEncryption:NO
                                            messageExt:nil];
                        
                    }else{
                        [SVProgressHUD showImage:nil status:@"消息发送失败"];
                    }
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
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (IBAction)addRecordAction:(id)sender {
    
    if ([NSString isNotEmptyString:self.recordTextField.text]) {
        if ([self.recordTextField.text isValidLength:600]) {
            [SVProgressHUD showErrorWithStatus:@"内容过长"];
            return;
        }
        
        MedicalRecord *record = [[MedicalRecord alloc]init];
        record.patient_id = self.medicalCase.patient_id;
        record.case_id = self.medicalCase.ckeyid;
        record.record_content = self.recordTextField.text;
        record.creation_date = [MyDateTool stringWithDateWithSec:[NSDate date]];
        record.doctor_name = [AccountManager shareInstance].currentUser.name;
        [self.recordArray addObject:record];
        [self.newRecords addObject:record];
        self.recordTextField.text = @"";
        [self refreshData];
    }
}

#pragma mark - NotificationHandler
- (void)addNotificationObserver{
    [super addNotificationObserver];
    [self addObserveNotificationWithName:MedicalExpenseDeleteNotification];
}

- (void)removeNotificationObserver{
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:MedicalExpenseDeleteNotification];
}

- (void)handNotification:(NSNotification *)notifacation{
    [super handNotification:notifacation];
    
    if ([notifacation.name isEqualToString:MedicalExpenseDeleteNotification]) {
        NSArray *tmpArr = [NSMutableArray arrayWithArray:[[DBManager shareInstance] getMedicalExpenseArrayWithMedicalCaseId:self.medicalCaseId]];
        [self didSelectedMaterialsArray:tmpArr];
    }
}

- (void)dealloc{
    [self removeNotificationObserver];
    
    self.tableHeaderView = nil;
    self.medicalCase = nil;
    self.medicalRes = nil;
    
    [self.ctblibArray removeAllObjects];
    self.ctblibArray = nil;
    [self.expenseArray removeAllObjects];
    self.expenseArray = nil;
    [self.recordArray removeAllObjects];
    self.recordArray = nil;
    self.hengYaVC = nil;
    self.ruYaVC = nil;
    
    [self.deleteRcords removeAllObjects];
    self.deleteRcords = nil;
    [self.newRecords removeAllObjects];
    self.newRecords = nil;
    [self.deleteCtLibs removeAllObjects];
    self.deleteCtLibs = nil;
    [self.addCTLibs removeAllObjects];
    self.addCTLibs = nil;
    
    implant_time = nil;
    repair_doctor = nil;
    repair_time = nil;
}

@end

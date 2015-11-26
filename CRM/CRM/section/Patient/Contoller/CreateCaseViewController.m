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
#import "NSDate+Conversion.h"
#import "PatientManager.h"
#import "SVProgressHUD.h"
#import "TimPickerTextField.h"
#import "TimNavigationViewController.h"
#import "CaseMaterialsViewController.h"
#import "NSString+Conversion.h"
#import "SDImageCache.h"
#import "UIColor+Extension.h"
#import "RecordTableViewCell.h"
#import "CRMMacro.h"
#import "RepairDoctorViewController.h"
#import "SelectDateViewController.h"
#import "LocalNotificationCenter.h"
#import "HengYaViewController.h"
#import "RuYaViewController.h"
#import "AddReminderViewController.h"

@interface CreateCaseViewController () <CreateCaseHeaderViewControllerDeleate,ImageBrowserViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CaseMaterialsViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,RepairDoctorViewControllerDelegate,HengYaDeleate,RuYaDelegate,AddReminderViewControllerDelegate>
@property (nonatomic,retain) CreateCaseHeaderViewController *tableHeaderView;
@property (nonatomic,retain) MedicalCase *medicalCase;
@property (nonatomic,retain) MedicalReserve *medicalRes;
@property (nonatomic,retain) NSMutableArray *lastctlibArray;
@property (nonatomic,retain) NSMutableArray *ctblibArray;
@property (nonatomic,retain) NSMutableArray *expenseArray;
@property (nonatomic,retain) NSMutableArray *recordArray;
@property (nonatomic,retain) HengYaViewController *hengYaVC;
@property (nonatomic,retain) RuYaViewController *ruYaVC;
@end

@implementation CreateCaseViewController{
    NSString *implant_time;
    NSString *repair_doctor;
    NSString *repair_time;
}

#pragma mark - Life Cicle
- (void)viewDidLoad {
    [super viewDidLoad];
    implant_time = _medicalCase.implant_time;
    repair_doctor = _medicalCase.repair_doctor;
    repair_time = _medicalCase.repair_time;
}
- (void)initView {
    [super initView];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    self.tooBar.frame = CGRectMake(0, SCREEN_HEIGHT-64-44, self.view.bounds.size.width, 44);
    self.addRecordButton.layer.cornerRadius = 5.0f;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    _tableHeaderView = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseHeaderViewController"];
    [_tableHeaderView.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 375-41)];
    _tableHeaderView.delegate = self;
    _tableHeaderView.tableView.scrollEnabled = NO;
    [_tableHeaderView setviewWith:_medicalCase andRes:_medicalRes];
    [_tableHeaderView setImages:_ctblibArray];
    [_tableHeaderView setExpenseArray:_expenseArray];
    self.tableView.tableHeaderView = _tableHeaderView.view;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
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
        }
        _expenseArray = [NSMutableArray arrayWithArray:[[DBManager shareInstance] getMedicalExpenseArrayWithMedicalCaseId:self.medicalCaseId]];
        if (_expenseArray.count == 0) {
            _expenseArray = [NSMutableArray arrayWithCapacity:0];
        }
        _ctblibArray = [NSMutableArray arrayWithCapacity:0];
        _lastctlibArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *libtmpArray = [[DBManager shareInstance] getCTLibArrayWithCaseId:self.medicalCaseId];
        if (libtmpArray && libtmpArray.count > 0) {
            [_ctblibArray addObjectsFromArray:libtmpArray];
            [_lastctlibArray addObjectsFromArray:libtmpArray];
        }
        self.patiendId = _medicalCase.patient_id;
    } else {
        self.title = @"新建病历";
        _medicalCase = [[MedicalCase alloc]init];
        _medicalCase.patient_id = self.patiendId;
        _medicalCase.case_status = 1;
        [self initMedicalReserve];
        _expenseArray = [NSMutableArray arrayWithCapacity:0];
        _recordArray = [NSMutableArray arrayWithCapacity:0];
        _ctblibArray = [NSMutableArray arrayWithCapacity:0];
        _lastctlibArray = [NSMutableArray arrayWithCapacity:0];
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
      [[DBManager shareInstance] updateUpdateDate:self.patiendId];
        NSString *caseid = _medicalCase.ckeyid;
        if ([NSString isNotEmptyString:caseid]) {
            //存储ct照片
            BOOL libRet = YES;
            BOOL deleteB = NO;
            for (CTLib *tlib in self.lastctlibArray) {
                deleteB = YES;
                for (CTLib *clib in self.ctblibArray) {
                    if ([tlib.ckeyid isEqualToString:clib.ckeyid]) {
                        deleteB = NO;
                        break;
                    }
                }
                if (deleteB == YES) {
                    libRet =[[DBManager shareInstance] deleteCTlibWithLibId:tlib.ckeyid];
                    if (libRet == NO) {
                        return NO;
                    }
                }
            }
            if (libRet == NO) {
                return NO;
            }
            for (CTLib *lib in _ctblibArray) {
                lib.patient_id = _medicalCase.patient_id;
                lib.case_id = _medicalCase.ckeyid;
                if (nil == lib.creationdate)
                {
                    lib.creationdate = [NSString currentDateString];
                }
                
                libRet = [[DBManager shareInstance] insertCTLib:lib];
                if (libRet == NO) {
                    return NO;
                }
            }
            
            //存储预约记录
            _medicalRes.case_id = caseid;
            _medicalRes.patient_id = _medicalCase.patient_id;
            _medicalRes.actual_time = _medicalCase.implant_time;
            _medicalRes.repair_time = _medicalCase.repair_time;
            _medicalRes.reserve_time = _medicalCase.next_reserve_time;
            _medicalRes.creation_date = [NSString currentDateString];
            BOOL resRet = [[DBManager shareInstance] insertMedicalReserve:self.medicalRes];
            if (resRet == NO) {
                return NO;
            }
            
            //存储病例记录
            BOOL recordRet = YES;
            recordRet = [[DBManager shareInstance] deleteMedicalRecordWithCaseId:caseid];
            if (recordRet == NO) {
                return NO;
            }
            for (MedicalRecord *recordTmp in _recordArray) {
                if ([recordTmp.record_content isEmpty]) {
                    continue;
                }
                recordTmp.case_id = caseid;
                if (nil == recordTmp.creation_date)
                {
                    recordTmp.creation_date = [NSString currentDateString];
                }

                recordRet = [[DBManager shareInstance] insertMedicalRecord:recordTmp];
                if (recordRet == NO) {
                    return NO;
                }
            }
            
            //存储种植体消耗信息
            BOOL expenseRet = YES;
            if (_expenseArray.count < 1) {
                return  YES;
            }
            expenseRet = [[DBManager shareInstance] deleteMedicalExpenseWithCaseId:caseid];
            if (expenseRet == NO) {
                return NO;
            }
            for (MedicalExpense *expenseTmp in _expenseArray) {
                if ([NSString isEmptyString:expenseTmp.mat_id] || expenseTmp.expense_num <=0) {
                    continue;
                }
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
            }
            return YES;
        } else {
            //handle error
            return NO;
        }
        
    } else {
        //handle error
        return NO;
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    
}

#pragma mark - IBActions
- (void)createCTAction:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"添加CT片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionsheet showInView:self.navigationController.view];
}

- (void)onRightButtonAction:(id)sender {
    BOOL ret =  [self saveData];
    if (ret) {
        if(![NSString isEmptyString:_medicalCase.implant_time] && ![_medicalCase.implant_time isEqualToString:implant_time] ){
            [[DoctorManager shareInstance]weiXinMessagePatient:_medicalCase.patient_id fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:@"种植" withSendType:@"1" withSendTime:_medicalCase.implant_time successBlock:^{
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
        if(![NSString isEmptyString:_medicalCase.repair_doctor] && ![_medicalCase.repair_doctor isEqualToString:repair_doctor] ){
         NSString* date;
         NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
         [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
         date = [formatter stringFromDate:[NSDate date]];
         [[DoctorManager shareInstance]weiXinMessagePatient:_medicalCase.patient_id fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:@"转诊" withSendType:@"1" withSendTime:date successBlock:^{
         } failedBlock:^(NSError *error){
         [SVProgressHUD showImage:nil status:error.localizedDescription];
         }];
        }
        if(![NSString isEmptyString:_medicalCase.repair_time] && ![_medicalCase.repair_time isEqualToString:repair_time]){
            [[DoctorManager shareInstance]weiXinMessagePatient:_medicalCase.patient_id fromDoctor:[AccountManager shareInstance].currentUser.userid withMessageType:@"修复" withSendType:@"1" withSendTime:_medicalCase.repair_time successBlock:^{
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
        [SVProgressHUD showImage:nil status:@"保存成功"];
        
        [self postNotificationName:MedicalCaseEditedNotification object:_medicalCase];
        [self popViewControllerAnimated:YES];
        
    } else {
        [SVProgressHUD showImage:nil status:@"保存失败"];
    }
}
- (void)weiXinMessageSuccessWithResult:(NSDictionary *)result{
    
}
- (void)weiXinMessageFailedWithError:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}
#pragma mark - Notification

#pragma mark - Delegate   -------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        MedicalRecord *record = [self.recordArray objectAtIndex:indexPath.row];
    CGFloat height = [PatientManager getSizeWithString:record.record_content].height+18;
    if (height < 48) {
        return 48;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 320, 20)];
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor viewFlipsideBackgroundColor];
    label.text = @"病历描述";
    [headerView addSubview:label];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *cellIdentifier = @"cellIdentifier";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    MedicalRecord *record = [self.recordArray objectAtIndex:indexPath.row];
    [cell setCellWithRecord:record size:[PatientManager getSizeWithString:record.record_content]];
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
            [self.recordArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 1) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:^{
        
    }];
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
            [[SDImageCache sharedImageCache] removeImageForKey:lib.ckeyid fromDisk:YES];
            [self.ctblibArray removeObject:lib];
            break;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *resultImage = nil;
        resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [SVProgressHUD showImage:nil status:@"正在添加..."];
        CTLib *lib = [[CTLib alloc]init];
        lib.patient_id = self.medicalCase.patient_id;
        lib.case_id = self.medicalCase.ckeyid;
        lib.ct_image = [PatientManager pathImageSaveToDisk:resultImage withKey:[NSString stringWithFormat:@"%@.jpg", lib.ckeyid]];
        lib.ct_desc = [[NSDate date] dateToNSString];
        [self.ctblibArray addObject:lib];
        [self.tableHeaderView setImages:self.ctblibArray];
        [SVProgressHUD dismiss];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didTouchImageView:(id)sender {
    NSMutableArray *picArray = [NSMutableArray arrayWithCapacity:0];
    for (CTLib *lib in self.ctblibArray) {
        BrowserPicture *pic = [[BrowserPicture alloc]init];
        pic.keyidStr = lib.ckeyid;
        pic.url = lib.ct_image;
        pic.title = lib.ct_desc;
        [picArray addObject:pic];
    }
    ImageBrowserViewController *picbrowserVC = [[ImageBrowserViewController alloc]init];
    picbrowserVC.delegate = self;
    [picbrowserVC.imageArray addObjectsFromArray:picArray];
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
        TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:caseMaterialVC];
        caseMaterialVC.materialsArray = [NSMutableArray arrayWithCapacity:0];
        [caseMaterialVC.materialsArray addObjectsFromArray:self.expenseArray];
        caseMaterialVC.delegate = self;
        [self presentViewController:nav animated:YES completion:^{}];
    } else if ([self.recordTextField isFirstResponder]) {
        CGRect frame = self.view.frame;
        frame.origin.y =  -(keyboardHeight-64);
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    } else if ([self.tableHeaderView.repairDoctorTextField isFirstResponder]) {
        [self.tableHeaderView.repairDoctorTextField resignFirstResponder];
        //跳转界面
        RepairDoctorViewController *repairdoctorVC = [[RepairDoctorViewController alloc]initWithStyle:UITableViewStylePlain];
        TimNavigationViewController *nav = [[TimNavigationViewController alloc]initWithRootViewController:repairdoctorVC];
        repairdoctorVC.delegate = self;
        [self presentViewController:nav animated:YES completion:^{}];
    } else if ([self.tableHeaderView.nextReserveTextField isFirstResponder]) {
        [self.tableHeaderView.nextReserveTextField resignFirstResponder];
#warning 跳转到添加预约的页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
         AddReminderViewController *addReminderVC = [storyboard instantiateViewControllerWithIdentifier:@"AddReminderViewController"];
        addReminderVC.isNextReserve = YES;
        addReminderVC.delegate = self;
        addReminderVC.medicalCase = _medicalCase;
        [self.navigationController pushViewController:addReminderVC animated:YES];
        
        
    } else if ([self.tableHeaderView.casenameTextField isFirstResponder]){
        [self.tableHeaderView.casenameTextField resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
        self.hengYaVC.delegate = self;
        self.hengYaVC.hengYaString = self.tableHeaderView.casenameTextField.text;
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
        self.tableHeaderView.casenameTextField.text = [hengYaArray componentsJoinedByString:@","];
    }else{
        self.tableHeaderView.casenameTextField.text = toothStr;
    }
    
    [self removeHengYaVC];
}

- (void)queDingRuYa:(NSMutableArray *)ruYaArray toothStr:(NSString *)toothStr{
    if ([toothStr isEqualToString:@"未连续"]) {
        self.tableHeaderView.casenameTextField.text = [ruYaArray componentsJoinedByString:@","];
    }else{
        self.tableHeaderView.casenameTextField.text = toothStr;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    self.ruYaVC = [storyboard instantiateViewControllerWithIdentifier:@"RuYaViewController"];
    self.ruYaVC.delegate = self;
    self.ruYaVC.ruYaString = self.tableHeaderView.casenameTextField.text;
    [self.navigationController addChildViewController:self.ruYaVC];
    [self.navigationController.view addSubview:self.ruYaVC.view];
}
-(void)changeToHengYaVC{
    [self removeRuYaVC];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
    self.hengYaVC = [storyboard instantiateViewControllerWithIdentifier:@"HengYaViewController"];
    self.hengYaVC.delegate = self;
    self.hengYaVC.hengYaString = self.tableHeaderView.casenameTextField.text;
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

- (void)didSelectedMaterialsArray:(NSArray *)array {
    [self.expenseArray removeAllObjects];
    for (MedicalExpense *expense in array) {
        if ([NSString isNotEmptyString:expense.mat_id] && expense.expense_num > 0)
            [self.expenseArray addObject:expense];
    }
    [_tableHeaderView setExpenseArray:_expenseArray];
}

#pragma mark - AddReminderViewControllerDelegate
- (void)addReminderViewController:(AddReminderViewController *)vc didSelectDateTime:(NSString *)dateStr{
    self.tableHeaderView.nextReserveTextField.text = dateStr;
}

- (void)didSelectedRepairDoctor:(RepairDoctor *)doctor {
    _medicalCase.repair_doctor = doctor.ckeyid;
    self.tableHeaderView.repairDoctorTextField.text = doctor.doctor_name;
}

- (IBAction)addRecordAction:(id)sender {
    if ([NSString isNotEmptyString:self.recordTextField.text]) {
        MedicalRecord *record = [[MedicalRecord alloc]init];
        record.patient_id = self.medicalCase.patient_id;
        record.case_id = self.medicalCase.ckeyid;
        record.record_content = self.recordTextField.text;
        [self.recordArray addObject:record];
        self.recordTextField.text = @"";
        [self refreshData];
    }
}


@end

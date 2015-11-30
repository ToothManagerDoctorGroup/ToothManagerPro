//
//  DoctorLibraryViewController.m
//  CRM
//
//  Created by fankejun on 14-9-25.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "DoctorLibraryViewController.h"
#import "DoctorInfoViewController.h"
#import "DoctorTableViewCell.h"
#import "DoctorManager.h"
#import "CRMHttpRequest+Doctor.h"
#import "SVProgressHUD.h"
#import "NSDictionary+Extension.h"
#import "UserInfoViewController.h"
#import "IntroducerManager.h"
#import "CRMHttpRequest+Introducer.h"
#import "DBManager+Doctor.h"
#import "ChineseSearchEngine.h"
#import "DoctorSquareViewController.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "CRMMacro.h"
#import "SyncManager.h"
#import "AvatarView.h"
#import "CRMHttpRequest+Sync.h"
#import "UIImageView+WebCache.h"
#import "DoctorTool.h"
#import "CRMHttpRespondModel.h"
#import "DBManager+Introducer.h"

@interface DoctorLibraryViewController () <CRMHttpRequestDoctorDelegate,UISearchBarDelegate,DoctorTableViewCellDelegate,RequestIntroducerDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) NSArray *modeArray;
@property (nonatomic,retain) NSArray *searchHistoryArray;
@property (nonatomic,retain) Doctor *selectDoctor;

@property (nonatomic, strong)Doctor *deleteDoctor;//当前要删除的医生好友
@end

@implementation DoctorLibraryViewController
@synthesize isTransfer;
@synthesize userId;
@synthesize patientId;


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongbuAction:) name:@"tongbu" object:nil];
}

- (void)initView {
    [super initView];
    self.title = @"医生库";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
}

- (void)initData {
    [super initData];
    self.searchHistoryArray = [[DBManager shareInstance] getAllDoctor];
    [self orderedByNumber];
    if (self.searchHistoryArray == nil) {
        self.searchHistoryArray = @[];
    }
}
-(void)orderedByNumber{
    NSArray *lastArray = [NSArray arrayWithArray:self.searchHistoryArray];
    lastArray = [self.searchHistoryArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Doctor *doctor1 = (Doctor *)obj1;
        Doctor *doctor2 = (Doctor *)obj2;
        NSInteger count1 = [[DBManager shareInstance] getAllPatientWithID:doctor1.ckeyid].count;
        NSInteger count2 = [[DBManager shareInstance] getAllPatientWithID:doctor2.ckeyid].count;
        if (count1 > count2){
            return NSOrderedDescending;
        }
        if(count1 < count2){
            return  NSOrderedAscending;
        }
        return NSOrderedSame;
        
    }];
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    for(NSInteger i = lastArray.count;i>0;i--){
        [resultArray addObject:lastArray[i-1]];
    }
    self.searchHistoryArray = [NSArray arrayWithArray:resultArray];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRightButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
    DoctorSquareViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorSquareViewController"];
    [self pushViewController:doctorVC animated:YES];

}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSearchResultsTableView:tableView]) {
        return self.modeArray.count;
    }
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"DoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"DoctorTableViewCell"];
    }
    [cell.avatarButton addTarget:cell action:@selector(avatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    cell.addButton.backgroundColor = [UIColor clearColor];
    [cell.addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    cell.addButton.hidden = YES;
    cell.tag = indexPath.row+100;
    Doctor *doctor = nil;
    if ([self isSearchResultsTableView:tableView]) {
        doctor = [self.modeArray objectAtIndex:indexPath.row];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:indexPath.row];
    }
    [cell setCellWithMode:doctor];
    NSInteger count = [[DBManager shareInstance] getAllPatientWithID:doctor.ckeyid].count;
    [cell.addButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Doctor *doctor = nil;
    if ([self isSearchResultsTableView:tableView]) {
        doctor = [self.modeArray objectAtIndex:indexPath.row];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:indexPath.row];
    }
    
    //转诊病人
    if (isTransfer && self.selectDoctor == nil) {
        
        self.selectDoctor = doctor;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认转诊给此好友吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 110;
        [alertView show];
        
    } else if (self.selectDoctor == nil) {
        DoctorInfoViewController *doctorinfoVC = [[DoctorInfoViewController alloc]init];
        doctorinfoVC.repairDoctorID = doctor.ckeyid;
        doctorinfoVC.ifDoctorInfo = YES;
        [self pushViewController:doctorinfoVC animated:YES];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Doctor *doctor = self.searchHistoryArray[indexPath.row];
    self.deleteDoctor = doctor;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 111;
        [alertView show];
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 110) {
        if (buttonIndex == 1) {
            [[DoctorManager shareInstance] trasferPatient:patientId fromDoctor:[AccountManager shareInstance].currentUser.userid toReceiver:self.selectDoctor.doctor_id successBlock:^{
                [SVProgressHUD showWithStatus:@"正在转诊患者..."];
                [[DBManager shareInstance]updateUpdateDate:patientId];
            } failedBlock:^(NSError *error){
                [SVProgressHUD showImage:nil status:error.localizedDescription];
            }];
        }
    }else{
        if (buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"删除中..."];
            [DoctorTool deleteFriendWithDoctorId:self.deleteDoctor.ckeyid introId:[[AccountManager shareInstance] currentUser].userid success:^(CRMHttpRespondModel *result) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                BOOL res = [[DBManager shareInstance] deleteDoctorWithUserObject:self.deleteDoctor];
                if (res) {
                    self.searchHistoryArray = [[DBManager shareInstance] getAllDoctor];
                    [self.tableView reloadData];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
                
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }
    
}

#pragma mark - SearchDisplay delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.modeArray = @[];
    [self.searchDisplayController.searchResultsTableView reloadData];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     self.modeArray = [ChineseSearchEngine resultArraySearchDoctorOnArray:self.searchHistoryArray withSearchText:searchBar.text];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma Doctor request Delegate
- (void)searchDoctorWithNameFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)searchDoctorWithNameSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    if ([result integerForKey:@"Code"] == 200) {
       self.modeArray  = [[DoctorManager shareInstance] arrayWithDoctorResult:[result objectForKey:@"Result"]];
      [self.searchDisplayController.searchResultsTableView reloadData];
      [self.tableView reloadData];
    } else {
        [SVProgressHUD showImage:nil status:@"查询失败"];
    }
}
- (void)sortDataArrayByCount{ //通过修复人数来给dataArray排序
    
    /*
    Doctor *doctor = nil;
    if ([self isSearchResultsTableView:self.tableView]) {
        doctor = [self.modeArray objectAtIndex:indexPath.row];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:indexPath.row];
    }
    [cell setCellWithMode:doctor];
    NSInteger count = [[DBManager shareInstance] getAllPatientWithID:doctor.ckeyid].count;
    [cell.addButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
     */
    
  
    /*
    for(NSInteger i = 0;i<self.modeArray.count;i++){
        Doctor *doctor = nil;
        doctor = [self.modeArray objectAtIndex:i];
        NSInteger count = [[DBManager shareInstance] getAllPatientWithID:doctor.ckeyid].count;
        
        
    }
    */

} 
- (void)transferPatientSuccessWithResult:(NSDictionary *)result
{
    if ([result integerForKey:@"Code"] == 200) {
        Patient *tmppatient = [[DBManager shareInstance] getPatientWithPatientCkeyid:patientId];
        if (tmppatient != nil) {
        //    tmppatient.doctor_id =  self.selectDoctor.doctor_id;
        //    tmppatient.introducer_id = [AccountManager currentUserid];
            
        //   [[DBManager shareInstance] updatePatient:tmppatient];
       //     [[DBManager shareInstance]updateUpdateDate:patientId];
            
           
            
          //  [[CRMHttpRequest shareInstance]postPatientIntroducerMap:tmppatient.ckeyid withDoctorId:self.selectDoctor.ckeyid withIntrId:[AccountManager shareInstance].currentUser.userid];
            
            //插入患者介绍人
            [self insertPatientIntroducerMap];
            
            [SVProgressHUD showWithStatus:@"转诊中..."];
            //调用同步方法
            [NSTimer scheduledTimerWithTimeInterval:0.2
                                             target:self
                                           selector:@selector(callSync)
                                           userInfo:nil
                                            repeats:NO];
            
    
            self.selectDoctor = nil;
        }
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"转诊患者失败"];
    }
}
//同步
- (void)callSync {
    [[SyncManager shareInstance] startSync];
}

#pragma mark -同步监听
- (void)tongbuAction:(NSNotification *)notif{
    [SVProgressHUD showSuccessWithStatus:@"转诊患者成功"];
    [self popViewControllerAnimated:YES];
}

-(void)postPatientIntroducerMapSuccess:(NSDictionary *)result{
    
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = [AccountManager shareInstance].currentUser.userid;
    map.intr_source = @"I";
    map.patient_id = patientId;
    map.doctor_id = self.selectDoctor.ckeyid;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance]insertPatientIntroducerMap:map];
}
-(void)postPatientIntroducerMapFailed:(NSError *)error{
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

-(void)insertPatientIntroducerMap{
    PatientIntroducerMap *map = [[PatientIntroducerMap alloc]init];
    map.intr_id = [AccountManager currentUserid];
    map.intr_source = @"I";
    map.patient_id = patientId;
    map.doctor_id = self.selectDoctor.doctor_id;
    map.intr_time = [NSString currentDateString];
    [[DBManager shareInstance]insertPatientIntroducerMap:map];
}



- (void)transferPatientFailedWithError:(NSError *)error
{
    self.selectDoctor = nil;
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

#pragma mark - Cell Delegate
- (void)addButtonDidSelected:(id)sender {
    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    Doctor *doctor = nil;
    if ([self.searchDisplayController isActive]) {
        doctor = [self.modeArray objectAtIndex:cell.tag-100];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:cell.tag-100];
    }
    [[IntroducerManager shareInstance] applyToBecomeIntroducerWithDoctorId:doctor.ckeyid successBlock:^{
        [SVProgressHUD showImage:nil status:@"请求中..."];
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)headerDidSelected:(id)sender {
    DoctorTableViewCell *cell = (DoctorTableViewCell *)sender;
    Doctor *doctor = nil;
    if ([self.searchDisplayController isActive]) {
        doctor = [self.modeArray objectAtIndex:cell.tag-100];
    } else {
        doctor = [self.searchHistoryArray objectAtIndex:cell.tag-100];
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    userInfoVC.doctor = doctor;
    [self pushViewController:userInfoVC animated:YES];
}


@end


//
//  PatientConsultationViewController.m
//  CRM
//
//  Created by lsz on 15/9/8.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "PatientConsultationViewController.h"
#import "CommonMacro.h"
#import "PatientManager.h"
#import "UIColor+Extension.h"
#import "DBManager+Patients.h"
#import "RecordTableViewCell.h"
#import "AccountManager.h"
#import "DBManager+Doctor.h"

@interface PatientConsultationViewController ()

@property (nonatomic,retain) NSMutableArray *messageArray;

@end

@implementation PatientConsultationViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"会诊信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44);
    self.toolbar.frame = CGRectMake(0, SCREEN_HEIGHT-64-44, self.view.bounds.size.width, 44);
    self.sendButton.layer.cornerRadius = 5.0f;
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]init];
    [tapges addTarget:self action:@selector(dismissKeyboard)];
    tapges.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapges];
    
}
- (void)dismissKeyboard {
    [self.messageTextField resignFirstResponder];
}
- (void)initData{
    [super initData];
    _messageArray = [NSMutableArray arrayWithArray:[[DBManager shareInstance]getPatientConsultationWithPatientId:self.patientId]];
    NSLog(@"messageArray=%@",_messageArray);
    if(_messageArray.count == 0){
        _messageArray = [NSMutableArray arrayWithCapacity:0];
    }
}
- (void)refreshData {
    [super refreshData];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientConsultation *patientC = [self.messageArray objectAtIndex:indexPath.row];
    CGFloat height = [PatientManager getSizeWithString:patientC.cons_content].height + 18;
    if(height < 58){
        return 58;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *cellIdentifier = @"cellIdentifier";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    PatientConsultation *patientC = [self.messageArray objectAtIndex:indexPath.row];
    [cell setCellWithPatientC:patientC size:[PatientManager getSizeWithString:patientC.cons_content]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.messageTextField resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(self.messageArray.count > indexPath.row){
            [self.messageArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

- (void)keyboardWillShow:(CGFloat)keyboardHeight{
    static BOOL flag = NO;
    if (flag == YES || self.navigationController.topViewController != self) {
        return;
    }
    flag = YES;
    if ([self.messageTextField isFirstResponder]) {
        CGRect frame = self.view.frame;
        frame.origin.y =  -(keyboardHeight-64);
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    flag = NO;
}

- (void)keyboardWillHidden:(CGFloat)keyboardHeight{
    if([self.messageTextField isFirstResponder]){
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (BOOL)saveData{
    //存储病例记录
    BOOL recordRet = YES;
    recordRet = [[DBManager shareInstance] deletePatientConsultationWithPatientId_sync:self.patientId];
    if (recordRet == NO) {
        return NO;
    }
    for (PatientConsultation *recordTmp in self.messageArray) {
        if ([recordTmp.cons_content isEmpty]) {
            continue;
        }
        recordTmp.patient_id = self.patientId;
        if (nil == recordTmp.creation_date)
        {
            recordTmp.creation_date = [NSString currentDateString];
        }
        
        recordRet = [[DBManager shareInstance]insertPatientConsultation:recordTmp];
        
        if (recordRet == NO) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)sendMessageAction:(id)sender {

    
    if ([NSString isNotEmptyString:self.messageTextField.text]) {
        PatientConsultation *patientC = [[PatientConsultation alloc]init];
        patientC.patient_id = self.patientId;
        patientC.cons_content = self.messageTextField.text;
        patientC.doctor_name = [[AccountManager shareInstance] currentUser].name;
        //            Doctor *doctor = [[DBManager shareInstance] getDoctorWithCkeyId:self.patient.doctor_id];
        //            patientC.doctor_id = doctor.doctor_id;
        patientC.doctor_id = self.patient.doctor_id;
        
        [self.messageArray addObject:patientC];
        patientC.amr_file = @"";
        patientC.amr_time = @"";
        patientC.cons_type = @"";
        
        [[DBManager shareInstance]insertPatientConsultation:patientC];
        self.messageTextField.text = @"";
        [self refreshData];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

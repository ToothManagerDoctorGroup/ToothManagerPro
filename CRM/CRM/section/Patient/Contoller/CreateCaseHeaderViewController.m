//
//  CreateCaseHeaderViewController.m
//  CRM
//
//  Created by TimTiger on 1/17/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CreateCaseHeaderViewController.h"
#import "TimPickerTextField.h"
#import "DBTableMode.h"
#import "TimImagesScrollView.h"
#import "DBManager+Patients.h"
#import "DBManager+Materials.h"
#import "NSString+Conversion.h"
#import "DBManager+RepairDoctor.h"
#import "CRMHttpRequest+Sync.h"

@interface CreateCaseHeaderViewController () <TimImagesScrollViewDelegate>

@end

@implementation CreateCaseHeaderViewController

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped{
    [self.casenameTextField resignFirstResponder];
    [self.implantTextField resignFirstResponder];
    [self.nextReserveTextField resignFirstResponder];
    [self.repairTextField resignFirstResponder];
    [self.repairDoctorTextField resignFirstResponder];
    [self.expenseTextField resignFirstResponder];
}
- (IBAction)createCTAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(createCTAction:)]) {
        [self.delegate createCTAction:sender];
    }
}

- (void)setviewWith:(MedicalCase *)mCase andRes:(MedicalReserve *)mRes {
    if (self.imageScrollView.sdelegate == nil) {
        self.imageScrollView.sdelegate = self;
        self.implantTextField.borderStyle = UITextBorderStyleNone;
        self.implantTextField.mode = TextFieldInputModeDatePicker;
        self.nextReserveTextField.borderStyle = UITextBorderStyleNone;
        self.nextReserveTextField.mode = TextFieldInputModeExternal;
        self.repairTextField.borderStyle = UITextBorderStyleNone;
        self.repairTextField.mode = TextFieldInputModeDatePicker;
        self.expenseTextField.borderStyle = UITextBorderStyleNone;
        self.expenseTextField.mode = TextFieldInputModeExternal;
        self.repairDoctorTextField.borderStyle = UITextBorderStyleNone;
        self.repairDoctorTextField.mode = TextFieldInputModeExternal;
        self.casenameTextField.mode = TextFieldInputModeKeyBoard;
        [self.casenameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    Patient *patient = [[DBManager shareInstance] getPatientWithPatientCkeyid:mCase.patient_id];
    self.nameTextField.text = patient.patient_name;
    self.implantTextField.text = mCase.implant_time;
    self.nextReserveTextField.text = mCase.next_reserve_time;
    self.repairTextField.text = mCase.repair_time;
    self.casenameTextField.text = mCase.case_name;
    if (mCase.repair_doctor != nil) {
        RepairDoctor *rDoctor = [[DBManager shareInstance] getRepairDoctorWithCkeyId:mCase.repair_doctor];
        self.repairDoctorTextField.text = rDoctor.doctor_name;
    }
    
//  self.expenseNumTextField.text = mRes.
//  self.expenseTextField.text =
}

- (void)setExpenseArray:(NSArray *)expenseArray {
    NSString *textStr = @"";
    NSInteger num = 0;
    NSMutableString *expenseStr = [NSMutableString stringWithString:@""];
    for (MedicalExpense *expense in expenseArray) {
        Material *mater = [[DBManager shareInstance] getMaterialWithId:expense.mat_id];
        if (nil != mater) {
            textStr = [textStr stringByAppendingString:@"+"];
            textStr = [textStr stringByAppendingString:mater.mat_name];
            num += expense.expense_num;
            
            [expenseStr appendFormat:@"%@:%ld  ",mater.mat_name,(long)expense.expense_num];
        }
    }
    
    for (int i = 0; i < expenseArray.count; i++) {
        UIView *view = [self.view viewWithTag:150 + i];
        [view removeFromSuperview];
    }
    
    CGFloat commenH = 40;
    CGFloat commenW = 240;
    for (int i = 0; i < expenseArray.count; i++) {
        
        MedicalExpense *expense = expenseArray[i];
        Material *mater = [[DBManager shareInstance] getMaterialWithId:expense.mat_id];
        
        UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 350 + i * commenH, kScreenWidth, commenH)];
        superView.tag = 150 + i;
        superView.backgroundColor = MyColor(248, 248, 248);
        [self.view addSubview:superView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 240, 0, 180, commenH)];
        nameLabel.textColor = MyColor(51, 51, 51);
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.text = mater.mat_name;
        [superView addSubview:nameLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 240 + 180, 0, 50, commenH)];
        numLabel.textColor = MyColor(51, 51, 51);
        numLabel.font = [UIFont systemFontOfSize:14];
        numLabel.textAlignment = NSTextAlignmentRight;
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)expense.expense_num];
        [superView addSubview:numLabel];
        if (i != expenseArray.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 240, commenH - 1, commenW, 1)];
            lineView.backgroundColor = MyColor(221, 221, 221);
            [superView addSubview:lineView];
        }
    }
}

- (void)setImages:(NSArray *)images {
    self.imageScrollView.sdelegate = self;
    NSMutableArray *muarray = [NSMutableArray arrayWithCapacity:0];
    /*
    for (CTLib *lib in images) {
        TimImage *image = [[TimImage alloc]init];
        image.url = lib.ct_image;
        image.title = lib.ct_desc;
        [muarray addObject:image];
    }
     */
    for(NSInteger i = images.count;i>0;i--){
        CTLib *lib = images[i-1];
        TimImage *image = [[TimImage alloc] init];
        image.url = lib.ct_image;
        image.title = lib.ct_desc;
        [muarray addObject:image];
        
    }
    [self.imageScrollView setImageViewWidth:60];
    [self.imageScrollView setImageArray:muarray];
}

- (void)setCase:(MedicalCase *)mCase andRes:(MedicalReserve *)mRes {
    if ([NSString isEmptyString:self.implantTextField.text]) {
        mCase.implant_time = @"";
    } else {
        mCase.implant_time = self.implantTextField.text;
    }
    if ([NSString isEmptyString:self.casenameTextField.text]) {
        mCase.case_name = @"";
    } else {
        mCase.case_name = self.casenameTextField.text;
    }
    if ([NSString isEmptyString:self.nextReserveTextField.text]) {
        mCase.next_reserve_time = @"";
    } else {
        mCase.next_reserve_time = self.nextReserveTextField.text;
    }
    if ([NSString isEmptyString:self.repairTextField.text]) {
        mCase.repair_time = @"";
    } else {
        mCase.repair_time = self.repairTextField.text;
    }
    
    if ([NSString isEmptyString:self.casenameTextField.text]) {
        mCase.case_name = @"无";
    } else {
        mCase.case_name = self.casenameTextField.text;
    }
    /*
    if ([NSString isEmptyString:self.repairDoctorTextField.text]) {
        mCase.repair_doctor = @"";
    } else {
        mCase.repair_doctor = self.repairDoctorTextField.text;
    }
    if ([NSString isEmptyString:self.implantTextField.text]) {
        mCase.implant_time = @"";
    } else {
        mCase.implant_time = self.implantTextField.text;
    }*/
    mCase.creation_date = [NSString currentDateString];
}

- (void)imagesScrollView:(TimImagesScrollView *)scrollView didTouchImage:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchImageView:)]) {
        [self.delegate didTouchImageView:scrollView];
    }
}


@end

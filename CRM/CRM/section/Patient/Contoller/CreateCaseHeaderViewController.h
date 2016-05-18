//
//  CreateCaseHeaderViewController.h
//  CRM
//
//  Created by TimTiger on 1/17/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
@protocol CreateCaseHeaderViewControllerDeleate;
@class TimPickerTextField,MedicalCase,MedicalReserve,TimImagesScrollView;
@interface CreateCaseHeaderViewController : TimTableViewController
@property (nonatomic,assign) id <CreateCaseHeaderViewControllerDeleate> delegate;
@property (weak, nonatomic) IBOutlet TimPickerTextField *casenameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *toothPositionField;
@property (weak, nonatomic) IBOutlet UILabel *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *implantTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *nextReserveTextField;
@property (weak, nonatomic) IBOutlet UITextField *repairTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *repairDoctorTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *expenseTextField;
//@property (weak, nonatomic) IBOutlet UILabel *expenseNumTextField;
@property (weak, nonatomic) IBOutlet TimImagesScrollView *imageScrollView;

- (void)setviewWith:(MedicalCase *)mCase andRes:(MedicalReserve *)mRes;
- (void)setImages:(NSArray *)images;
- (void)setExpenseArray:(NSArray *)expenseArray;

- (void)setCase:(MedicalCase *)mCase andRes:(MedicalReserve *)mRes;
- (IBAction)createCTAction:(id)sender;

@end

@protocol CreateCaseHeaderViewControllerDeleate <NSObject>

- (void)createCTAction:(id)sender;
- (void)didTouchImageView:(id)sender index:(NSInteger)index;
- (void)didChooseTime:(NSString *)time withType:(NSString *)type;

@end

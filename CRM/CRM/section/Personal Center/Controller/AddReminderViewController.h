//
//  AddReminderViewController.h
//  CRM
//
//  Created by doctor on 15/3/4.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
#import "TimPickerTextField.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class MedicalCase,AddReminderViewController,Patient;
@protocol AddReminderViewControllerDelegate <NSObject>

@optional
- (void)addReminderViewController:(AddReminderViewController *)vc didSelectDateTime:(NSString *)dateStr;

@end

@interface AddReminderViewController : TimTableViewController<TimPickerTextFieldDataSource,TimPickerTextFieldDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *selectMatterArray;
    NSArray *selectRepeatArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *patientArrowImageView;

@property (strong, nonatomic) IBOutlet TimPickerTextField *selectMatterTextField;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet TimPickerTextField *huanzheTextField;

@property (strong, nonatomic) IBOutlet TimPickerTextField *yaWeiTextField;

@property (weak, nonatomic) IBOutlet TimPickerTextField *medicalPlaceTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *timeTextField;

@property (weak, nonatomic) IBOutlet TimPickerTextField *medicalChairTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistCountLabel;

@property (nonatomic) BOOL isNextReserve; //从编辑病历跳转
@property (nonatomic, strong)MedicalCase *medicalCase;//编辑病历时传递过来的病历模型

@property (nonatomic, assign)BOOL isAddLocationToPatient;//给指定病人添加预约
@property (nonatomic, strong)Patient *patient;//指定病人的病历

@property (nonatomic, weak)id<AddReminderViewControllerDelegate> delegate;

@end

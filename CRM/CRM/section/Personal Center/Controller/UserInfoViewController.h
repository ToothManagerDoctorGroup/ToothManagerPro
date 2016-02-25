//
//  UserInfoViewController.h
//  CRM
//
//  Created by TimTiger on 9/6/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "TimTableViewController.h"
#import "CRMHttpRequest+PersonalCenter.h"
#import "TimPickerTextField.h"

@class SAMTextView,Doctor,UserObject;
/**
 *  好友详细信息
 */
@interface UserInfoViewController : TimTableViewController <CRMHttpRequestPersonalCenterDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *titleTextField;
@property (weak, nonatomic) IBOutlet TimPickerTextField *degreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *authstatusTextField;
@property (weak, nonatomic) IBOutlet SAMTextView *authTextView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet TimPickerTextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
@property (weak, nonatomic) IBOutlet UIButton *personalDescBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalSkill;
@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *qrBtn;

//已经有完整信息 只接传Doctor过来显示,  如果信息不完整 传一个有doctor_name 和 doctor_id的 Doctor过来,needGet set YES
@property (nonatomic,retain) Doctor *doctor;
@property (nonatomic) BOOL needGet;
@property (nonatomic) BOOL isZhuCe;
@end

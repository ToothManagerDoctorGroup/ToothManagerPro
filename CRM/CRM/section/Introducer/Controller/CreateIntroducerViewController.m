//
//  CreateIntroducerViewController.m
//  CRM
//
//  Created by mac on 14-5-13.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "CreateIntroducerViewController.h"
#import "DBManager+Introducer.h"
#import "DBManager+Patients.h"
#import "PickerTextTableViewCell.h"
#import "StarPickerTableViewCell.h"
#import "CRMMacro.h"
#import "DBManager+sync.h"
#import "CRMHttpRequest+Sync.h"

@interface CreateIntroducerViewController () <TimPickerTextFieldDataSource>

@property (nonatomic,readonly) Introducer *introducer;

@end

@implementation CreateIntroducerViewController
@synthesize introducer = _introducer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initView {
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    [self.tableView setAllowsSelection:NO];
    if (self.edit) {
        self.title = @"编辑介绍人";
    } else {
        self.title = @"新建介绍人";
    }
    
    self.nameTextField.mode = TextFieldInputModeKeyBoard;
    self.starTextField.bounds = self.nameTextField.bounds;
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initData {
    [super initData];
    if (self.edit) {
        _introducer = [[DBManager shareInstance] getIntroducerByIntroducerID:self.introducerId];
        self.nameTextField.text = self.introducer.intr_name;
        self.starTextField.starLevel = self.introducer.intr_level;
        self.phoneTextField.text = self.introducer.intr_phone;
    } else {
        _introducer = [[Introducer alloc]init];
    }
}

- (void)dealloc {
    
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    self.introducer.intr_name = self.nameTextField.text;
    self.introducer.intr_level = self.starTextField.starLevel;
    self.introducer.intr_phone = self.phoneTextField.text;
    self.introducer.intr_id = @"0";
    BOOL ret = [[DBManager shareInstance] insertIntroducer:self.introducer];
    NSString *message = nil;
    if (ret) {
        if (self.edit) {
            message = @"修改成功";
            [self postNotificationName:IntroducerEditedNotification object:nil];
        } else {
            message = @"创建成功";
            [self postNotificationName:IntroducerCreatedNotification object:nil];
            
           NSArray *recordArray = [NSMutableArray  arrayWithArray:[[DBManager shareInstance] getAllNeedSyncIntroducer]];
            if (0 != [recordArray count])
            {
                [[CRMHttpRequest shareInstance] postAllNeedSyncIntroducer:recordArray];
            }
             
        }
        [self.view makeToast:message duration:1.0f position:@"Center"];
        [self popViewControllerAnimated:YES];
    } else {
        if (self.edit) {
            message = @"修改失败";
        } else {
            message = @"创建失败";
        }
        [self.view makeToast:message duration:1.0f position:@"Center"];
    }
        
}

@end

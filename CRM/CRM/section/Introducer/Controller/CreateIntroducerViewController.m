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
#import "MJExtension.h"
#import "JSONKit.h"
#import "DBManager+AutoSync.h"
#import "XLStarView.h"
#import "XLStarSelectViewController.h"

@interface CreateIntroducerViewController () <TimPickerTextFieldDataSource,XLStarSelectViewControllerDelegate>

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
    self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.phoneTextField.mode = TextFieldInputModeKeyBoard;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeNever;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.starView.level = 1;
    self.starView.alignment = XLStarViewAlignmentRight;
    
    [self.starView addTarget:self action:@selector(chooseStarLevel) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 选择星级
- (void)chooseStarLevel{
    XLStarSelectViewController *starSelectVc = [[XLStarSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
    starSelectVc.delegate = self;
    [self pushViewController:starSelectVc animated:YES];
}

- (void)initData {
    [super initData];
    if (self.edit) {
        _introducer = [[DBManager shareInstance] getIntroducerByIntroducerID:self.introducerId];
        self.nameTextField.text = self.introducer.intr_name;
        self.starView.level = self.introducer.intr_level;
        self.phoneTextField.text = self.introducer.intr_phone;
    } else {
        _introducer = [[Introducer alloc]init];
    }
}

- (void)dealloc {
    
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    if (self.phoneTextField.text.length != 11) {
        [SVProgressHUD showImage:nil status:@"电话号码无效，请重新输入"];
        return;
    }
    
    self.introducer.intr_name = self.nameTextField.text;
    self.introducer.intr_level = self.starView.level;
    self.introducer.intr_phone = self.phoneTextField.text;
    self.introducer.intr_id = @"0";
    BOOL ret = [[DBManager shareInstance] insertIntroducer:self.introducer];
    NSString *message = nil;
    if (ret) {
        if (self.edit) {
            message = @"修改成功";
            //修改介绍人自动同步信息
            InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Update dataEntity:[self.introducer.keyValues JSONString] syncStatus:@"0"];
            [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
            
            [self postNotificationName:IntroducerEditedNotification object:nil];
        } else {
            message = @"创建成功";
            [self postNotificationName:IntroducerCreatedNotification object:nil];
            
            Introducer *tempIntr = [[DBManager shareInstance] getIntroducerByCkeyId:self.introducer.ckeyid];
            if (tempIntr != nil) {
                //创建介绍人自动同步信息
                InfoAutoSync *info = [[InfoAutoSync alloc] initWithDataType:AutoSync_Introducer postType:Insert dataEntity:[tempIntr.keyValues JSONString] syncStatus:@"0"];
                [[DBManager shareInstance] insertInfoWithInfoAutoSync:info];
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

#pragma mark - XLStarSelectViewControllerDelegate
- (void)starSelectViewController:(XLStarSelectViewController *)starSelectVc didSelectLevel:(NSInteger)level{
    self.starView.level = level;
}

@end

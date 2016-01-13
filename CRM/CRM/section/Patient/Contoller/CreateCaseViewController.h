//
//  CreateCaseViewController.h
//  CRM
//
//  Created by TimTiger on 1/17/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "TimViewController.h"

@class Patient;

@protocol CreateCaseViewControllerDelegate <NSObject>

@optional
- (void)didCancelCreateAction;

@end

@interface CreateCaseViewController : TimViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//push进界面之前设置edit为YES，则病例变为编辑状态。
@property (nonatomic,readwrite) BOOL edit;
@property (nonatomic,copy) NSString *patiendId;
//如果是编辑病例状态需要在push界面之前设置 病例id
@property (nonatomic,copy) NSString *medicalCaseId;

@property (weak, nonatomic) IBOutlet UIButton *addRecordButton;
@property (weak, nonatomic) IBOutlet UITextField *recordTextField;
@property (weak, nonatomic) IBOutlet UIView *tooBar;
- (IBAction)addRecordAction:(id)sender;


@property (nonatomic, weak)id<CreateCaseViewControllerDelegate> delegate;
@end

//
//  MaterialDetailViewController.m
//  CRM
//
//  Created by TimTiger on 6/2/14.
//  Copyright (c) 2014 TimTiger. All rights reserved.
//

#import "MaterialDetailViewController.h"
#import "DBManager+Materials.h"
#import "PickerTextTableViewCell.h"
#import "CRMMacro.h"
#import "NewMaterialsViewController.h"

@interface MaterialDetailViewController ()


@property (nonatomic,readonly) NSArray *materialTypeArray;
@property (nonatomic,readonly) NSArray *headerArray;

@end

@implementation MaterialDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"种植体详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initView
{
    [super initView];
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_editor"]];
    [self.tableView setAllowsSelection:NO];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshView {
    [super refreshView];
    [self.tableView reloadData];
}

- (void)initData {
    [super initData];
    _headerArray = @[@"种植体名称",@"种植体价格",@"种植体类型"];
    [self addNotificationObserver];
}

- (void)refreshData {
    [super refreshData];
    _material = [[DBManager shareInstance] getMaterialWithId:_material.ckeyid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotificationObserver];
}

#pragma mark - Private API

- (void)configHeader:(UITableViewHeaderFooterView *)headerView withSection:(NSInteger)section {
    headerView.textLabel.text = [_headerArray objectAtIndex:section];
}

#pragma mark - Button Action
- (void)onRightButtonAction:(id)sender {
    //完成创建
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NewMaterialsViewController * editMaterialVC = [storyboard instantiateViewControllerWithIdentifier:@"NewMaterialsViewController"];
    editMaterialVC.edit = YES;
    editMaterialVC.materialId = _material.ckeyid;
    [self pushViewController:editMaterialVC animated:YES];
}

#pragma mark - Notification
- (void)addNotificationObserver {
    [super addNotificationObserver];
    [self addObserveNotificationWithName:MaterialCreatedNotification];
    [self addObserveNotificationWithName:MaterialEditedNotification];
}

- (void)removeNotificationObserver {
    [super removeNotificationObserver];
    [self removeObserverNotificationWithName:MaterialEditedNotification];
    [self removeObserverNotificationWithName:MaterialCreatedNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MaterialCreatedNotification] ||
        [notifacation.name isEqualToString:MaterialEditedNotification]) {
        [self refreshData];
        [self refreshView];
    }
}


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_headerArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"headerIdentifier";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerIdentifier];
        [headerView setBackgroundViewWithColor:self.view.backgroundColor];
        headerView.textLabel.textColor = TABLE_SECTION_HEADER_TITLE_COLOR;
        headerView.textLabel.font = TABLE_SECTION_HEADER_TITLE_FONT;
    }
    [self configHeader:headerView withSection:section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = _material.mat_name;
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%.2f",_material.mat_price];
            break;
        case 2:
            cell.textLabel.text = [Material typeStringWith:_material.mat_type];
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

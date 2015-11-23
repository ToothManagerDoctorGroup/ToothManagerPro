//
//  CaseMaterialsViewController.m
//  CRM
//
//  Created by TimTiger on 2/3/15.
//  Copyright (c) 2015 TimTiger. All rights reserved.
//

#import "CaseMaterialsViewController.h"
#import "CaseMaterialsTableViewCell.h"
#import "CRMMacro.h"
#import "TimFramework.h"
#import "DBTableMode.h"
#import "DBManager+Materials.h"
#import "MaterialsViewController.h"

@interface CaseMaterialsViewController () <CaseMaterialsTableViewCellDelegate,MaterialsViewControllerDelegate>
@property (nonatomic) NSInteger selectIndex;
@end

@implementation CaseMaterialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initView {
    [super initView];
    self.title = @"种植体编辑";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_complet"]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
}

- (void)initData{
    [super initData];
}

- (void)refreshData {
    [super refreshData];
}

- (void)refreshView {
    [super refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions 
- (void)onBackButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)onRightButtonAction:(id)sender {
    [self.delegate didSelectedMaterialsArray:self.materialsArray];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addLineAction:(id)sender {
    MedicalExpense *expense = [[MedicalExpense alloc]init];
    expense.expense_num = 1;
    [self.materialsArray addObject:expense];
    [self.tableView reloadData];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.materialsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CaseMaterialsSectionView" owner:nil options:nil] objectAtIndex:0];
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.materialsArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [button addTarget:self action:@selector(addLineAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"添加种植体" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR];
    return button;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"CaseMaterialsCell";
    CaseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CaseMaterialsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"CaseMaterialsTableViewCell" bundle:nil] forCellReuseIdentifier:cellString];
    }
    cell.delegate = self;
    cell.tag = 100+indexPath.row;
    [cell setCell:@[@"AAAAAA",@"sljdaldjsf",@"Olljaldjf"]];
    MedicalExpense *expense = [self.materialsArray objectAtIndex:indexPath.row];
    if (expense.mat_id) {
        Material *material = [[DBManager shareInstance] getMaterialWithId:expense.mat_id];
        cell.materialName.text = material.mat_name;
    } else {
        cell.materialName.text = @"名称";
    }
    cell.materialNum.text = [NSString stringWithFormat:@"%d",expense.expense_num];
    return cell;
}

#pragma mark - cell Delegate
- (void)didBeginEdit:(CaseMaterialsTableViewCell *)cell {
    self.selectIndex = cell.tag-100;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    MaterialsViewController *materialVC = [storyboard instantiateViewControllerWithIdentifier:@"MaterialsViewController"];
    materialVC.delegate = self;
    materialVC.mode = MaterialViewModeSelect;
    [self pushViewController:materialVC animated:YES];
}

- (void)tableViewCell:(CaseMaterialsTableViewCell *)cell materialNum:(NSInteger)num {
    MedicalExpense *expense = [self.materialsArray objectAtIndex:cell.tag-100];
    expense.expense_num = num;
}

- (void)didSelectedMaterial:(Material *)material {
   MedicalExpense *expense = [self.materialsArray objectAtIndex:self.selectIndex];
    expense.mat_id = material.ckeyid;
    [self.tableView reloadData];
}


@end
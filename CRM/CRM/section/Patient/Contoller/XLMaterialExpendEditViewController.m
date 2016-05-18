//
//  XLMaterialExpendEditViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/10.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMaterialExpendEditViewController.h"
#import "CaseMaterialsTableViewCell.h"
#import "CRMMacro.h"
#import "TimFramework.h"
#import "DBTableMode.h"
#import "DBManager+Materials.h"
#import "XLMaterialsViewController.h"

@interface XLMaterialExpendEditViewController () <CaseMaterialsTableViewCellDelegate,XLMaterialsViewControllerDelegate>
@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic, strong)NSMutableArray *expenses;

@end

@implementation XLMaterialExpendEditViewController

- (NSMutableArray *)expenses{
    if (!_expenses) {
        _expenses = [NSMutableArray array];
    }
    return _expenses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)initView {
    [super initView];
    self.title = @"添加耗材";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.tableView.allowsSelection = NO;
    
    [self.expenses addObjectsFromArray:self.exitExpenses];
    //默认添加一个种植体
    [self addLineAction:nil];
}


- (void)hideKeyboard{
    [self.view endEditing:YES];
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
}

#pragma mark - Actions
- (void)onRightButtonAction:(id)sender {
    for (int i = 0; i < self.expenses.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CaseMaterialsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        MedicalExpense *expense = self.expenses[i];
        expense.expense_num = [cell.materialNum.text integerValue];
        expense.mat_name = [[DBManager shareInstance] getMaterialWithId:expense.mat_id].mat_name;
    }
    
    //隐藏当前编辑框
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)addLineAction:(id)sender {
    
    for (int i = 0; i < self.expenses.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CaseMaterialsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        MedicalExpense *expense = self.expenses[i];
        if ([cell.materialCount integerValue] != 0) {
            expense.expense_num = [cell.materialNum.text integerValue];
        }
    }
    
    MedicalExpense *expense = [[MedicalExpense alloc]init];
    [self.expenses addObject:expense];
    [self.tableView reloadData];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CaseMaterialsSectionView" owner:nil options:nil] objectAtIndex:0];
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.expenses removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button addTarget:self action:@selector(addLineAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"material_add"] forState:UIControlStateNormal];
    [button setTitle:@"添加条目" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:NAVIGATIONBAR_BACKGROUNDCOLOR] forState:UIControlStateNormal];
    
    return button;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"CaseMaterialsCell";
    CaseMaterialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CaseMaterialsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        [tableView registerNib:[UINib nibWithNibName:@"CaseMaterialsTableViewCell" bundle:nil] forCellReuseIdentifier:cellString];
    }
    if (indexPath.row == 0) {
        cell.deleteButton.hidden = YES;
    }else{
        cell.deleteButton.hidden = NO;
    }
    
    cell.delegate = self;
    cell.tag = 100+indexPath.row;
    [cell setCell:@[@"AAAAAA",@"sljdaldjsf",@"Olljaldjf"]];
    MedicalExpense *expense = [self.expenses objectAtIndex:indexPath.row];
    if (expense.mat_id) {
        Material *material = [[DBManager shareInstance] getMaterialWithId:expense.mat_id];
        cell.materialName.text = material.mat_name;
        
        cell.materialName.textColor = [UIColor blackColor];
    } else {
        cell.materialName.text = @"选择种植体类型";
        cell.materialName.textColor = [UIColor colorWithHex:0xdddddd];
    }
    if (expense.expense_num == 0) {
        cell.materialNum.text = @"";
    }else{
        cell.materialNum.text = [NSString stringWithFormat:@"%ld",(long)expense.expense_num];
    }
    
    return cell;
}

#pragma mark - cell Delegate
- (void)didBeginEdit:(CaseMaterialsTableViewCell *)cell {
    
    for (int i = 0; i < self.expenses.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CaseMaterialsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        MedicalExpense *expense = self.expenses[i];
        if ([cell.materialCount integerValue] != 0) {
            expense.expense_num = [cell.materialNum.text integerValue];
        }
    }
    
    self.selectIndex = cell.tag - 100;
    XLMaterialsViewController *materialVC = [[XLMaterialsViewController alloc] init];
    materialVC.delegate = self;
    materialVC.mode = XLMaterialViewModeSelect;
    
    [self pushViewController:materialVC animated:YES];
}

- (void)tableViewCell:(CaseMaterialsTableViewCell *)cell materialNum:(NSInteger)num {
    MedicalExpense *expense = [self.expenses objectAtIndex:cell.tag - 100];
    expense.expense_num = num;
}

- (void)didDeleteCell:(CaseMaterialsTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.expenses removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)didSelectedMaterial:(Material *)material {
    MedicalExpense *expense = [self.expenses objectAtIndex:self.selectIndex];
    expense.mat_id = material.ckeyid;
    [self.tableView reloadData];
}


@end

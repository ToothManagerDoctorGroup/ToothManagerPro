//
//  XLReserveTypesViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLReserveTypesViewController.h"

@interface XLReserveTypesViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLReserveTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"治疗项目";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataList = [NSArray arrayWithObjects:@"定方案",@"种植",@"拆线",@"修复",@"取模",@"戴牙",@"复查",@"根充",@"扩根",@"洗牙",@"补牙",@"拔牙",@"刮治",@"其它", nil];
}

- (void)onBackButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    if ([self.dataList[indexPath.row] isEqualToString:self.reserve_type] && self.dataList[indexPath.row] != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.reserve_type = self.dataList[indexPath.row];
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(reserveTypesViewController:didSelectReserveType:)]) {
        [self.delegate reserveTypesViewController:self didSelectReserveType:self.dataList[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

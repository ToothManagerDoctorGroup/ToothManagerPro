//
//  XLStarSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/2/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLStarSelectViewController.h"
#import "XLStarSelectCell.h"

@interface XLStarSelectViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLStarSelectViewController

- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = @[@(1),@(2),@(3),@(4),@(5)];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.title = @"选择星级";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLStarSelectCell *cell = [XLStarSelectCell cellWithTableView:tableView];
    
    cell.level = [self.dataList[indexPath.row] integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger level = [self.dataList[indexPath.row] integerValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(starSelectViewController:didSelectLevel:)]) {
        [self.delegate starSelectViewController:self didSelectLevel:level];
    }
    
    [self popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

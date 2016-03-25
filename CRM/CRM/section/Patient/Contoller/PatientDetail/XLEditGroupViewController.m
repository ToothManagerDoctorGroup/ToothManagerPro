//
//  XLEditGroupViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLEditGroupViewController.h"
#import "XLEditGroupCell.h"
#import "UIColor+Extension.h"

@interface XLEditGroupViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLEditGroupViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        NSArray *functions = @[@"添加到新分组"];
        NSArray *groups = @[@"凯旋城",@"凯城",@"你好",@"我搜"];
        _dataList = [NSMutableArray arrayWithObjects:functions,groups,nil];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setUpNav];
    
    //加载数据
}

- (void)setUpNav{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"完成"];
    self.title = @"选择分组";
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XLEditGroupCell fixHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *ID = @"function_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
        }
        
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        
        return cell;
    }else{
        XLEditGroupCell *cell = [XLEditGroupCell cellWithTableView:tableView];
        
        cell.content = self.dataList[indexPath.section][indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

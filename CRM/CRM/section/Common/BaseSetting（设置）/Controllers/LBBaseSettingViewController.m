//
//  LBBaseSettingViewController.m
//  LBWeiBo
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 徐晓龙. All rights reserved.
//

#import "LBBaseSettingViewController.h"
#import "LBBaseSettingCell.h"
#import "LBBaseSetting.h"

@interface LBBaseSettingViewController ()

@end

@implementation LBBaseSettingViewController

- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

//总共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LBSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.获取模型数据
    LBSettingGroup *group = self.groups[indexPath.section];
    LBSettingItem *item = group.items[indexPath.row];
    // 2.创建cell
    LBBaseSettingCell *cell = [LBBaseSettingCell cellWithTableView:tableView];
    // 3.添加模型数据
    cell.item = item;
    
    return cell;
}
//设置尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    LBSettingGroup *group = self.groups[section];
    return group.footTitle;
}
//设置头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    LBSettingGroup *group = self.groups[section];
    return group.headTitle;
}
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LBSettingGroup *group = self.groups[indexPath.section];
    LBSettingItem *item = group.items[indexPath.row];
    
    if (item.option) {
        item.option(item);
        return;
    }
    
    if (item.targetVc) {
        UIViewController *VC = [[item.targetVc alloc] init];
        VC.title = item.title;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


@end

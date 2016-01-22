//
//  XLSeniorStatisticsViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/22.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLSeniorStatisticsViewController.h"

@interface XLSeniorStatisticsViewController ()

@end

@implementation XLSeniorStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNavStyle];
    
    //设置子视图
    [self setUpSubViews];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavStyle{
    if (self.type == SeniorStatisticsViewControllerPlant) {
        self.title = @"种植统计";
    }else{
        self.title = @"修复统计";
    }
    self.view.backgroundColor = MyColor(241, 242, 243);
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 初始化子视图
- (void)setUpSubViews{
    
}


#pragma mark - UITableViewDelegate/Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"statistic_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

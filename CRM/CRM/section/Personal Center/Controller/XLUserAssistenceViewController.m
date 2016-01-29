//
//  XLUserAssistenceViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/28.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLUserAssistenceViewController.h"
#import "UIColor+Extension.h"
#import "XLAssistenceDetailViewController.h"

@interface XLUserAssistenceViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLUserAssistenceViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"【初诊患者到医院就诊】如何操作?",@"【复诊患者到医院就诊】如何操作?",@"【某患者的治疗需要其他医生协助】如何操作？",@"【患者想要介绍朋友给医生】如何操作？", nil];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setNavStyle];
}

#pragma mark - 设置导航栏样式
- (void)setNavStyle{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = MyColor(238, 238, 238);
    self.title = @"使用帮助";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"assistence_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - 1, kScreenWidth, 1)];
        view.backgroundColor = [UIColor colorWithHex:0xdddddd];
        [cell.contentView addSubview:view];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLAssistenceDetailViewController *detailVc = [[XLAssistenceDetailViewController alloc] init];
    if (indexPath.row == 0) {
        detailVc.image = [UIImage imageNamed:@"assistence_01"];
        detailVc.title = @"初诊患者到医院就诊";
    }else if (indexPath.row == 1){
        detailVc.image = [UIImage imageNamed:@"assistence_02"];
        detailVc.title = @"复诊患者到医院就诊";
    }else if (indexPath.row == 2){
        detailVc.image = [UIImage imageNamed:@"assistence_03"];
        detailVc.title = @"患者治疗需要协助";
    }else{
        detailVc.image = [UIImage imageNamed:@"assistence_04"];
        detailVc.title = @"患者介绍朋友给医生";
    }
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end

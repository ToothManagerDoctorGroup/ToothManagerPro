//
//  XLAdviceTypeSelectViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLAdviceTypeSelectViewController.h"
#import "DoctorTool.h"
#import "XLAdviceTypeModel.h"

@interface XLAdviceTypeSelectViewController ()

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation XLAdviceTypeSelectViewController

#pragma mark - ******************* Life Method **********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子控件
    [self setUpViews];
    //请求数据
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ******************* Private Method **********************
#pragma mark 设置子控件
- (void)setUpViews{
    self.title = @"选择医嘱类型";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}

#pragma mark 加载数据
- (void)requestData{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorTool getMedicalAdviceTypeSuccess:^(NSArray *result) {
        [SVProgressHUD dismiss];
        
        weakSelf.dataList = result;
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - ****************** Delegate / dataSource **************
#pragma mark UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"select_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    XLAdviceTypeModel *model = self.dataList[indexPath.row];
    
    cell.textLabel.text = model.type_name;
    
    if (self.currentModel && [self.currentModel.type_name isEqualToString:model.type_name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLAdviceTypeModel *model = self.dataList[indexPath.row];
    
    self.currentModel = model;
    
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(adviceTypeSelectViewController:didSelectTypeModel:)]) {
        [self.delegate adviceTypeSelectViewController:self didSelectTypeModel:model];
    }
    
    [self popViewControllerAnimated:YES];
}

@end

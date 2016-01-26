//
//  XLReserveTypesViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/12/23.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "XLReserveTypesViewController.h"
#import "XLMessageTemplateTool.h"
#import "AccountManager.h"
#import "XLMessageTemplateModel.h"

@interface XLReserveTypesViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLReserveTypesViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"治疗项目";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //请求网络数据
    [self requestWlanData];
}
- (void)requestWlanData{
    [SVProgressHUD showWithStatus:@"正在获取预约事项"];
    [XLMessageTemplateTool getMessageTemplateByDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        //对数据进行分组
        for (XLMessageTemplateModel *model in result) {
            if ([model.message_name isEqualToString:@"种植术后注意事项"] || [model.message_name isEqualToString:@"修复术后注意事项"] ||
                [model.message_name isEqualToString:@"转诊后通知"] ||
                [model.message_name isEqualToString:@"成为介绍人通知"]) {
            }else{
                [self.dataList addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
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
    
    XLMessageTemplateModel *model = self.dataList[indexPath.row];
    cell.textLabel.text = model.message_type;
    
    if ([model.message_type isEqualToString:self.reserve_type] && model.message_type != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLMessageTemplateModel *model = self.dataList[indexPath.row];
    
    self.reserve_type = model.message_type;
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(reserveTypesViewController:didSelectReserveType:)]) {
        [self.delegate reserveTypesViewController:self didSelectReserveType:model.message_type];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

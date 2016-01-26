//
//  XLMessageTemplateViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/25.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLMessageTemplateViewController.h"
#import "XLMessageTemplateTool.h"
#import "AccountManager.h"
#import "XLMessageTemplateModel.h"
#import "UIColor+Extension.h"

@interface XLMessageTemplateViewController ()

@property (nonatomic, strong)NSMutableArray *messageTemplates;

@end

@implementation XLMessageTemplateViewController

- (NSMutableArray *)messageTemplates{
    if (!_messageTemplates) {
        _messageTemplates = [NSMutableArray array];
    }
    return _messageTemplates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //设置导航栏样式
    [self setUpNavStyle];
    //获取用户的消息模板
    [self requestData];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavStyle{
    self.title = @"提醒事项";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.view.backgroundColor = MyColor(238, 238, 238);
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - 请求网络数据
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在获取模板"];
    [XLMessageTemplateTool getMessageTemplateByDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        //对数据进行分组
        NSMutableArray *group1 = [NSMutableArray array];
        NSMutableArray *group2 = [NSMutableArray array];
        for (XLMessageTemplateModel *model in result) {
            if ([model.message_name isEqualToString:@"种植术后注意事项"] || [model.message_name isEqualToString:@"修复术后注意事项"] ||
                [model.message_name isEqualToString:@"转诊后通知"] ||
                [model.message_name isEqualToString:@"成为介绍人通知"]) {
                [group1 addObject:model];
            }else{
                [group2 addObject:model];
            }
        }
        
        [self.messageTemplates addObject:group1];
        [self.messageTemplates addObject:group2];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageTemplates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.messageTemplates[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = MyColor(238, 238, 238);
    
    NSString *title = @"预约通知提醒";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:titleLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    addBtn.frame = CGRectMake(kScreenWidth - 50 - 10, 20, 50, 20);
    [view addSubview:addBtn];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"template_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    
    XLMessageTemplateModel *model = self.messageTemplates[indexPath.section][indexPath.row];
    cell.textLabel.text = model.message_name;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

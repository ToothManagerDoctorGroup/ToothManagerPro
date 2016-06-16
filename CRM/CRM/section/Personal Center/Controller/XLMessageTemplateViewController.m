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
#import "XLTemplateDetailViewController.h"
#import "UITableView+NoResultAlert.h"

@interface XLMessageTemplateViewController ()

@property (nonatomic, strong)NSMutableArray *messageTemplates;

@end

@implementation XLMessageTemplateViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)messageTemplates{
    if (!_messageTemplates) {
        _messageTemplates = [NSMutableArray array];
    }
    return _messageTemplates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //设置导航栏样式
    [self setUpNavStyle];
    //获取用户的消息模板
    [self requestDataIsRefresh:NO];
    //添加通知
    [self addNotification];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavStyle{
    self.title = @"通知管理";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
}
#pragma mark - 添加通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLocalData) name:MessageTemplateAddNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLocalData) name:MessageTemplateEditNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLocalData) name:MessageTemplateDeleteNotification object:nil];
}
#pragma mark - 刷新数据
- (void)refreshLocalData{
    [self requestDataIsRefresh:YES];
}

- (void)refreshLocalDataNoRefresh{
    [self requestDataIsRefresh:NO];
}

#pragma mark - 请求网络数据
- (void)requestDataIsRefresh:(BOOL)isRefresh{
    if (!isRefresh) [SVProgressHUD showWithStatus:@"正在加载"];
    WS(weakSelf);
    [XLMessageTemplateTool getMessageTemplateByDoctorId:[AccountManager currentUserid] success:^(NSArray *result) {
        
        weakSelf.tableView.tableHeaderView = nil;
        [weakSelf.messageTemplates removeAllObjects];
        //对数据进行分组
        NSMutableArray *group1 = [NSMutableArray array];
        NSMutableArray *group2 = [NSMutableArray array];
        NSMutableArray *group3 = [NSMutableArray array];
        NSMutableArray *group4 = [NSMutableArray array];
        for (XLMessageTemplateModel *model in result) {
            if ([model.message_name isEqualToString:@"种植术后注意事项"] || [model.message_name isEqualToString:@"修复术后注意事项"]) {
                [group1 addObject:model];
            }else if([model.message_name isEqualToString:@"转诊后通知"]){
                [group2 addObject:model];
            }else if ([model.message_name isEqualToString:@"成为介绍人通知"]){
                [group3 addObject:model];
            }else{
                [group4 addObject:model];
            }
        }
        
        [weakSelf.messageTemplates addObject:group1];
        [weakSelf.messageTemplates addObject:group2];
        [weakSelf.messageTemplates addObject:group3];
        [weakSelf.messageTemplates addObject:group4];
        
        if (!isRefresh) [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (!isRefresh) [SVProgressHUD showImage:nil status:error.localizedDescription];
        
        [weakSelf.tableView createNoResultWithImageName:@"no_net_alert" ifNecessaryForRowCount:weakSelf.messageTemplates.count target:weakSelf action:@selector(refreshLocalDataNoRefresh)];
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
    if (section == 3) return 30;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 3) return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = [UIColor colorWithHex:VIEWCONTROLLER_BACKGROUNDCOLOR];
    
    NSString *title = @"预约通知";
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (30 - titleSize.height) / 2, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:titleLabel];
    
    NSString *buttonTitle = @"添加自定义";
    CGSize buttonTitleSize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:buttonTitle forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHex:0x00a0ea] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    addBtn.frame = CGRectMake(kScreenWidth - buttonTitleSize.width - 20 - 10, 5, buttonTitleSize.width + 20, 30);
    [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XLMessageTemplateModel *model = self.messageTemplates[indexPath.section][indexPath.row];
    
    XLTemplateDetailViewController *detailVc = [[XLTemplateDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailVc.model = model;
    detailVc.isEdit = YES;
    if (indexPath.section == 0) {
        detailVc.hindTintView = YES;
    }
    if (indexPath.section != 3) {
        detailVc.isSystem = YES;
    }
    [self pushViewController:detailVc animated:YES];
}


#pragma mark - 添加模板
- (void)addBtnAction{
    XLTemplateDetailViewController *detailVc = [[XLTemplateDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailVc.isSystem = YES;
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

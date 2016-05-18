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
#import "DoctorGroupTool.h"
#import "AccountManager.h"
#import "DoctorGroupModel.h"
#import "CustomAlertView.h"
#import "DBManager+AutoSync.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "UITableView+NoResultAlert.h"

@interface XLEditGroupViewController ()<CustomAlertViewDelegate,XLEditGroupCellDelegate>

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *orginSelectGroups;
@property (nonatomic, strong)NSMutableArray *orginUnSelectGroups;

@end

@implementation XLEditGroupViewController

- (void)dealloc{
    [self.dataList removeAllObjects];
    self.dataList = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        NSArray *functions = @[@"添加到新分组"];
        _dataList = [NSMutableArray arrayWithObjects:functions,nil];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setUpNav];
    
    //加载数据
    [self requestData];
}
#pragma mark - 设置导航栏
- (void)setUpNav{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"完成"];
    self.title = @"选择分组";
}

#pragma mark - 完成按钮点击
- (void)onRightButtonAction:(id)sender{
    NSMutableArray *addArray = [NSMutableArray array];
    NSMutableString *mStr = [NSMutableString string];
    //编辑模式下
    if (self.isEdit) {
        //获取所有进行操作的分组信息
        NSMutableArray *deleteArray = [NSMutableArray array];
        for (DoctorGroupModel *model in [self.dataList lastObject]) {
            if (self.orginExistGroups.count > 0) {
                for (DoctorGroupModel *detailM in self.orginExistGroups) {
                    if (model.isSelect) {
                        [mStr appendFormat:@"%@、",model.group_name];
                        [addArray addObject:model];
                        break;
                    }else{
                        if ([model.ckeyid isEqualToString:detailM.ckeyid]) {
                            [deleteArray addObject:model];
                            break;
                        }
                    }
                }
            }else{
                if (model.isSelect) {
                    NSLog(@"选中了");
                    [mStr appendFormat:@"%@、",model.group_name];
                    [addArray addObject:model];
                }else{
                    NSLog(@"未被选中");
                }
            }
        }
        NSString *groupName = mStr.length > 0 ? [mStr substringToIndex:mStr.length - 1] : @"";
        if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupViewController:didAddGroups:delectGroups:groupName:)]) {
            [self.delegate editGroupViewController:self didAddGroups:addArray delectGroups:deleteArray groupName:groupName];
        }
        [self popViewControllerAnimated:YES];
        
    }else{
        if(self.dataList.count > 1){
            for (DoctorGroupModel *model in [self.dataList lastObject]) {
                if (model.isSelect) {
                    [addArray addObject:model];
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(editGroupViewController:didSelectGroups:)]) {
            [self.delegate editGroupViewController:self didSelectGroups:addArray];
        }
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - 加载数据
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorGroupTool getGroupListWithDoctorId:[AccountManager currentUserid] ckId:@"" patientId:@"" success:^(NSArray *result) {
        
        [SVProgressHUD dismiss];
        if (self.isEdit) {
            if (self.currentGroups.count > 0) {
                for (DoctorGroupModel *model in result) {
                    for (DoctorGroupModel *detailM in self.currentGroups) {
                        if ([model.ckeyid isEqualToString:detailM.ckeyid]) {
                            model.isSelect = YES;
                            break;
                        }
                    }
                }
            }
        }else{
            if (self.currentGroups.count > 0) {
                for (DoctorGroupModel *model in result) {
                    for (DoctorGroupModel *curModel in self.currentGroups) {
                        if ([curModel.ckeyid isEqualToString:model.ckeyid]) {
                            model.isSelect = YES;
                            break;
                        }
                    }
                }
            }
        }
        
        if (self.dataList.count > 1) {
            [self.dataList removeObject:[self.dataList lastObject]];
        }
        [self.dataList addObject:result];
        //刷新表示图
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView createNoResultAlertViewWithImageName:@"noGroup_alert" showButton:NO ifNecessaryForRowCount:self.dataList.count];
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
    return 1;
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
        DoctorGroupModel *model = self.dataList[indexPath.section][indexPath.row];
        cell.delegate = self;
        cell.model = model;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithAlertTitle:@"新建分组" cancleTitle:@"取消" certainTitle:@"保存"];
        alertView.type = CustomAlertViewTextField;
        alertView.delegate = self;
        [alertView show];
    }else{
        XLEditGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell selectOption];
    }
}

#pragma mark - XLEditGroupCellDelegate
- (void)editGroupCell:(XLEditGroupCell *)cell didSelect:(BOOL)isSelect{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DoctorGroupModel *model = self.dataList[indexPath.section][indexPath.row];
    model.isSelect = isSelect;
}

#pragma mark - CustomAlertViewDelegate
- (void)alertView:(CustomAlertView *)alertView didClickCertainButtonWithContent:(NSString *)content{
    if (content.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"分组名不能为空"];
        return;
    }
    if ([content isValidLength:32] == ValidationResultInValid) {
        [SVProgressHUD showErrorWithStatus:@"分组名最多为16个汉字"];
        return;
    }
    
    //添加分组
    [SVProgressHUD showWithStatus:@"正在创建..."];
    GroupEntity *group = [[GroupEntity alloc] initWithName:content desc:@"描述" doctorId:[[AccountManager shareInstance] currentUser].userid];
    [DoctorGroupTool addNewGroupWithGroupEntity:group success:^(CRMHttpRespondModel *respondModel) {
        
        if ([respondModel.code integerValue] == 200) {
            [self requestData];
        }else{
            [SVProgressHUD showErrorWithStatus:respondModel.result];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"分组创建失败"];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

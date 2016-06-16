//
//  XLDiseaseRecordViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordViewController.h"
#import "XLDiseaseRecordModel.h"
#import "XLDiseaseRecordModelFrame.h"
#import "XLDiseaseRecordCell.h"
#import "XLDiseaseRecordDetailController.h"
#import "XLDiseaseRecordEditController.h"
#import "XLTeamTool.h"
#import "DBTableMode.h"

@interface XLDiseaseRecordViewController ()

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLDiseaseRecordViewController

- (NSMutableArray *)dataList{
    if (!_dataList) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            XLDiseaseRecordModel *model = [[XLDiseaseRecordModel alloc] init];
            model.time = @"2015-09-08 16:04";
            model.type = @"种植手术";
            model.images = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
            
            XLDiseaseRecordModelFrame *modelFrame = [[XLDiseaseRecordModelFrame alloc] init];
            modelFrame.model = model;
            [array addObject:modelFrame];
        }
        _dataList = array;
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"btn_new"]];
    self.title = @"病程记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //查询所有病程记录
    [XLTeamTool queryAllDiseaseRecordWithCaseId:self.mCase.ckeyid success:^(NSArray *result) {
        
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)onRightButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLDiseaseRecordEditController *editView = [storyboard instantiateViewControllerWithIdentifier:@"XLDiseaseRecordEditController"];
    [self pushViewController:editView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLDiseaseRecordModelFrame *modelFrame = self.dataList[indexPath.row];
    return modelFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLDiseaseRecordModelFrame *modelFrame = self.dataList[indexPath.row];
    
    XLDiseaseRecordCell *cell = [XLDiseaseRecordCell cellWithTableView:tableView];
    
    cell.modelFrame = modelFrame;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
    XLDiseaseRecordDetailController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"XLDiseaseRecordDetailController"];
    [self pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

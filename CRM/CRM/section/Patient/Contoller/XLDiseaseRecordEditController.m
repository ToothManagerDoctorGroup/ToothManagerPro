//
//  XLDiseaseRecordEditController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/3.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLDiseaseRecordEditController.h"
#import "XLImageSelectView.h"

@interface XLDiseaseRecordEditController ()<XLImageSelectViewDelegate>
@property (weak, nonatomic) IBOutlet XLImageSelectView *imageSelectView;

@property (weak, nonatomic) IBOutlet UILabel *ctTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toothLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


@property (nonatomic, strong)NSArray *dataList;
@end

@implementation XLDiseaseRecordEditController

- (void)dealloc{
    self.imageSelectView = nil;
    self.ctTitle = nil;
    self.dataList = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加病程";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithTitle:@"保存"];
    self.dataList = @[[UIImage imageNamed:@"user"],[UIImage imageNamed:@"user_icon"]];
    
    self.imageSelectView.images = self.dataList;
    self.imageSelectView.delegate = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return [self.imageSelectView getTotalHeigth] + self.ctTitle.bottom + 20;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - XLImageSelectViewDelegate
- (void)imageSelectView:(XLImageSelectView *)selectView didChooseImages:(NSArray *)images{
    self.imageSelectView.images = images;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

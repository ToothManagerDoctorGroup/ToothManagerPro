//
//  XLBackUpViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/3/19.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLBackUpViewController.h"
#import "DBManager+AutoSync.h"
#import "DBTableMode.h"

@interface XLBackUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backUpButton;

@property (nonatomic, strong)NSArray *dataList;//未上传的数据

@end

@implementation XLBackUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"云端备份";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //设置数据
    [self setUpData];

}

- (void)awakeFromNib{
    self.backUpButton.layer.cornerRadius = 5;
    self.backUpButton.layer.masksToBounds = YES;
}

- (void)setUpData{
    //获取数据
    self.dataList = [[DBManager shareInstance] getInfoListWithSyncStatus:@"4"];
    if (self.dataList.count == 0) {
        self.titleLabel.text = @"当前没有数据未同步云端服务器";
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"您有%lu数据未同步到云端服务器",(unsigned long)self.dataList.count];
    }
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"说明:数据备份到云端后，当您刷机或更换手机时，存储在种牙管家的数据不会丢失";
}
- (IBAction)backUpAction:(id)sender {
    if (self.dataList.count == 0) {
        [SVProgressHUD showImage:nil status:@"当前没有数据未同步云端服务器"];
    }else{
        for (InfoAutoSync *info in self.dataList) {
            //重置所有消息的同步次数和上传状态
            info.syncCount = 0;
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"0" byInfo:info];
        }
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [self setUpData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

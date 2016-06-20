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
#import "UIColor+Extension.h"
#import "CRMAppDelegate.h"

@interface XLBackUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backUpButton;

@property (nonatomic, strong)NSArray *dataList;//未上传的数据
@property (nonatomic, strong)NSArray *errorDataList;//上传失败的数据

@end

@implementation XLBackUpViewController

- (void)dealloc{
    self.dataList = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"云端备份";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    //设置数据
    [self setUpData];
}

- (void)setUpData{
    //获取数据
    self.dataList = [[DBManager shareInstance] getInfoListWithSyncStatus:@"0"];
    self.errorDataList = [[DBManager shareInstance] getInfoListBySyncCountWithStatus:@"4"];
    if (self.dataList.count == 0 && self.errorDataList.count == 0) {
        self.titleLabel.text = @"您的数据已全部在云端服务器备份，暂时没有需要同步的数据！";
        self.backUpButton.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
        self.backUpButton.enabled = NO;
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"您有%lu条数据需要同步到云端服务器",(unsigned long)(self.dataList.count + self.errorDataList.count)];
    }
}

#pragma mark - UITableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"说明:数据备份到云端后，当您刷机或更换手机时，储存在种牙管家的数据都能够恢复回来";
}
- (IBAction)backUpAction:(id)sender {
    NetworkStatus status = [CRMAppDelegate appDelegate].connectionStatus;
    if (status == NotReachable) {
        //无网络
        [SVProgressHUD showImage:nil status:@"网络异常，请检查网络设置"];
        return;
    }
    
    if (self.dataList.count == 0 && self.errorDataList.count == 0) {
        [SVProgressHUD showImage:nil status:@"您的数据已全部在云端服务器备份，暂时没有需要同步的数据！"];
    }else{
        
        for (InfoAutoSync *info in self.errorDataList) {
            //重置所有消息的同步次数和上传状态
            info.syncCount = 0;
            [[DBManager shareInstance] updateInfoWithSyncStatus:@"0" byInfo:info];
        }
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

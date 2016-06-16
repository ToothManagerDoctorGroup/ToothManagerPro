//
//  XLPatientAppointViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/1/4.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLPatientAppointViewController.h"
#import "XLPatientAppointCell.h"
#import "DBManager+LocalNotification.h"
#import "XLAppointDetailViewController.h"

@interface XLPatientAppointViewController ()

@property (nonatomic, strong)NSArray *dataList;

@property (nonatomic, weak)UIView *noResultView;//没有数据时显示的页面

@end

@implementation XLPatientAppointViewController

- (UIView *)noResultView{
    if (!_noResultView) {
        UIView *noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        self.noResultView = noResultView;
        noResultView.backgroundColor = [UIColor whiteColor];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.height - 40) / 2, kScreenWidth, 40)];
        textLabel.text = @"没有预约信息";
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = MyColor(136, 136, 136);
        textLabel.textAlignment = NSTextAlignmentCenter;
        [noResultView addSubview:textLabel];
        
        [self.tableView addSubview:noResultView];
    }
    return _noResultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setUpNav];
    
    self.dataList = [self updateListTimeArray:[[DBManager shareInstance] localNotificationListByPatientId:self.patient_id]];
    if (self.dataList.count > 0) {
        self.noResultView.hidden = YES;
    }else{
        self.noResultView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//设置导航栏
- (void)setUpNav{
    self.title = @"预约记录";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDelegate / DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLPatientAppointCell *cell = [XLPatientAppointCell cellWithTableView:tableView];
    cell.localNoti = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LocalNotification *localNoti = self.dataList[indexPath.row];
    
    XLAppointDetailViewController *detailVc =[[XLAppointDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailVc.localNoti = localNoti;
    [self pushViewController:detailVc animated:YES];
    
}


//按照时间排序  08:00  09:00 09:30
- (NSArray *)updateListTimeArray:(NSArray *)remindArray1{
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"reserve_time" ascending:NO];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc] initWithObjects:&sorter count:1];
    NSArray *sortArray=[remindArray1 sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

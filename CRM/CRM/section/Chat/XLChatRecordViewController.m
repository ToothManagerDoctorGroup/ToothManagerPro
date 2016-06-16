//
//  XLChatRecordViewController.m
//  CRM
//
//  Created by Argo Zhang on 16/4/27.
//  Copyright © 2016年 TimTiger. All rights reserved.
//

#import "XLChatRecordViewController.h"
#import "XLSearchBar.h"
#import "XLSearchDisplayController.h"
#import "UISearchBar+XLMoveBgView.h"
#import "XLChatRecordCell.h"
#import "XLChatModel.h"
#import "XLChatBaseModel.h"
#import "XLMessageReadManager.h"
#import "UINavigationItem+Margin.h"
#import "XLCalendarSelectViewController.h"
#import "DoctorTool.h"
#import "XLChatRecordQueryModel.h"
#import "AccountManager.h"
#import "DBTableMode.h"
#import "UIColor+Extension.h"
#import "CRMMacro.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManager+Media.h"
#import "XLFilePathManager.h"
#import "UIViewController+HUD.h"
#import "MJRefresh.h"
#import "MyDateTool.h"
#import "XLSearchRecordCell.h"
#import "CRMHttpRespondModel.h"
#import <UITableView+SDAutoTableViewCellHeight.h>

@interface XLChatRecordViewController ()<UISearchBarDelegate,XLChatRecordCellDelegate,XLCalendarSelectViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, assign)BOOL isPlayingAudio;

@property (nonatomic, strong)XLSearchBar *searchBar;
@property (nonatomic, strong)XLSearchDisplayController *searchController;
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation XLChatRecordViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图
    [self setUpViews];
    //加载数据
    [self requestAllChatRecordWithBeginTime:@"" keyWord:@"" isFirstLoad:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 设置子视图
- (void)setUpViews{
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    UIButton *calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarBtn.frame = CGRectMake(0, 0, 44, 44);
    [calendarBtn setImage:[UIImage imageNamed:@"communicate_rili"] forState:UIControlStateNormal];
    [calendarBtn addTarget:self action:@selector(calendarAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *calendarItem = [[UIBarButtonItem alloc] initWithCustomView:calendarBtn];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 25, 44);
    [deleteBtn setImage:[UIImage imageNamed:@"communicate_del"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,calendarItem,deleteItem]];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:SEARCH_BAR_BACKGROUNDCOLOR];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //设置搜索框
    [self.view addSubview:self.searchBar];
    [self searchController];
    
    //添加下拉刷新
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction:)];
    _tableView.header.updatedTimeHidden = YES;
    //添加上拉加载
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction:)];
    _tableView.footer.hidden = YES;
}

#pragma mark 下拉刷新
- (void)headerRefreshAction:(MJRefreshLegendHeader *)header{
    //获取数组中的第一条数据
    XLChatBaseModel *baseModel = [self.dataList firstObject];
    NSString *searchTime = baseModel.contentModel.send_time;
    //根据时间查询之前的数据
    [self queryChatRecordByBeginTime:@"" endTime:searchTime keyWord:@"" isHeader:YES];
}
#pragma mark 上拉加载
- (void)footerRefreshAction:(MJRefreshLegendFooter *)footer{
    //获取数组中的最后一条数据
    XLChatBaseModel *baseModel = [self.dataList lastObject];
    NSString *searchTime = baseModel.contentModel.send_time;
    //根据时间查询之前的数据
    [self queryChatRecordByBeginTime:searchTime endTime:@"" keyWord:@"" isHeader:NO];
}

#pragma mark 加载所有聊天记录
- (void)requestAllChatRecordWithBeginTime:(NSString *)beginTime keyWord:(NSString *)keyWord isFirstLoad:(BOOL)isFirstLoad{
    NSString *ids = [NSString stringWithFormat:@"%@,%@",[AccountManager currentUserid],self.patient.ckeyid];
    XLChatRecordQueryModel *queryModel = [[XLChatRecordQueryModel alloc] initWithSenderId:ids receiverId:ids beginTime:beginTime endTime:@"" keyWord:keyWord sortField:@"" isAsc:YES];
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在加载"];
    [DoctorTool getAllChatRecordWithChatQueryModel:queryModel success:^(NSArray *result) {
        [SVProgressHUD dismiss];
        //判读数据是否超过20
        if (result.count > 15) {
            _tableView.footer.hidden = NO;
        }else{
            _tableView.footer.hidden = YES;
        }
        //将模型转换成视图模型
        for (XLChatModel *chatModel in result) {
            XLChatBaseModel *baseModel = [[XLChatBaseModel alloc] initWithChatModel:chatModel];
            [weakSelf.dataList addObject:baseModel];
        }
        
        [_tableView reloadData];
        
        if (result.count > 0) {
            if (isFirstLoad) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:result.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}
#pragma mark 模糊查询聊天记录,根据时间来查询
- (void)queryChatRecordByBeginTime:(NSString *)beginTime endTime:(NSString *)endTime keyWord:(NSString *)keyWord isHeader:(BOOL)isHeader{
    NSString *ids = [NSString stringWithFormat:@"%@,%@",[AccountManager currentUserid],self.patient.ckeyid];
    XLChatRecordQueryModel *queryModel = [[XLChatRecordQueryModel alloc] initWithSenderId:ids receiverId:ids beginTime:beginTime endTime:endTime keyWord:keyWord sortField:@"" isAsc:YES];
    WS(weakSelf);
    [DoctorTool getAllChatRecordWithChatQueryModel:queryModel success:^(NSArray *result) {
        //将模型转换成视图模型
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (XLChatModel *chatModel in result) {
            XLChatBaseModel *baseModel = [[XLChatBaseModel alloc] initWithChatModel:chatModel];
            [tmpArray addObject:baseModel];
        }
        
        if (isHeader) {
            XLChatBaseModel *firstModel = [self.dataList firstObject];
            for (XLChatBaseModel *baseM in tmpArray) {
                if ([firstModel.contentModel.keyId isEqualToString:baseM.contentModel.keyId]) {
                    [weakSelf.dataList removeObject:firstModel];
                    break;
                }
            }
            //将查询到的数据添加到数组头部
            [weakSelf.dataList insertObjects:tmpArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tmpArray count])]];
            
            [_tableView.header endRefreshing];
            [_tableView reloadData];
            if (tmpArray.count > 1) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tmpArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }else{
            XLChatBaseModel *lastModel = [self.dataList lastObject];
            for (XLChatBaseModel *baseM in tmpArray) {
                if ([lastModel.contentModel.keyId isEqualToString:baseM.contentModel.keyId]) {
                    [weakSelf.dataList removeObject:lastModel];
                    break;
                }
            }
            [self.dataList addObjectsFromArray:tmpArray];
            
            [_tableView.footer endRefreshing];
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark calendarAction
- (void)calendarAction{
    XLCalendarSelectViewController *calendarSelectVc = [[XLCalendarSelectViewController alloc] init];
    calendarSelectVc.delegate = self;
    [self pushViewController:calendarSelectVc animated:YES];
}

#pragma mark deleteAction
- (void)deleteAction{
    WS(weakSelf);
    TimAlertView *alertView = [[TimAlertView alloc] initWithTitle:@"提示" message:@"是否删除此患者的所有聊天记录?" cancelHandler:^{
    } comfirmButtonHandlder:^{
        [SVProgressHUD showWithStatus:@"正在删除"];
        NSString *ids = [NSString stringWithFormat:@"%@,%@",[AccountManager currentUserid],self.patient.ckeyid];
        [DoctorTool deleteChatRecordWithKeyId:@"" receiverId:ids senderId:ids success:^(CRMHttpRespondModel *respond) {
            if ([respond.code integerValue] == 200) {
                [SVProgressHUD dismiss];
                
                [weakSelf popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showImage:nil status:@"删除失败"];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showImage:nil status:@"删除失败"];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }];
    [alertView show];
}

#pragma mark - ********************* Delegate / DataSource ********************
#pragma mark UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XLChatBaseModel *baseModel = self.dataList[indexPath.row];
    
    NSString *reuseId = [XLChatRecordCell cellIdentifierWithModel:baseModel];
    
    XLChatRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[XLChatRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId model:baseModel];
    }
    cell.delegate = self;
    cell.model = baseModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLChatBaseModel *baseModel = self.dataList[indexPath.row];
    return [XLChatRecordCell cellHeightWithModel:baseModel];
}

#pragma mark XLCalendarSelectViewControllerDelegate
- (void)calendarSelectVC:(XLCalendarSelectViewController *)calendarSelectVC didSelectDate:(NSDate *)date{
    //根据选择的时间查询数据
    [self.dataList removeAllObjects];
    [self requestAllChatRecordWithBeginTime:[MyDateTool stringWithDateWithSec:date] keyWord:@"" isFirstLoad:NO];
}

#pragma mark XLChatRecordCellDelegate
- (void)messageCellSelected:(XLChatBaseModel *)model{
    switch (model.messageType) {
        case XLMessageTypeText:
            NSLog(@"点击文本");
            break;
            
        case XLMessageTypeImage:
            NSLog(@"点击图片");
            [[XLMessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:model.contentModel.content]]];
            break;
        case XLMessageTypeVoice:
        {
            //判断语音目录下是否有此语音文件
            BOOL exist = [[XLFilePathManager shareInstance] fileExistsWithFilePath:model.voiceFilePath];
            if (!exist) {
                //判断下载状态
                if (model.downStatus == XLFileDownLoadStatusDownLoading) {
                    [self showHint:@"正在下载语音文件"];
                    return;
                }
                if (model.downStatus == XLFileDownLoadStatusFail || model.downStatus == XLFileDownLoadStatusPrepare) {
                    model.downStatus = XLFileDownLoadStatusDownLoading;
                    [self showHint:@"正在下载语音文件"];
                    [[XLFilePathManager shareInstance] downLoadFileWithUrl:model.contentModel.content fileLocalPath:model.voiceFilePath success:^{
                        [self showHint:@"语音文件下载成功"];
                        model.downStatus = XLFileDownLoadStatusSuccess;
                    } failure:^(NSError *error) {
                        model.downStatus = XLFileDownLoadStatusFail;
                        if (error) {
                            NSLog(@"error:%@",error);
                        }
                    }];
                }
                return;
            }
            
            BOOL isPrepare = [[XLMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(XLChatBaseModel *prevAudioModel, XLChatBaseModel *currentAudioModel) {
                if (prevAudioModel || currentAudioModel) {
                    [_tableView reloadData];
                }
            }];
            if (isPrepare) {
                _isPlayingAudio = YES;
                __weak XLChatRecordViewController *weakSelf = self;
                [[EMCDDeviceManager sharedInstance] enableProximitySensor];
                [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.voiceFilePath completion:^(NSError *error) {
                    [[XLMessageReadManager defaultManager] stopMessageAudioModel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                        weakSelf.isPlayingAudio = NO;
                        [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                    });
                }];
            }else{
                _isPlayingAudio = NO;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString *ids = [NSString stringWithFormat:@"%@,%@",[AccountManager currentUserid],self.patient.ckeyid];
    XLChatRecordQueryModel *queryModel = [[XLChatRecordQueryModel alloc] initWithSenderId:ids receiverId:ids beginTime:@"" endTime:@"" keyWord:searchBar.text sortField:@"" isAsc:NO];
    WS(weakSelf);
    [DoctorTool getAllChatRecordWithChatQueryModel:queryModel success:^(NSArray *result) {
        if (result.count > 0) {
            weakSelf.searchController.hideNoResult = YES;
        }else{
            weakSelf.searchController.hideNoResult = NO;
        }
        [weakSelf.searchController.resultsSource removeAllObjects];
        [weakSelf.searchController.resultsSource addObjectsFromArray:result];
        [weakSelf.searchController.searchResultsTableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - ********************* Lazy Method ***********************
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[XLSearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        [_searchBar moveBackgroundView];
    }
    
    return _searchBar;
}

- (XLSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[XLSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        __weak XLChatRecordViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            XLChatModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            XLSearchRecordCell *cell = [XLSearchRecordCell cellWithTableView:tableView];
            cell.model = model;
            [cell setSearchText:weakSelf.searchController.searchBar.text model:model];
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            XLChatModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[XLSearchRecordCell class] contentViewWidth:[XLSearchRecordCell contentMaxWidth]];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            weakSelf.searchController.active = NO;
            //根据选择的时间查询数据
            XLChatModel *model = weakSelf.searchController.resultsSource[indexPath.row];
            [weakSelf.dataList removeAllObjects];
            [weakSelf requestAllChatRecordWithBeginTime:model.send_time keyWord:@"" isFirstLoad:NO];
        }];
        
    }
    return _searchController;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - 创建测试数据
- (NSArray *)createData{
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        XLChatModel *model = [[XLChatModel alloc] initWithReceiverId:@"1009_20150401089907" receiverName:@"李四" content:@"你好，阳光"];
        XLChatBaseModel *baseModel = [[XLChatBaseModel alloc] initWithChatModel:model];
        [mArray addObject:baseModel];
    }
    return mArray;
}


@end

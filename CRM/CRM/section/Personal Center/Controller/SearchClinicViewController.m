//
//  SearchClinicViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "SearchClinicViewController.h"
#import "BaiduMapHeader.h"
#import "MyClinicTool.h"
#import "UnSignClinicModel.h"
#import "UnSignClinicCell.h"
#import "ClinicDetailViewController.h"
#import "ClinicTitleButton.h"

#import "ClinicPopMenu.h"
#import "ClinicCover.h"
#import "TitleMenuViewController.h"
#import "ClinicMapViewController.h"
#import "AccountManager.h"
#import "UISearchBar+XLMoveBgView.h"


@interface SearchClinicViewController ()<UISearchBarDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,ClinicCoverDelegate,TitleMenuViewControllerDelegate>{
    BMKLocationService *_bmkLocationService; //定位类
    BMKGeoCodeSearch *_codeSearch;//地图编码类
    ClinicTitleButton *_titleButton;//标题按钮

    UISearchBar *_searchBar;//搜索框
}

//存放数据模型：UnSignClinicModel
@property (nonatomic, strong)NSArray *dataList;
@property (nonatomic, strong)NSMutableArray *searchDataList;

@property (nonatomic, strong)TitleMenuViewController *titleMenuVc;

@property (nonatomic, strong)ClinicCover *cover;//蒙板

@property (nonatomic, copy)NSString *currentCityName;


@end

@implementation SearchClinicViewController

#pragma mark -懒加载
- (NSArray *)dataList{
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (TitleMenuViewController *)titleMenuVc{
    if (!_titleMenuVc) {
        _titleMenuVc = [[TitleMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        _titleMenuVc.delegate = self;
    }
    return _titleMenuVc;
}

- (void)viewDidDisappear:(BOOL)animated{
    _bmkLocationService.delegate = nil;
    _codeSearch.delegate = nil;
}

- (void)dealloc{
    _bmkLocationService = nil;
    _codeSearch = nil;
    _titleButton = nil;
    _titleMenuVc = nil;
    _cover = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setUpNavBar];
    
    //设置子视图
    [self setUpSubViews];
    
    //开始百度地图定位
    [self startLocation];
}

#pragma mark - 设置导航栏样式
- (void)setUpNavBar{
    [super initView];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"zzs_zb"]];
    
    //创建标题按钮
    ClinicTitleButton *titleButton = [ClinicTitleButton buttonWithType:UIButtonTypeCustom];
    _titleButton = titleButton;
    //获取账号中保存的用户名称
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"zs_xjt"] forState:UIControlStateNormal];
    //设置高亮的适合不需要调整图片
    titleButton.adjustsImageWhenHighlighted = NO;
    //设置标题按钮
    self.navigationItem.titleView = titleButton;
    //设置标题按钮的点击事件
    [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //隐藏表视图
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SVProgressHUD showWithStatus:@"正在加载"];
}

#pragma mark -标题按钮点击事件
//标题按钮点击事件
- (void)titleButtonClick:(ClinicTitleButton *)button{
    button.selected = !button.selected;
    
    //显示遮罩
    ClinicCover *cover = [ClinicCover show];
    cover.delegate = self;
    self.cover = cover;
    
    //显示弹出菜单
    ClinicPopMenu *menu = [ClinicPopMenu showInRect:CGRectMake((self.view.width - 150) * 0.5, 55, 150, 200)];
    //设置弹出菜单的内容视图
    menu.contentView = self.titleMenuVc.view;
    
    
}

#pragma mark -地图按钮的点击事件
- (void)onRightButtonAction:(id)sender{
    
    ClinicMapViewController *mapVc = [[ClinicMapViewController alloc] init];
    mapVc.hidesBottomBarWhenPushed = YES;
    mapVc.currentCityName = _currentCityName;
    [self.navigationController pushViewController:mapVc animated:YES];
}

#pragma mark - LBCoverDelegate
- (void)coverDidClickCover:(ClinicCover *)cover{
    //隐藏菜单
    [ClinicPopMenu hide];
    
    //设置按钮选中状态
//    _titleButton.selected = NO;
}


#pragma mark -设置子视图
- (void)setUpSubViews{
    //设置搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入名称,地址搜索";
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    searchBar.frame = CGRectMake(0, 0, 100, 44);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    _searchBar = searchBar;
    [_searchBar moveBackgroundView];
}

#pragma mark -百度地图定位功能实现
- (void)startLocation{
    _bmkLocationService = [[BMKLocationService alloc] init];
    _bmkLocationService.delegate = self;
    [_bmkLocationService startUserLocationService];
    
    //初始化编码类
    _codeSearch = [[BMKGeoCodeSearch alloc] init];
    _codeSearch.delegate = self;
}

//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //定位成功后关闭定位服务
    [_bmkLocationService stopUserLocationService];
    //获取用户当前位置的经纬度
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_codeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
}
//停止定位后调用的方法
- (void)didStopLocatingUser{
    NSLog(@"定位结束");
}

#pragma mark -定位之后反编码信息
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //获取当前所在城市名称
      NSString *currentCity = result.addressDetail.city;
      _currentCityName = currentCity;
      //设置标题按钮的内容
      [_titleButton setTitle:currentCity forState:UIControlStateNormal];
      //根据城市名称查询诊所
      [self requestClinicInfoWithAreaName:currentCity];
      
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

#pragma mark -请求网络数据
- (void)requestClinicInfoWithAreaName:(NSString *)areaName{
    //根据城市名称查询诊所
    [MyClinicTool requestClinicInfoWithAreacode:areaName success:^(NSArray *result) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [SVProgressHUD dismiss];
        //将数组赋值
        self.dataList = result;
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark -视图消失后清楚代理对象
- (void)viewWillDisappear:(BOOL)animated{
    _bmkLocationService.delegate = nil;
    _codeSearch.delegate = nil;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.获取模型对象
    UnSignClinicModel *model = self.dataList[indexPath.row];
    
    // 2.创建cell
    UnSignClinicCell *cell = [UnSignClinicCell cellWithTableView:tableView];
    
    // 3.加载数据模型
    cell.model = model;
    
    return cell;
    
}

//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取当前的数据模型
    UnSignClinicModel *model = self.dataList[indexPath.row];
    
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ClinicDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"ClinicDetailViewController"];
    detailVc.unsignModel = model;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始拖动的时候，隐藏键盘
    [self.tableView endEditing:YES];
}

#pragma mark -UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if ([searchText isEqualToString:@""]) {
        [self requestClinicInfoWithAreaName:_titleButton.currentTitle];
    }else{
        [self searchClinicWithClinicName:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //隐藏键盘
    [self.view endEditing:YES];
    
    [self searchClinicWithClinicName:searchBar.text];
}

//请求诊所信息数据
- (void)searchClinicWithClinicName:(NSString *)clinicName{
    
    [MyClinicTool requestClinicInfoWithAreacode:nil clinicName:clinicName success:^(NSArray *result) {
        self.dataList = result;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}


#pragma mark -TitleMenuViewControllerDelegate
- (void)titleMenuViewController:(TitleMenuViewController *)menuController didSelectTitle:(NSString *)title{
    //先隐藏当前的弹出视图
    [ClinicPopMenu hide];
    [self.cover removeFromSuperview];
    
    //修改当前标题的数据
    [_titleButton setTitle:title forState:UIControlStateNormal];
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    //请求网络数据
    [self requestClinicInfoWithAreaName:title];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

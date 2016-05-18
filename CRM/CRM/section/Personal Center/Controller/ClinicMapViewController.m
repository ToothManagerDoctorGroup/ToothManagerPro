//
//  ClinicMapViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/14.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicMapViewController.h"

#import "ClinicPopMenu.h"
#import "ClinicCover.h"
#import "ClinicTitleButton.h"
#import "TitleMenuViewController.h"
#import "BaiduMapHeader.h"
#import "ClinicAnnotationView.h"
#import "MyClinicTool.h"
#import "UnSignClinicModel.h"
#import "ClinicAnnotation.h"
#import "ClinicDetailViewController.h"
#import "UISearchBar+XLMoveBgView.h"

@interface ClinicMapViewController ()<ClinicCoverDelegate,TitleMenuViewControllerDelegate,UISearchBarDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKCloudSearchDelegate>{
    ClinicTitleButton *_titleButton;//标题按钮
    BMKLocationService *_bmkLocationService; //定位类
    BMKMapView *_mapView;//地图
    
    BMKCloudSearch *_cloudSearch;//云检索
    UISearchBar *_searchBar;
}

@property (nonatomic, strong)TitleMenuViewController *titleMenuVc;

@property (nonatomic, strong)ClinicCover *cover;//蒙板

@end

@implementation ClinicMapViewController

#pragma mark -懒加载
- (TitleMenuViewController *)titleMenuVc{
    if (!_titleMenuVc) {
        _titleMenuVc = [[TitleMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        _titleMenuVc.delegate = self;
    }
    return _titleMenuVc;
}

- (void)viewWillAppear:(BOOL)animated{
    _mapView.delegate = self;
    _bmkLocationService.delegate = self;
    _cloudSearch.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated{
    _mapView.delegate = nil;
    _bmkLocationService.delegate = nil;
    _cloudSearch.delegate = nil;
}

- (void)dealloc{
    _mapView = nil;
    _titleButton = nil;
    _bmkLocationService = nil;
    _cloudSearch = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏样式
    [self setUpNavBar];
    
    //设置子视图
    [self setUpSubViews];
    
}
#pragma mark - 设置导航栏样式
- (void)setUpNavBar{
    [super initView];
    
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    
    
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
}
#pragma mark -本地云检索方法
- (void)cloudLocalSearchWithCityName:(NSString *)cityName address:(NSString *)address{
    
    BMKCloudLocalSearchInfo *cloudLocalSearch = [[BMKCloudLocalSearchInfo alloc] init];
    cloudLocalSearch.ak = @"f1Rz6ZDkyGr3PD3EGV9GRX6T";
    cloudLocalSearch.geoTableId = 108691;
    cloudLocalSearch.pageIndex = 0;
    cloudLocalSearch.pageSize = 10;
    
    cloudLocalSearch.region = cityName;
    if (address == nil || [address isEqualToString:@""]) {
        cloudLocalSearch.keyword = @" ";
    }else{
        cloudLocalSearch.keyword = address;
    }
    
    BOOL flag = [_cloudSearch localSearchWithSearchInfo:cloudLocalSearch];
    if(flag){
        NSLog(@"本地云检索发送成功");
    }else{
        NSLog(@"本地云检索发送失败");
    }
}

//返回云检索结果回调
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error{
    //声明解析时对坐标数据的位置区域的筛选，包括经度和纬度的最小值和最大值
    CLLocationDegrees minLat = 0.0;
    CLLocationDegrees maxLat = 0.0;
    CLLocationDegrees minLon = 0.0;
    CLLocationDegrees maxLon = 0.0;
    
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (error == BMKErrorOk) {
        BMKCloudPOIList* result = [poiResultList objectAtIndex:0];
        for (int i = 0; i < result.POIs.count; i++) {
            BMKCloudPOIInfo* poi = [result.POIs objectAtIndex:i];
            ClinicAnnotation* item = [[ClinicAnnotation alloc] init];
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
            UnSignClinicModel *model = [[UnSignClinicModel alloc] init];
            model.clinic_name = poi.title;
            model.clinic_location = poi.address;
            model.clinic_id = poi.customDict[@"clinic_id"];
            item.coordinate = pt;
            item.model = model;
            [_mapView addAnnotation:item];
            
            if (i==0) {
                //以第一个坐标点做初始值
                minLat = item.coordinate.latitude;
                maxLat = item.coordinate.latitude;
                minLon = item.coordinate.longitude;
                maxLon = item.coordinate.longitude;
            }else{
                //对比筛选出最小纬度，最大纬度；最小经度，最大经度
                minLat = MIN(minLat, item.coordinate.latitude);
                maxLat = MAX(maxLat, item.coordinate.latitude);
                minLon = MIN(minLon, item.coordinate.longitude);
                maxLon = MAX(maxLon, item.coordinate.longitude);
            }
        }
        //计算中心点
        CLLocationCoordinate2D centCoor;
        centCoor.latitude = (CLLocationDegrees)((maxLat + minLat) * 0.5f);
        centCoor.longitude = (CLLocationDegrees)((maxLon + minLon) * 0.5f);
        BMKCoordinateSpan span;
        //计算地理位置的跨度
        span.latitudeDelta = maxLat - minLat;
        span.longitudeDelta = maxLon - minLon;
        //得出数据的坐标区域
        BMKCoordinateRegion region = BMKCoordinateRegionMake(centCoor, span);
        //百度地图的坐标范围转换成相对视图的位置
        CGRect fitRect = [_mapView convertRegion:region toRectToView:_mapView];
        //将地图视图的位置转换成地图的位置
        BMKMapRect fitMapRect = [_mapView convertRect:fitRect toMapRectFromView:_mapView];
        //设置地图可视范围为数据所在的地图位置
        [_mapView setVisibleMapRect:fitMapRect animated:YES];
        
    } else {
        NSLog(@"error ==%d",error);
    }
}

#pragma mark -设置子视图
- (void)setUpSubViews{
    //设置搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入名称搜索";
    searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
    searchBar.delegate = self;
//    searchBar.backgroundImage = [UIImage imageNamed:@"sq_bj"];
    [_searchBar moveBackgroundView];
    [self.view addSubview:searchBar];
    _searchBar = searchBar;
    
     _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 64 - 44)];
    //设置百度地图的类型
    _mapView.zoomLevel = 12;
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showMapScaleBar = YES;
    _mapView.showMapPoi = YES;
    [self.view addSubview:_mapView];
    
    
    //设置定位按钮
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locBtn setBackgroundImage:[UIImage imageNamed:@"zzs_sz"] forState:UIControlStateNormal];
    locBtn.frame = CGRectMake(kScreenWidth - 40 - 30, _mapView.height - 40 - 40, 40, 40);
    [locBtn addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:locBtn];
    
    
    _bmkLocationService = [[BMKLocationService alloc] init];
    //开始定位
    [_bmkLocationService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    //本地云检索对象
    _cloudSearch = [[BMKCloudSearch alloc] init];
    
}
#pragma mark -定位按钮的点击事件
- (void)locationButtonClick{
    //点击之后重新开始定位
    [_bmkLocationService startUserLocationService];
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

#pragma mark - LBCoverDelegate
- (void)coverDidClickCover:(ClinicCover *)cover{
    //隐藏菜单
    [ClinicPopMenu hide];
    
    //设置按钮选中状态
    //    _titleButton.selected = NO;
}

#pragma mark -TitleMenuViewControllerDelegate
- (void)titleMenuViewController:(TitleMenuViewController *)menuController didSelectTitle:(NSString *)title{
    //先隐藏当前的弹出视图
    [ClinicPopMenu hide];
    [self.cover removeFromSuperview];
    
    //修改当前标题的数据
    [_titleButton setTitle:title forState:UIControlStateNormal];
    
    //请求云存储数据
    [self cloudLocalSearchWithCityName:title address:nil];
}

#pragma mark -定位成功后
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_bmkLocationService stopUserLocationService];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    //在地图上显示当前用户的位置
    [_mapView updateLocationData:userLocation];
    
    //发起本地云检索
    [self cloudLocalSearchWithCityName:self.currentCityName address:nil];
    
    //显示标题按钮上的文字
    [_titleButton setTitle:self.currentCityName forState:UIControlStateNormal];
}
//地图状态变化调用的方法
- (void)mapStatusDidChanged:(BMKMapView *)mapView{
    //隐藏键盘
    if ([_searchBar isFirstResponder]) {
        [_searchBar endEditing:YES];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    ClinicAnnotationView *newAnnotationView = [ClinicAnnotationView clinicAnnotationViewWithMapView:mapView annotation:annotation];
    newAnnotationView.annotation = annotation;
    return newAnnotationView;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    ClinicAnnotation *myAnno = (ClinicAnnotation *)view.annotation;
    UnSignClinicModel *model = myAnno.model;
    //执行页面跳转
    //跳转到详情页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ClinicDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"ClinicDetailViewController"];
    detailVc.unsignModel = model;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark -UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //搜索
    [self cloudLocalSearchWithCityName:_titleButton.currentTitle address:searchText];
}

@end

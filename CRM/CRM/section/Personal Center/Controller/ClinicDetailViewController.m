//
//  ClinicDetailViewController.m
//  CRM
//
//  Created by Argo Zhang on 15/11/11.
//  Copyright © 2015年 TimTiger. All rights reserved.
//

#import "ClinicDetailViewController.h"
#import "ChairDetailView.h"
#import "MyClinicTool.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "ClinicModel.h"
#import "ChairDetailScrollView.h"
#import "ClinicDetailModel.h"
#import "SeatModel.h"
#import "ClinicImageModel.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "XLClinicModel.h"
#import "SignDetailViewController.h"
#import "ClinicTitleButton.h"
#import "XLClinicAppointmentViewController.h"

@interface ClinicDetailViewController ()<ChairDetailScrollViewDelegate,SignDetailViewControllerDelegate>

#define ChairLabelHeight 30
#define ChairLabelWidth ChairLabelHeight
#define ChairColorNomal [UIColor blackColor]
#define ChairColorSelected [UIColor blueColor]
#define ChairLineColor ChairColorSelected


@property (weak, nonatomic) IBOutlet UILabel *businessTimeLabel; //营业时间
@property (weak, nonatomic) IBOutlet UILabel *clinicPhoneLabel;  //诊所电话
@property (weak, nonatomic) IBOutlet UILabel *clinicScale;       //诊所规模
@property (weak, nonatomic) IBOutlet UILabel *clinicAddress;     //诊所地址
@property (weak, nonatomic) IBOutlet UIScrollView *chairScrollView;//椅位列表
@property (weak, nonatomic) IBOutlet ChairDetailScrollView *chairDetailScrollView;//椅位详细信息
@property (weak, nonatomic) IBOutlet UIScrollView *clinicSceneScrollView;//诊所实景视图



//当前选中的椅位
@property (nonatomic, strong)UILabel *selectedLabel;
//诊所图片数组
@property (nonatomic, strong)NSArray *clinicImages;

@end

@implementation ClinicDetailViewController

#pragma mark -懒加载
- (NSArray *)clinicImages{
    if (!_clinicImages) {
        _clinicImages = [NSArray array];
    }
    return _clinicImages;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setUpNavBar];
    
    //请求网络数据
    [self requestData];
}
#pragma mark - 设置导航栏样式
- (void)setUpNavBar{
    [super initView];
    self.title = @"诊所详情";
    [self setBackBarButtonWithImage:[UIImage imageNamed:@"btn_back"]];
    //如果是未签约的诊所信息
    if (self.unsignModel) {
        //设置右侧按钮
        UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        right.text = @"预约";
        right.textColor = [UIColor whiteColor];
        right.font = [UIFont systemFontOfSize:16];
        right.userInteractionEnabled = YES;
        //添加单击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findClinicAction:)];
        [right addGestureRecognizer:tap];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    }
}
#pragma mark -*******************请求网络数据*******************
- (void)requestData{
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString *clinicId;
    if (self.unsignModel) {
        clinicId = self.unsignModel.clinic_id;
    }else{
        clinicId = self.model.clinic_id;
    }
    //请求网络数据测试
    [MyClinicTool requestClinicDetailWithClinicId:clinicId accessToken:nil success:^(ClinicDetailModel *result) {
        [SVProgressHUD dismiss];
        //根据数据模型加载视图
        [self initViewWithModel:result];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 根据数据模型加载视图
- (void)initViewWithModel:(ClinicDetailModel *)model{
    //设置顶部数据
    [self setTopDataWithModel:model];
    //设置中部数据
    [self setMiddleDataWithModel:model];
    //设置底部数据
    [self setBottomDataWithModel:model];
}
//设置顶部数据
- (void)setTopDataWithModel:(ClinicDetailModel *)model{
    self.businessTimeLabel.text = model.business_hours;
    self.clinicPhoneLabel.text = model.clinic_phone;
    self.clinicScale.text = [NSString stringWithFormat:@"专家:%@名，预约量：%@单",model.ClinicSummary[@"doctor_count"],model.ClinicSummary[@"appoint_count"]];
    self.clinicAddress.text = model.clinic_location;
}
//设置中部数据
- (void)setMiddleDataWithModel:(ClinicDetailModel *)model{
    if (model.Seats.count > 0) {
        //获取椅位数据
        NSArray *seats = model.Seats;
        //设置底部分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ChairLabelHeight - 1, ChairLabelWidth, 1)];
        line.tag = 99;
        line.backgroundColor = ChairLineColor;
        [self.chairScrollView addSubview:line];
        self.chairScrollView.userInteractionEnabled = YES;
        self.chairScrollView.backgroundColor = [UIColor whiteColor];
        //设置椅位列表视图
        for (int i = 0; i < seats.count; i++) {
            //获取椅位信息model
            SeatModel *seatModel = seats[i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * ChairLabelWidth, 0, ChairLabelWidth, ChairLabelHeight)];
            label.text = seatModel.seat_name;
            label.textColor = ChairColorNomal;
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = i + 100;
            label.userInteractionEnabled = YES;
            //添加单击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [label addGestureRecognizer:tap];
            
            [self.chairScrollView addSubview:label];
            
            if (i == 0) {
                label.textColor = ChairColorSelected;
                _selectedLabel = label;
            }
        }
        
        //2.设置椅位详情滚动视图
        self.chairDetailScrollView.dataList = seats;
        self.chairDetailScrollView.backgroundColor = [UIColor whiteColor];
        self.chairDetailScrollView.chairDelegate = self;
    }
}
//设置底部数据
- (void)setBottomDataWithModel:(ClinicDetailModel *)model{
    if (model.ClinicInfo.count > 0) {
        _clinicImages = model.ClinicInfo;
        //设置诊所实景滚动视图
        self.clinicSceneScrollView.contentSize = CGSizeMake(_clinicImages.count * kScreenWidth, 0);
        self.clinicSceneScrollView.pagingEnabled = YES;
        self.clinicSceneScrollView.backgroundColor = [UIColor whiteColor];
        self.clinicSceneScrollView.bounces = NO;
        self.clinicSceneScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < _clinicImages.count; i++) {
            //获取图片模型
            ClinicImageModel *imageModel = _clinicImages[i];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, self.clinicSceneScrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            //设置imageView的点击事件
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [imageView addGestureRecognizer:imageTap];
            //网络图片加载
            NSURL *imageUrl = [NSURL URLWithString:imageModel.img_info];
            [imageView sd_setImageWithURL:imageUrl];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.clinicSceneScrollView addSubview:imageView];
        }
    }
}

#pragma mark -图片点击事件
- (void)imageTapAction:(UITapGestureRecognizer *)tap{
    //获取当前点击的视图
    UIImageView *imageView = (UIImageView *)tap.view;
    //遍历当前图片数组，将LBPhoto模型转换成MJPhoto模型
    NSMutableArray *mJPhotos = [NSMutableArray array];
    int i = 0;
    for (ClinicImageModel *photo in _clinicImages) {
        //将图片url转换成高清的图片url
        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
        mjPhoto.url = [NSURL URLWithString:photo.img_info];
        mjPhoto.srcImageView = imageView;
        mjPhoto.index = i;
        [mJPhotos addObject:mjPhoto];
        i++;
    }
    
    //创建图片显示控制器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = mJPhotos;
    browser.currentPhotoIndex = imageView.tag;
    //显示
    [browser show];
}

#pragma mark 找诊所按钮点击事件
- (void)findClinicAction:(UITapGestureRecognizer *)tap{
    //创建跳转页面
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    SignDetailViewController *detailVc = [storyboard instantiateViewControllerWithIdentifier:@"SignDetailViewController"];
//    detailVc.hidesBottomBarWhenPushed = YES;
//    detailVc.delegate = self;
//    if (self.model) {
//        detailVc.signModel = self.model;
//    }else{
//        detailVc.unSignModel = self.unsignModel;
//    }
//    [self.navigationController pushViewController:detailVc animated:YES];
    //跳转到详情页面
    XLClinicAppointmentViewController *appointVc = [[XLClinicAppointmentViewController alloc] init];
    appointVc.clinicModel = self.unsignModel;
    if (self.patient) {
        appointVc.patient = self.patient;
    }
    appointVc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:appointVc animated:YES];
}

#pragma mark -椅位单击事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    UIView *line = [self.chairScrollView viewWithTag:99];
    //设置之前字体的颜色
    _selectedLabel.textColor = ChairColorNomal;
    label.textColor = ChairColorSelected;
    _selectedLabel = label;
    
    //移动分割线
    [UIView animateWithDuration:.15 animations:^{
        line.frame = CGRectMake((label.tag - 100) * ChairLabelWidth, ChairLabelHeight - 1, ChairLabelWidth, 1);
    }];
    
    //移动椅位详细信息视图
    self.chairDetailScrollView.contentOffset = CGPointMake((label.tag - 100) * kScreenWidth, 0);
    
}

#pragma mark -ChairDetailScrollViewDelegate
- (void)chairDetailScrollView:(ChairDetailScrollView *)scrollView didSelectedIndex:(NSUInteger)index{
    NSLog(@"滚动到%lu",(unsigned long)index);
    UIView *line = [self.chairScrollView viewWithTag:99];
    UILabel *label = [self.chairScrollView viewWithTag:100 + index];
    //设置之前字体的颜色
    _selectedLabel.textColor = ChairColorNomal;
    label.textColor = ChairColorSelected;
    _selectedLabel = label;
    
    [UIView animateWithDuration:.15 animations:^{
        line.frame = CGRectMake(index * ChairLabelWidth, ChairLabelHeight - 1, ChairLabelWidth, 1);
    }];
}

#pragma mark -SignDetailViewControllerDelegate
- (void)didClickApplyButtonWithResult:(NSString *)result{
    //显示申请签约结果
    [SVProgressHUD showSuccessWithStatus:result];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

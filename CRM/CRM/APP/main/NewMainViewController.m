//
//  NewMainViewController.m
//  CRM
//
//  Created by fankejun on 14-9-25.
//  Copyright (c) 2014年 TimTiger. All rights reserved.
//

#import "NewMainViewController.h"
#import "CommonMacro.h"
#import "IntroducerViewController.h"
#import "DoctorsViewController.h"
#import "DoctorLibraryViewController.h"
#import "DoctorSquareViewController.h"
#import "PatientsDisplayViewController.h"
#import "GDTMobBannerView.h"
#import "CRMMacro.h"
#import "CreateCaseViewController.h"

@interface NewMainViewController () <GDTMobBannerViewDelegate>
@property (nonatomic,retain) GDTMobBannerView *bannerView;
@end

@implementation NewMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"personal.png"]];
    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"left_navigation_icon"]];
    [self addNotificationObserver];
}

- (void)initData
{
    //headImageArray = [[NSMutableArray alloc]initWithCapacity:0];
    headImageArray = [[NSMutableArray alloc]initWithObjects:@"home_head",@"home_head",@"home_head",@"home_head", nil];
}

- (void)initView
{
    /*
    _bannerView = [[GDTMobBannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,50) appkey:@"1104111725" placementId:@"5080108191557760"];
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 20; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展⽰示关闭按钮;默认显⽰示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载⼲⼴广告并展⽰示
    */
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    imageView.image = [UIImage imageNamed:@"ad_top"];
    [self.view addSubview:imageView];
}
- (void)addNotificationObserver {
    [self addObserveNotificationWithName:MedicalCaseNeedCreateNotification];
}

- (void)removeNotificationObserver {
    [self removeObserverNotificationWithName:MedicalCaseNeedCreateNotification];
}

- (void)handNotification:(NSNotification *)notifacation {
    [super handNotification:notifacation];
    if ([notifacation.name isEqualToString:MedicalCaseNeedCreateNotification]) {
        //收到需要创建病例的通知
        for (UIViewController *tmpVC in self.navigationController.viewControllers) {
            if ([tmpVC isKindOfClass:[PatientsDisplayViewController class]]) {
                [self popToViewController:tmpVC animated:NO];
                break;
            }
        }
        Patient *patient = (Patient *)notifacation.object;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PatientStoryboard" bundle:nil];
        CreateCaseViewController *caseVC = [storyboard instantiateViewControllerWithIdentifier:@"CreateCaseViewController"];
        caseVC.title = @"新建病历";
        caseVC.patiendId = patient.ckeyid;
        [self pushViewController:caseVC animated:YES];
    }
}


#pragma mark -
- (void)dealloc {
    /*
    _bannerView.delegate = nil;
    _bannerView.currentViewController = nil;
    _bannerView = nil;
     */
    [self removeNotificationObserver];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark IBOutlet Event

- (IBAction)unPlantClick:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
    patientVC.patientStatus = PatientStatusUntreatUnPlanted;
    [self pushViewController:patientVC animated:YES];
}

- (IBAction)dateRemindClick:(UIButton *)sender {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    LocalNotificationViewController *logcalNoti = [storyBoard instantiateViewControllerWithIdentifier:@"LocalNotificationViewController"];
//    [self pushViewController:logcalNoti animated:YES];
}

- (IBAction)plantUnfixedClick:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
    patientVC.patientStatus = PatientStatusUnrepaired;
    [self pushViewController:patientVC animated:YES];
}

- (IBAction)introducerClick:(UIButton *)sender {
    NSLog(@"介绍人");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    IntroducerViewController *introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
    [self pushViewController:introducerVC animated:YES];
}

- (IBAction)doctorClick:(UIButton *)sender {
    NSLog(@"医生库");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
    DoctorLibraryViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
    [self pushViewController:doctorVC animated:YES];
}

- (IBAction)patientClick:(UIButton *)sender {
    NSLog(@"患者库");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PatientsDisplayViewController *patientVC = [storyboard instantiateViewControllerWithIdentifier:@"PatientsDisplayViewController"];
    patientVC.patientStatus = PatientStatuspeAll;
    [self pushViewController:patientVC animated:YES];
}

- (IBAction)fixedDoctorClick:(UIButton *)sender {
//    NSLog(@"修复医生");
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    DoctorsViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorsViewController"];
//    [self pushViewController:doctorVC animated:YES];
}

@end

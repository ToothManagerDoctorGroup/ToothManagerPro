//
//  AccountViewController.m
//  CRM
//
//  Created by lsz on 15/9/11.
//  Copyright (c) 2015年 TimTiger. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingViewController.h"
#import "IntroducerViewController.h"
#import "DoctorLibraryViewController.h"
#import "RepairDoctorViewController.h"
#import "MaterialsViewController.h"
#import "DBTableMode.h"
#import "AccountManager.h"
#import "DBManager+User.h"
#import "QrCodeViewController.h"
#import "DBManager+Doctor.h"
#import "UserInfoViewController.h"
#import "ShuJuFenXiViewController.h"
#import "CommonMacro.h"
#import "UIImageView+WebCache.h"

#import "MyClinicViewController.h"
#import "MyBillViewController.h"
#import "WMPageController.h"
#import "PayedBillViewController.h"

#import "DoctorTool.h"
#import "DoctorInfoModel.h"

#import "CRMUserDefalut.h"


@interface AccountViewController (){
    
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_zhangHuCell;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_detailLabel;
    
    
    IBOutlet UITableViewCell *_introducerCell;
    IBOutlet UITableViewCell *_doctorCell;
    IBOutlet UITableViewCell *_repairDoctorCell;
    IBOutlet UITableViewCell *_zhongZhiTiCell;
    IBOutlet UITableViewCell *_tiXingMuBanCell;
    IBOutlet UITableViewCell *_shuJuFenXiCell;
    IBOutlet UITableViewCell *_sheZhiCell;
    IBOutlet UITableViewCell *_myClinicCell;
    
    IBOutlet UITableViewCell *_myBillCell;
    __weak IBOutlet UIImageView *iconImageView;
    
    
}

@property (nonatomic, assign)BOOL isSign; //是否签约

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的空间";
    
  //  _nameLabel.text = [AccountManager shareInstance].currentUser.name;
    
    
    /*
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    //_detailLabel.text = [NSString stringWithFormat:@"%@-%@%@",userobj.hospitalName,userobj.department,userobj.title];
   
    
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
        
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
     */
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    
    UIImage *image1 = [[UIImage imageNamed:@"ic_tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"ic_tabbar_me_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image1 selectedImage:image2];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor colorWithRed:59.0f/255.0f green:161.0f/255.0f blue:233.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateSelected];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
    
    
    //获取当前用户的签约状态
    UserObject *curentUser = [[AccountManager shareInstance] currentUser];
    NSString *key = [NSString stringWithFormat:@"%@isSign",curentUser.userid];
    NSString *signState = [CRMUserDefalut objectForKey:key];
    if ([signState isEqualToString:@"1"]) {
        self.isSign = YES;
    }else if([signState isEqualToString:@"0"]){
        self.isSign = NO;
    }else{
        [SVProgressHUD showWithStatus:@"正在加载"];
        //请求网络数据获取医生的信息
        [DoctorTool requestDoctorInfoWithDoctorId:[AccountManager shareInstance].currentUser.userid success:^(DoctorInfoModel *dcotorInfo) {
            [SVProgressHUD dismiss];
            //保存当前的状态
            [CRMUserDefalut setObject:dcotorInfo.is_sign forKey:key];
            //设置当前的签约状态
            self.isSign = [dcotorInfo.is_sign isEqualToString:@"1"] ? YES : NO;
            //刷新表视图
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
}

//获取用户的医生列表
- (void)getDoctorListSuccessWithResult:(NSDictionary *)result {
    [SVProgressHUD dismiss];
    NSArray *dicArray = [result objectForKey:@"Result"];
    if (dicArray && dicArray.count > 0) {
        for (NSDictionary *dic in dicArray) {
                UserObject *obj = [UserObject userobjectFromDic:dic];
                [[DBManager shareInstance] updateUserWithUserObject:obj];
                [[AccountManager shareInstance] refreshCurrentUserInfo];
                _detailLabel.text = [NSString stringWithFormat:@"%@-%@%@",obj.hospitalName,obj.department,obj.title];
                _nameLabel.text = obj.name;
            if(obj.img.length > 0){
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:obj.img]];
            }else{
                [iconImageView setImage:[UIImage imageNamed:@"user_icon"]];
            }
            [self refreshView];
            return;
        }
    }
}
- (void)getDoctorListFailedWithError:(NSError *)error {
    [SVProgressHUD showImage:nil status:error.localizedDescription];
}

- (void)viewWillAppear:(BOOL)animated
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UserObject *userobj = [[AccountManager shareInstance] currentUser];
    [[DoctorManager shareInstance] getDoctorListWithUserId:userobj.userid successBlock:^{
        
    } failedBlock:^(NSError *error) {
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSign == YES) {
        return 5;
    }else{
        return 4;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSign == YES) {
        if(section==0){
            return 1;
        }else if (section==1){
            return 4;
        }else if (section==2){
            return 2;
        }else if (section==3){
            return 1;
        }else{
            return 1;
        }
    }else{
        if(section==0){
            return 1;
        }else if (section==1){
            return 4;
        }else if (section==2){
            return 1;
        }else{
            return 1;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isSign == YES) {
        if(section == 4){
            return 30;
        }
    }else{
        if(section == 3){
            return 30;
        }
    }
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
    return view;
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.isSign == YES) {
        if(section == 4){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            // [view setBackgroundColor:[UIColor lightGrayColor]];
            
            view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
            
            return view;
        }
    }else{
        if(section == 3){
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            // [view setBackgroundColor:[UIColor lightGrayColor]];
            
            view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1];
            
            return view;
        }
    }
    
    
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}
 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isSign == YES) {
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if(indexPath.row == 0){
                return _introducerCell;
            }else if (indexPath.row == 1){
                return _doctorCell;
            }else if (indexPath.row == 2){
                return _repairDoctorCell;
            }else if (indexPath.row == 3){
                return _zhongZhiTiCell;
            }
        }else if (indexPath.section == 2){
            
            if(indexPath.row == 0){
                return _myBillCell;
            }else if (indexPath.row == 1){
                return _myClinicCell;
            }
        }else if (indexPath.section == 3){
            return _shuJuFenXiCell;
        }else if (indexPath.section == 4){
            return _sheZhiCell;
        }
    }else{
        if(indexPath.section == 0){
            return _zhangHuCell;
        }else if (indexPath.section == 1){
            if(indexPath.row == 0){
                return _introducerCell;
            }else if (indexPath.row == 1){
                return _doctorCell;
            }else if (indexPath.row == 2){
                return _repairDoctorCell;
            }else if (indexPath.row == 3){
                return _zhongZhiTiCell;
            }
        }else if (indexPath.section == 2){
            return _shuJuFenXiCell;
        }else if (indexPath.section == 3){
            return _sheZhiCell;
        }
    }
    
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 70;
    }else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            UserInfoViewController *userInfoVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
            userInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            IntroducerViewController *introducerVC = [storyboard instantiateViewControllerWithIdentifier:@"IntroducerViewController"];
            introducerVC.isHome = NO;
            introducerVC.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:introducerVC animated:YES];
        }else if (indexPath.row == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DoctorStoryboard" bundle:nil];
            DoctorLibraryViewController *doctorVC = [storyboard instantiateViewControllerWithIdentifier:@"DoctorLibraryViewController"];
            doctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:doctorVC animated:YES];
        }else if (indexPath.row == 2){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            RepairDoctorViewController *repairDoctorVC = [storyboard instantiateViewControllerWithIdentifier:@"RepairDoctorViewController"];
            repairDoctorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:repairDoctorVC animated:YES];
        }else if (indexPath.row == 3){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            MaterialsViewController *materialsVC = [storyboard instantiateViewControllerWithIdentifier:@"MaterialsViewController"];
            materialsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:materialsVC animated:YES];
        }else if (indexPath.row == 4){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            MyClinicViewController *clinicVc = [storyboard instantiateViewControllerWithIdentifier:@"MyClinicViewController"];
            clinicVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:clinicVc animated:YES];
            
        }
    }
    if (self.isSign == YES) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                
                WMPageController *pageController = [self p_defaultController];
                pageController.title = @"我的账单";
                pageController.menuViewStyle = WMMenuViewStyleLine;
                pageController.titleSizeSelected = 15;
                pageController.titleColorSelected = MyColor(0, 139, 232);
                pageController.menuHeight = 44;
                pageController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pageController animated:YES];
                
                
            }else if(indexPath.row == 1){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                MyClinicViewController *clinicVc = [storyboard instantiateViewControllerWithIdentifier:@"MyClinicViewController"];
                clinicVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:clinicVc animated:YES];
            }
        }
        
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                ShuJuFenXiViewController *shuju = [[ShuJuFenXiViewController alloc]initWithNibName:@"ShuJuFenXiViewController" bundle:nil];
                shuju.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shuju animated:YES];
            }
        }
        if(indexPath.section == 4){
            if(indexPath.row == 0){
                SettingViewController *set = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
                
            }
            
        }
    }else{
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                ShuJuFenXiViewController *shuju = [[ShuJuFenXiViewController alloc]initWithNibName:@"ShuJuFenXiViewController" bundle:nil];
                shuju.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:shuju animated:YES];
            }
        }
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                SettingViewController *set = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
                
            }
            
        }
    }
    
    
}

//创建控制器
- (WMPageController *)p_defaultController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    Class class;
    for (int i = 0; i < 2; i++) {
        NSString *title;
        if (i == 0) {
            title = @"待付款";
            class = [MyBillViewController class];
        }else{
            title = @"已付款";
            class = [PayedBillViewController class];
        }
        [viewControllers addObject:class];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = kScreenWidth * 0.5;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
